import 'dart:async';
import 'dart:collection';

import 'package:aqedu/core/services_root/supabase/supabase_config.dart';
import 'package:aqedu/features/chat/models/chat_message.dart';
import 'package:aqedu/features/chat/models/chat_thread.dart';
import 'package:aqedu/features/chat/models/chat_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

String generateConversationId(String a, String b) {
  final first = a.trim();
  final second = b.trim();

  if (first.isEmpty || second.isEmpty) {
    throw ArgumentError.value(
      '$a, $b',
      'a/b',
      'Conversation participants must not be empty',
    );
  }

  final participants = [first, second]..sort((left, right) => left.compareTo(right));
  return participants.join('_');
}

class ChatService {
  ChatService({
    SupabaseClient? client,
  }) : _client = client ?? SupabaseConfig.client;

  static const String usersTable = 'users';
  static const String conversationsTable = 'conversations';
  static const String messagesTable = 'messages';

  final SupabaseClient _client;

  Future<ChatUser?> getUserByStudentId(String studentId) async {
    final normalizedStudentId = _normalizeStudentId(studentId);
    if (normalizedStudentId.isEmpty) return null;

    final response = await _client
        .from(usersTable)
        .select()
        .eq('student_id', normalizedStudentId)
        .maybeSingle();
    if (response == null) return null;

    return ChatUser.fromJson(Map<String, dynamic>.from(response));
  }

  Future<ChatUser> ensureUserByStudentId(String studentId) async {
    final normalizedStudentId = _normalizeStudentId(studentId);
    if (normalizedStudentId.isEmpty) {
      throw ArgumentError.value(studentId, 'studentId', 'Student id is empty');
    }

    final existingUser = await getUserByStudentId(normalizedStudentId);
    if (existingUser != null) return existingUser;

    final response = await _client
        .from(usersTable)
        .insert({
          'student_id': normalizedStudentId,
          'full_name': normalizedStudentId,
        })
        .select()
        .maybeSingle();

    if (response == null) {
      final retryUser = await getUserByStudentId(normalizedStudentId);
      if (retryUser != null) return retryUser;
      throw StateError('Unable to ensure chat user for student "$studentId"');
    }

    return ChatUser.fromJson(Map<String, dynamic>.from(response));
  }

  Future<ChatUser> upsertUserProfile(ChatUser user) async {
    final response = await _client
        .from(usersTable)
        .upsert(user.toUpsertJson(), onConflict: 'student_id')
        .select()
        .single();

    return ChatUser.fromJson(Map<String, dynamic>.from(response));
  }

  Future<List<ChatUser>> searchUsers({
    required String keyword,
    String? excludeStudentId,
    int limit = 20,
  }) async {
    final normalizedKeyword = keyword.trim();
    if (normalizedKeyword.isEmpty) return [];

    final normalizedExclude = excludeStudentId?.trim();
    final pattern = '%${normalizedKeyword.replaceAll('%', r'\\%')}%';

    final query = _client.from(usersTable).select();
    final queryWithCondition = query.or('student_id.ilike.$pattern,full_name.ilike.$pattern');
    final finalQuery = normalizedExclude == null || normalizedExclude.isEmpty
        ? queryWithCondition
        : queryWithCondition.neq('student_id', normalizedExclude);

    final response = await finalQuery
        .order('full_name', ascending: true)
        .limit(limit);

    return _asRows(response).map(ChatUser.fromJson).toList();
  }

  Future<List<ChatThread>> loadChatThreads({
    required String currentStudentId,
    int limit = 200,
  }) async {
    final response = await _client
        .from(conversationsTable)
        .select()
        .or('and(user_1.eq.$currentStudentId),and(user_2.eq.$currentStudentId)')
        .order('updated_at', ascending: false)
        .limit(limit);

    final rows = _asRows(response);
    final studentIds = rows
        .map((row) {
          final a = row['user_1']?.toString() ?? '';
          final b = row['user_2']?.toString() ?? '';
          return a == currentStudentId ? b : a;
        })
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();

    final usersByStudentId = await _loadUsersByStudentIds(studentIds);

    return rows.map((row) {
      final peerStudentId = _peerStudentIdFromConversation(row, currentStudentId);
      final peer = usersByStudentId[peerStudentId] ?? ChatUser(
        id: peerStudentId,
        studentId: peerStudentId,
        fullName: peerStudentId,
        avatarUrl: '',
        faculty: '',
        className: '',
      );

      return ChatThread(
        conversationId: row['id'].toString(),
        peer: peer,
        lastMessage: row['last_message']?.toString() ?? '',
        lastSenderStudentId: row['last_sender_id']?.toString() ?? '',
        updatedAt: _parseDateTime(row['updated_at']),
      );
    }).toList();
  }

  Stream<List<ChatThread>> streamChatThreads({
    required String currentStudentId,
    int limit = 200,
  }) {
    final controller = StreamController<List<ChatThread>>.broadcast();
    RealtimeChannel? channel;

    Future<void> emitThreads() async {
      try {
        final threads = await loadChatThreads(
          currentStudentId: currentStudentId,
          limit: limit,
        );
        _safeAdd(controller, List<ChatThread>.unmodifiable(threads));
      } catch (error, stackTrace) {
        _safeAddError(controller, error, stackTrace);
      }
    }

    void applyRealtimePayload(PostgresChangePayload payload) {
      final record = payload.eventType == PostgresChangeEvent.delete
          ? payload.oldRecord
          : payload.newRecord;

      final a = record['user_1']?.toString() ?? '';
      final b = record['user_2']?.toString() ?? '';
      if (a != currentStudentId && b != currentStudentId) return;

      unawaited(emitThreads());
    }

    controller.onListen = () {
      if (channel != null) return;

      channel = _client.channel(_realtimeTopic('conversations', currentStudentId))
        ..onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: conversationsTable,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_1',
            value: currentStudentId,
          ),
          callback: applyRealtimePayload,
        )
        ..onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: conversationsTable,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_2',
            value: currentStudentId,
          ),
          callback: applyRealtimePayload,
        )
        ..subscribe((status, [error]) {
          if (status == RealtimeSubscribeStatus.channelError ||
              status == RealtimeSubscribeStatus.timedOut) {
            _safeAddError(
              controller,
              StateError('Realtime subscribe failed: $status'),
              StackTrace.current,
            );
          }
        });

      unawaited(emitThreads());
    };

    controller.onCancel = () async {
      final currentChannel = channel;
      channel = null;
      if (currentChannel != null) {
        await _client.removeChannel(currentChannel);
      }
    };

    return controller.stream;
  }

  Future<List<ChatMessage>> loadConversation({
    required String conversationId,
    int limit = 80,
  }) async {
    final response = await _client
        .from(messagesTable)
        .select()
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: true)
        .limit(limit);

    return _asRows(response).map(ChatMessage.fromJson).toList();
  }

  Stream<List<ChatMessage>> streamConversation({
    required String conversationId,
    int limit = 80,
  }) {
    final messages = <ChatMessage>[];
    final controller = StreamController<List<ChatMessage>>.broadcast();
    RealtimeChannel? channel;

    Future<void> emitInitialMessages() async {
      try {
        final initialMessages = await loadConversation(
          conversationId: conversationId,
          limit: limit,
        );
        messages
          ..clear()
          ..addAll(initialMessages);
        _sortMessagesAscending(messages);
        _safeAdd(controller, List<ChatMessage>.unmodifiable(messages));
      } catch (error, stackTrace) {
        _safeAddError(controller, error, stackTrace);
      }
    }

    void applyRealtimePayload(PostgresChangePayload payload) {
      final record = payload.eventType == PostgresChangeEvent.delete
          ? payload.oldRecord
          : payload.newRecord;

      final message = ChatMessage.fromJson(record);
      if (payload.eventType == PostgresChangeEvent.delete) {
        _removeMessage(messages, record['id']);
      } else {
        _upsertMessage(messages, message);
      }

      _sortMessagesAscending(messages);
      _safeAdd(controller, List<ChatMessage>.unmodifiable(messages));
    }

    controller.onListen = () {
      if (channel != null) return;

      channel = _client.channel(_realtimeTopic('messages', conversationId))
        ..onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: messagesTable,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'conversation_id',
            value: conversationId,
          ),
          callback: applyRealtimePayload,
        )
        ..subscribe((status, [error]) {
          if (status == RealtimeSubscribeStatus.channelError ||
              status == RealtimeSubscribeStatus.timedOut) {
            _safeAddError(
              controller,
              StateError('Realtime subscribe failed: $status'),
              StackTrace.current,
            );
          }
        });

      unawaited(emitInitialMessages());
    };

    controller.onCancel = () async {
      final currentChannel = channel;
      channel = null;
      if (currentChannel != null) {
        await _client.removeChannel(currentChannel);
      }
    };

    return controller.stream;
  }

  Stream<ChatMessage> streamIncomingMessages({
    required String currentStudentId,
  }) {
    final controller = StreamController<ChatMessage>.broadcast();
    final recentMessageIds = LinkedHashSet<String>();
    RealtimeChannel? channel;

    void applyRealtimePayload(PostgresChangePayload payload) {
      if (payload.eventType != PostgresChangeEvent.insert) return;
      final record = payload.newRecord;
      if (record == null) return;

      final message = ChatMessage.fromJson(record);
      if (message.receiverStudentId != currentStudentId) return;

      final messageId = message.id.toString();
      if (recentMessageIds.contains(messageId)) return;
      recentMessageIds.add(messageId);
      if (recentMessageIds.length > 500) {
        recentMessageIds.remove(recentMessageIds.first);
      }

      _safeAdd(controller, message);
    }

    void subscribeChannel() {
      if (controller.isClosed) return;

      channel = _client.channel(_realtimeTopic('messages', currentStudentId))
        ..onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: messagesTable,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'receiver_student_id',
            value: currentStudentId,
          ),
          callback: applyRealtimePayload,
        )
        ..subscribe((status, [error]) async {
          if (status == RealtimeSubscribeStatus.channelError ||
              status == RealtimeSubscribeStatus.timedOut ||
              status == RealtimeSubscribeStatus.closed) {
            _safeAddError(
              controller,
              StateError('Realtime subscribe failed: $status'),
              StackTrace.current,
            );

            final currentChannel = channel;
            channel = null;
            if (currentChannel != null) {
              await _client.removeChannel(currentChannel);
            }

            if (!controller.isClosed) {
              Future.delayed(const Duration(seconds: 4), () {
                if (!controller.isClosed) {
                  subscribeChannel();
                }
              });
            }
          }
        });
    }

    controller.onListen = () {
      if (channel != null) return;
      subscribeChannel();
    };

    controller.onCancel = () async {
      final currentChannel = channel;
      channel = null;
      if (currentChannel != null) {
        await _client.removeChannel(currentChannel);
      }
    };

    return controller.stream;
  }

  Future<String?> getConversationId({
    required String currentStudentId,
    required String otherStudentId,
  }) async {
    final conversationId = generateConversationId(currentStudentId, otherStudentId);

    final response = await _client
        .from(conversationsTable)
        .select()
        .eq('id', conversationId)
        .maybeSingle();

    if (response == null) return null;
    return response['id']?.toString();
  }

  Future<String> ensureConversation({
    required String currentStudentId,
    required String otherStudentId,
    required String lastMessage,
    required String lastSenderId,
  }) async {
    if (currentStudentId == otherStudentId) {
      throw ArgumentError.value(
        otherStudentId,
        'otherStudentId',
        'Conversation cannot be created with the same student id',
      );
    }

    final participants = _sortParticipants(currentStudentId, otherStudentId);
    final conversationId = generateConversationId(currentStudentId, otherStudentId);

    final response = await _client
        .from(conversationsTable)
        .upsert(
          {
            'id': conversationId,
            'user_1': participants.first,
            'user_2': participants.last,
            'last_message': lastMessage,
            'last_sender_id': lastSenderId,
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          },
          onConflict: 'id',
        )
        .select()
        .single();

    final row = Map<String, dynamic>.from(response);
    return row['id'].toString();
  }

  Future<ChatMessage> sendMessage({
    required String conversationId,
    required String senderStudentId,
    required String receiverStudentId,
    required String message,
  }) async {
    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty) {
      throw ArgumentError.value(message, 'message', 'Message is empty');
    }

    final response = await _client
        .from(messagesTable)
        .insert({
          'conversation_id': conversationId,
          'sender_student_id': senderStudentId,
          'receiver_student_id': receiverStudentId,
          'message': trimmedMessage,
          'message_type': 'text',
          'is_seen': false,
        })
        .select()
        .single();

    await _client
        .from(conversationsTable)
        .update({
          'last_message': trimmedMessage,
          'last_sender_id': senderStudentId,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', conversationId);

    return ChatMessage.fromJson(Map<String, dynamic>.from(response));
  }

  void _sortMessagesAscending(List<ChatMessage> messages) {
    messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  void _removeMessage(List<ChatMessage> messages, dynamic id) {
    messages.removeWhere((message) => message.id.toString() == id.toString());
  }

  void _upsertMessage(List<ChatMessage> messages, ChatMessage message) {
    final index = messages.indexWhere((item) => item.id.toString() == message.id.toString());
    if (index == -1) {
      messages.add(message);
    } else {
      messages[index] = message;
    }
  }

  Future<Map<String, ChatUser>> _loadUsersByStudentIds(List<String> studentIds) async {
    if (studentIds.isEmpty) return {};

    final response = await _client
        .from(usersTable)
        .select()
        .inFilter('student_id', studentIds);

    final rows = _asRows(response);
    return {
      for (final row in rows)
        row['student_id'].toString(): ChatUser.fromJson(row),
    };
  }

  List<Map<String, dynamic>> _asRows(dynamic response) {
    return (response as List)
        .map((row) => Map<String, dynamic>.from(row as Map))
        .toList();
  }

  String _peerStudentIdFromConversation(
    Map<String, dynamic> conversation,
    String currentStudentId,
  ) {
    final a = conversation['user_1']?.toString() ?? '';
    final b = conversation['user_2']?.toString() ?? '';
    return a == currentStudentId ? b : a;
  }

  List<String> _sortParticipants(String first, String second) {
    return first.compareTo(second) <= 0 ? [first, second] : [second, first];
  }

  String _normalizeStudentId(String value) {
    return value.trim();
  }

  DateTime _parseDateTime(dynamic value) {
    if (value is DateTime) return value;
    if (value != null) {
      final parsed = DateTime.tryParse(value.toString());
      if (parsed != null) return parsed;
    }
    return DateTime.now().toUtc();
  }

  String _realtimeTopic(String scope, String studentId) {
    final normalized = studentId.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    return 'chat-$scope-$normalized';
  }

  void _safeAdd<T>(StreamController<T> controller, T event) {
    if (!controller.isClosed) controller.add(event);
  }

  void _safeAddError(
    StreamController<dynamic> controller,
    Object error,
    StackTrace stackTrace,
  ) {
    if (!controller.isClosed) controller.addError(error, stackTrace);
  }
}
