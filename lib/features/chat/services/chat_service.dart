import 'dart:async';

import 'package:aqedu/core/services_root/supabase/supabase_config.dart';
import 'package:aqedu/features/chat/models/chat_message.dart';
import 'package:aqedu/features/chat/models/chat_thread.dart';
import 'package:aqedu/features/chat/models/chat_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatService {
  ChatService({SupabaseClient? client})
    : _client = client ?? SupabaseConfig.client;

  static const String usersTable = 'users';
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

    try {
      final response = await _client
          .from(usersTable)
          .insert({'student_id': normalizedStudentId})
          .select()
          .single();

      return ChatUser.fromJson(Map<String, dynamic>.from(response));
    } on PostgrestException catch (error) {
      if (_isRlsDenied(error)) {
        throw StateError(
          'Supabase RLS is blocking insert on table "$usersTable". '
          'Run supabase/chat_rls_policies.sql in Supabase SQL Editor.',
        );
      }
      if (error.code == '23505') {
        final racedUser = await getUserByStudentId(normalizedStudentId);
        if (racedUser != null) return racedUser;
      }
      rethrow;
    }
  }

  Future<List<ChatUser>> searchUsers({
    required String keyword,
    String? excludeStudentId,
    int limit = 20,
  }) async {
    final normalizedKeyword = keyword.trim();
    final normalizedExclude = excludeStudentId?.trim();
    final rows = normalizedKeyword.isEmpty
        ? await _loadUsers(excludeStudentId: normalizedExclude, limit: limit)
        : await _searchUsersByStudentId(
            keyword: normalizedKeyword,
            excludeStudentId: normalizedExclude,
            limit: limit,
          );

    return rows.map(ChatUser.fromJson).toList();
  }

  Future<List<ChatMessage>> loadConversation({
    required Object currentUserId,
    required Object otherUserId,
    int limit = 80,
  }) async {
    final outgoing = await _loadMessagesBetween(
      senderId: currentUserId,
      receiverId: otherUserId,
      limit: limit,
    );
    final incoming = await _loadMessagesBetween(
      senderId: otherUserId,
      receiverId: currentUserId,
      limit: limit,
    );

    return _mergeMessages([...outgoing, ...incoming], limit: limit);
  }

  Future<List<ChatMessage>> loadMessagesForUser({
    required Object currentUserId,
    int limit = 200,
  }) async {
    final sent = await _loadMessagesByColumn(
      column: 'sender_id',
      userId: currentUserId,
      limit: limit,
    );
    final received = await _loadMessagesByColumn(
      column: 'receiver_id',
      userId: currentUserId,
      limit: limit,
    );

    return _mergeMessages([...sent, ...received], limit: limit);
  }

  Future<ChatMessage> sendMessage({
    required Object senderId,
    required Object receiverId,
    required String message,
  }) async {
    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty) {
      throw ArgumentError.value(message, 'message', 'Message is empty');
    }

    try {
      final response = await _client
          .from(messagesTable)
          .insert({
            'sender_id': senderId,
            'receiver_id': receiverId,
            'message': trimmedMessage,
          })
          .select()
          .single();

      return ChatMessage.fromJson(Map<String, dynamic>.from(response));
    } on PostgrestException catch (error) {
      if (_isRlsDenied(error)) {
        throw StateError(
          'Supabase RLS is blocking insert on table "$messagesTable". '
          'Run supabase/chat_rls_policies.sql in Supabase SQL Editor.',
        );
      }
      rethrow;
    }
  }

  Stream<List<ChatMessage>> streamConversation({
    required Object currentUserId,
    required Object otherUserId,
    int limit = 80,
  }) {
    final messages = <ChatMessage>[];
    final controller = StreamController<List<ChatMessage>>.broadcast();
    RealtimeChannel? channel;

    Future<void> emitInitialMessages() async {
      try {
        final initialMessages = await loadConversation(
          currentUserId: currentUserId,
          otherUserId: otherUserId,
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

      if (!_isConversationRecord(record, currentUserId, otherUserId)) return;

      if (payload.eventType == PostgresChangeEvent.delete) {
        _removeMessage(messages, record['id']);
      } else {
        _upsertMessage(messages, ChatMessage.fromJson(record));
      }

      _sortMessagesAscending(messages);
      _safeAdd(controller, List<ChatMessage>.unmodifiable(messages));
    }

    controller.onListen = () {
      if (channel != null) return;

      channel =
          _client.channel(
              _realtimeTopic('conversation', currentUserId, otherUserId),
            )
            ..onPostgresChanges(
              event: PostgresChangeEvent.all,
              schema: 'public',
              table: messagesTable,
              filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'sender_id',
                value: currentUserId,
              ),
              callback: applyRealtimePayload,
            )
            ..onPostgresChanges(
              event: PostgresChangeEvent.all,
              schema: 'public',
              table: messagesTable,
              filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'sender_id',
                value: otherUserId,
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

  Stream<List<ChatThread>> streamChatThreads({
    required Object currentUserId,
    int limit = 200,
  }) {
    final messages = <ChatMessage>[];
    final controller = StreamController<List<ChatThread>>.broadcast();
    RealtimeChannel? channel;
    var emitVersion = 0;

    Future<void> emitThreads() async {
      final version = ++emitVersion;
      try {
        final threads = await _buildThreadsFromMessages(
          currentUserId: currentUserId,
          messages: messages,
        );
        if (version == emitVersion) {
          _safeAdd(controller, List<ChatThread>.unmodifiable(threads));
        }
      } catch (error, stackTrace) {
        _safeAddError(controller, error, stackTrace);
      }
    }

    Future<void> emitInitialThreads() async {
      try {
        final initialMessages = await loadMessagesForUser(
          currentUserId: currentUserId,
          limit: limit,
        );
        messages
          ..clear()
          ..addAll(initialMessages);
        _sortMessagesDescending(messages);
        await emitThreads();
      } catch (error, stackTrace) {
        _safeAddError(controller, error, stackTrace);
      }
    }

    void applyRealtimePayload(PostgresChangePayload payload) {
      final record = payload.eventType == PostgresChangeEvent.delete
          ? payload.oldRecord
          : payload.newRecord;

      if (!_recordContainsUser(record, currentUserId)) return;

      if (payload.eventType == PostgresChangeEvent.delete) {
        _removeMessage(messages, record['id']);
      } else {
        _upsertMessage(messages, ChatMessage.fromJson(record));
      }

      _sortMessagesDescending(messages);
      unawaited(emitThreads());
    }

    controller.onListen = () {
      if (channel != null) return;

      channel = _client.channel(_realtimeTopic('threads', currentUserId))
        ..onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: messagesTable,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'sender_id',
            value: currentUserId,
          ),
          callback: applyRealtimePayload,
        )
        ..onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: messagesTable,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'receiver_id',
            value: currentUserId,
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

      unawaited(emitInitialThreads());
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

  Future<List<Map<String, dynamic>>> _loadUsers({
    required String? excludeStudentId,
    required int limit,
  }) async {
    final response = excludeStudentId == null || excludeStudentId.isEmpty
        ? await _client
              .from(usersTable)
              .select()
              .order('student_id', ascending: true)
              .limit(limit)
        : await _client
              .from(usersTable)
              .select()
              .neq('student_id', excludeStudentId)
              .order('student_id', ascending: true)
              .limit(limit);

    return _asRows(response);
  }

  Future<List<Map<String, dynamic>>> _searchUsersByStudentId({
    required String keyword,
    required String? excludeStudentId,
    required int limit,
  }) async {
    final pattern = '%${keyword.replaceAll('%', r'\%')}%';
    final response = excludeStudentId == null || excludeStudentId.isEmpty
        ? await _client
              .from(usersTable)
              .select()
              .ilike('student_id', pattern)
              .order('student_id', ascending: true)
              .limit(limit)
        : await _client
              .from(usersTable)
              .select()
              .ilike('student_id', pattern)
              .neq('student_id', excludeStudentId)
              .order('student_id', ascending: true)
              .limit(limit);

    return _asRows(response);
  }

  Future<List<ChatMessage>> _loadMessagesBetween({
    required Object senderId,
    required Object receiverId,
    required int limit,
  }) async {
    final response = await _client
        .from(messagesTable)
        .select()
        .eq('sender_id', senderId)
        .eq('receiver_id', receiverId)
        .order('created_at', ascending: false)
        .limit(limit);

    return _asRows(response).map(ChatMessage.fromJson).toList();
  }

  Future<List<ChatMessage>> _loadMessagesByColumn({
    required String column,
    required Object userId,
    required int limit,
  }) async {
    final response = await _client
        .from(messagesTable)
        .select()
        .eq(column, userId)
        .order('created_at', ascending: false)
        .limit(limit);

    return _asRows(response).map(ChatMessage.fromJson).toList();
  }

  Future<List<ChatThread>> _buildThreadsFromMessages({
    required Object currentUserId,
    required List<ChatMessage> messages,
  }) async {
    final lastMessageByPeer = <String, ChatMessage>{};
    final peerIdsByKey = <String, Object>{};

    for (final message in messages) {
      final peerId = message.peerIdOf(currentUserId);
      final peerKey = peerId.toString();
      peerIdsByKey[peerKey] = peerId;

      final currentLastMessage = lastMessageByPeer[peerKey];
      if (currentLastMessage == null ||
          message.createdAt.isAfter(currentLastMessage.createdAt)) {
        lastMessageByPeer[peerKey] = message;
      }
    }

    final usersById = await _loadUsersByIds(peerIdsByKey.values.toList());
    final threads = <ChatThread>[];

    for (final entry in lastMessageByPeer.entries) {
      final peerId = peerIdsByKey[entry.key]!;
      final peer =
          usersById[entry.key] ??
          ChatUser(id: peerId, studentId: peerId.toString());

      threads.add(ChatThread(peer: peer, lastMessage: entry.value));
    }

    threads.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return threads;
  }

  Future<Map<String, ChatUser>> _loadUsersByIds(List<Object> ids) async {
    if (ids.isEmpty) return {};

    final filterValues = ids.every((id) => id is num)
        ? ids
        : ids.map((id) => id.toString()).toList();

    final response = await _client
        .from(usersTable)
        .select()
        .inFilter('id', filterValues.toList());

    final users = _asRows(response).map(ChatUser.fromJson);
    return {for (final user in users) user.id.toString(): user};
  }

  List<Map<String, dynamic>> _asRows(dynamic response) {
    return (response as List)
        .map((row) => Map<String, dynamic>.from(row as Map))
        .toList();
  }

  List<ChatMessage> _mergeMessages(
    List<ChatMessage> messages, {
    required int limit,
  }) {
    final byId = <String, ChatMessage>{};
    for (final message in messages) {
      byId[message.id.toString()] = message;
    }

    final merged = byId.values.toList();
    _sortMessagesDescending(merged);
    return merged.take(limit).toList().reversed.toList();
  }

  void _upsertMessage(List<ChatMessage> messages, ChatMessage message) {
    final index = messages.indexWhere(
      (item) => item.id.toString() == message.id.toString(),
    );

    if (index == -1) {
      messages.add(message);
    } else {
      messages[index] = message;
    }
  }

  void _removeMessage(List<ChatMessage> messages, Object? messageId) {
    if (messageId == null) return;
    messages.removeWhere((message) => message.id.toString() == '$messageId');
  }

  void _sortMessagesAscending(List<ChatMessage> messages) {
    messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  void _sortMessagesDescending(List<ChatMessage> messages) {
    messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  bool _isConversationRecord(
    Map<String, dynamic> record,
    Object currentUserId,
    Object otherUserId,
  ) {
    final senderId = record['sender_id'];
    final receiverId = record['receiver_id'];

    if (senderId == null || receiverId == null) return false;

    final sender = senderId.toString();
    final receiver = receiverId.toString();
    final current = currentUserId.toString();
    final other = otherUserId.toString();

    return (sender == current && receiver == other) ||
        (sender == other && receiver == current);
  }

  bool _recordContainsUser(Map<String, dynamic> record, Object userId) {
    final senderId = record['sender_id'];
    final receiverId = record['receiver_id'];
    final current = userId.toString();

    return senderId?.toString() == current || receiverId?.toString() == current;
  }

  String _normalizeStudentId(String value) {
    return value.trim();
  }

  bool _isRlsDenied(PostgrestException error) {
    return error.code == '42501';
  }

  String _realtimeTopic(String scope, Object firstId, [Object? secondId]) {
    final first = firstId.toString().replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    final second = secondId?.toString().replaceAll(
      RegExp(r'[^a-zA-Z0-9_-]'),
      '_',
    );
    final timestamp = DateTime.now().microsecondsSinceEpoch;

    return second == null
        ? 'chat-$scope-$first-$timestamp'
        : 'chat-$scope-$first-$second-$timestamp';
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
