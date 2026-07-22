import 'dart:async';

import 'package:aqedu/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:aqedu/features/chat/models/chat_message.dart';
import 'package:aqedu/features/chat/models/chat_thread.dart';
import 'package:aqedu/features/chat/models/chat_user.dart';
import 'package:aqedu/features/chat/services/chat_service.dart';
import 'package:aqedu/features/chat/services/chat_student_info_service.dart';
import 'package:aqedu/features/chat/services/chat_user_sync_service.dart';

class ChatRepository {
  ChatRepository({
    ChatRemoteDataSource? chatService,
    ChatLocalDataSource? localDataSource,
    ChatUserSyncService? userSyncService,
    ChatStudentInfoService? studentInfoService,
  }) : _chatService = chatService ?? ChatService(),
       _localDataSource = localDataSource ?? SqliteChatLocalDataSource(),
       _userSyncService = userSyncService,
       _studentInfoService = studentInfoService;

  final ChatRemoteDataSource _chatService;
  final ChatLocalDataSource _localDataSource;
  ChatUserSyncService? _userSyncService;
  ChatStudentInfoService? _studentInfoService;

  Future<ChatUser> syncCurrentSessionUser() async {
    final studentData = await (_studentInfoService ??= ChatStudentInfoService())
        .getCurrentStudentData();
    final user = studentData == null
        ? await (_userSyncService ??= ChatUserSyncService())
              .syncCurrentSessionUser()
        : await (_userSyncService ??= ChatUserSyncService())
              .syncStudentIdWithStudentData(studentData);
    await _localDataSource.saveUser(user);
    return user;
  }

  Future<ChatUser?> getUserByStudentId(String studentId) async {
    try {
      final user = await _chatService.getUserByStudentId(studentId);
      if (user != null) await _localDataSource.saveUser(user);
      return user;
    } catch (_) {
      return _localDataSource.readUser(studentId);
    }
  }

  Future<ChatUser> ensureUserByStudentId(String studentId) async {
    final user = await _chatService.ensureUserByStudentId(studentId);
    await _localDataSource.saveUser(user);
    return user;
  }

  Future<List<ChatUser>> searchUsers({
    required String keyword,
    required String excludeStudentId,
    int limit = 20,
  }) async {
    try {
      final users = await _chatService.searchUsers(
        keyword: keyword,
        excludeStudentId: excludeStudentId,
        limit: limit,
      );
      for (final user in users) {
        await _localDataSource.saveUser(user);
      }
      return users;
    } catch (_) {
      return _localDataSource.searchUsers(keyword, limit: limit);
    }
  }

  Stream<List<ChatThread>> streamChatThreads({
    required String currentStudentId,
    int limit = 200,
  }) {
    return _localFirstStream(
      readLocal: () => _localDataSource.readThreads(limit: limit),
      remote: _chatService.streamChatThreads(
        currentStudentId: currentStudentId,
        limit: limit,
      ),
      saveRemote: _localDataSource.replaceThreads,
    );
  }

  Future<List<ChatMessage>> loadConversationMessages({
    required String conversationId,
    int limit = 80,
  }) async {
    try {
      final messages = await _chatService.loadConversation(
        conversationId: conversationId,
        limit: limit,
      );
      await _localDataSource.replaceMessages(conversationId, messages);
      return _localDataSource.readMessages(conversationId, limit: limit);
    } catch (_) {
      return _localDataSource.readMessages(conversationId, limit: limit);
    }
  }

  Stream<List<ChatMessage>> streamConversationMessages({
    required String conversationId,
    int limit = 80,
  }) {
    return _localFirstStream(
      readLocal: () =>
          _localDataSource.readMessages(conversationId, limit: limit),
      remote: _chatService.streamConversation(
        conversationId: conversationId,
        limit: limit,
      ),
      saveRemote: (messages) =>
          _localDataSource.replaceMessages(conversationId, messages),
    );
  }

  Future<ChatMessage> sendMessage({
    required String conversationId,
    required String senderStudentId,
    required String receiverStudentId,
    required String message,
  }) async {
    final sent = await _chatService.sendMessage(
      conversationId: conversationId,
      senderStudentId: senderStudentId,
      receiverStudentId: receiverStudentId,
      message: message,
    );
    await _localDataSource.upsertMessage(sent);
    return sent;
  }

  Future<String?> getConversationId({
    required String currentStudentId,
    required String otherStudentId,
  }) async {
    try {
      return await _chatService.getConversationId(
        currentStudentId: currentStudentId,
        otherStudentId: otherStudentId,
      );
    } catch (_) {
      return _localDataSource.findConversationId(otherStudentId);
    }
  }

  Future<String> ensureConversationId({
    required String currentStudentId,
    required String otherStudentId,
    required String lastMessage,
    required String lastSenderId,
  }) {
    return _chatService.ensureConversation(
      currentStudentId: currentStudentId,
      otherStudentId: otherStudentId,
      lastMessage: lastMessage,
      lastSenderId: lastSenderId,
    );
  }

  Stream<List<T>> _localFirstStream<T>({
    required Future<List<T>> Function() readLocal,
    required Stream<List<T>> remote,
    required Future<void> Function(List<T>) saveRemote,
  }) {
    late final StreamController<List<T>> controller;
    StreamSubscription<List<T>>? subscription;
    controller = StreamController<List<T>>.broadcast(
      onListen: () async {
        controller.add(await readLocal());
        subscription = remote.listen((items) async {
          await saveRemote(items);
          controller.add(await readLocal());
        }, onError: (_, __) {});
      },
      onCancel: () => subscription?.cancel(),
    );
    return controller.stream;
  }
}
