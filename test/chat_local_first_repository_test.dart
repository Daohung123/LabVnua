import 'dart:async';

import 'package:aqedu/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:aqedu/features/chat/models/chat_message.dart';
import 'package:aqedu/features/chat/models/chat_thread.dart';
import 'package:aqedu/features/chat/models/chat_user.dart';
import 'package:aqedu/features/chat/repository/chat_repository.dart';
import 'package:aqedu/features/chat/services/chat_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'realtime thread refresh is persisted then re-read from local cache',
    () async {
      final remote = _FakeRemote();
      final local = _FakeLocal();
      final repository = ChatRepository(
        chatService: remote,
        localDataSource: local,
      );
      final values = <List<ChatThread>>[];
      final subscription = repository
          .streamChatThreads(currentStudentId: 'SV01')
          .listen(values.add);
      await Future<void>.delayed(Duration.zero);

      remote.threadEvents.add([_thread('c1')]);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      expect(values.first, isEmpty);
      expect(values.last.single.conversationId, 'c1');
      expect(local.threads.single.conversationId, 'c1');
      await subscription.cancel();
    },
  );

  test(
    'failed send remains online-only and does not write an outbox',
    () async {
      final local = _FakeLocal();
      final repository = ChatRepository(
        chatService: _FakeRemote(failSend: true),
        localDataSource: local,
      );

      await expectLater(
        repository.sendMessage(
          conversationId: 'c1',
          senderStudentId: 'SV01',
          receiverStudentId: 'SV02',
          message: 'Xin chào',
        ),
        throwsStateError,
      );
      expect(local.messages, isEmpty);
    },
  );
}

ChatUser _user(String id) => ChatUser(
  id: id,
  studentId: id,
  fullName: id,
  avatarUrl: '',
  faculty: '',
  className: '',
);

ChatThread _thread(String id) => ChatThread(
  conversationId: id,
  peer: _user('SV02'),
  lastMessage: 'Chào',
  lastSenderStudentId: 'SV02',
  updatedAt: DateTime.utc(2026, 7, 22),
);

class _FakeLocal implements ChatLocalDataSource {
  final List<ChatThread> threads = [];
  final List<ChatMessage> messages = [];
  final Map<String, ChatUser> users = {};

  @override
  Future<String?> findConversationId(String peerStudentId) async {
    for (final thread in threads) {
      if (thread.peer.studentId == peerStudentId) return thread.conversationId;
    }
    return null;
  }

  @override
  Future<List<ChatMessage>> readMessages(
    String conversationId, {
    int limit = 80,
  }) async => messages
      .where((item) => item.conversationId == conversationId)
      .take(limit)
      .toList();
  @override
  Future<List<ChatThread>> readThreads({int limit = 200}) async =>
      threads.take(limit).toList();
  @override
  Future<ChatUser?> readUser(String studentId) async => users[studentId];
  @override
  Future<void> replaceMessages(
    String conversationId,
    List<ChatMessage> value,
  ) async {
    messages
      ..removeWhere((item) => item.conversationId == conversationId)
      ..addAll(value);
  }

  @override
  Future<void> replaceThreads(List<ChatThread> value) async {
    threads
      ..clear()
      ..addAll(value);
  }

  @override
  Future<void> saveUser(ChatUser user) async {
    users[user.studentId] = user;
  }

  @override
  Future<List<ChatUser>> searchUsers(String keyword, {int limit = 20}) async =>
      users.values.take(limit).toList();
  @override
  Future<void> upsertMessage(ChatMessage message) async {
    messages.removeWhere((item) => item.id == message.id);
    messages.add(message);
  }
}

class _FakeRemote implements ChatRemoteDataSource {
  _FakeRemote({this.failSend = false});
  final bool failSend;
  final threadEvents = StreamController<List<ChatThread>>.broadcast();
  final messageEvents = StreamController<List<ChatMessage>>.broadcast();
  @override
  Future<ChatUser> ensureUserByStudentId(String studentId) async =>
      _user(studentId);
  @override
  Future<String> ensureConversation({
    required String currentStudentId,
    required String otherStudentId,
    required String lastMessage,
    required String lastSenderId,
  }) async => 'c1';
  @override
  Future<String?> getConversationId({
    required String currentStudentId,
    required String otherStudentId,
  }) async => null;
  @override
  Future<ChatUser?> getUserByStudentId(String studentId) async =>
      _user(studentId);
  @override
  Future<List<ChatMessage>> loadConversation({
    required String conversationId,
    int limit = 80,
  }) async => const [];
  @override
  Future<List<ChatUser>> searchUsers({
    required String keyword,
    String? excludeStudentId,
    int limit = 20,
  }) async => const [];
  @override
  Future<ChatMessage> sendMessage({
    required String conversationId,
    required String senderStudentId,
    required String receiverStudentId,
    required String message,
  }) async {
    if (failSend) throw StateError('offline');
    return ChatMessage(
      id: 'm1',
      conversationId: conversationId,
      senderStudentId: senderStudentId,
      receiverStudentId: receiverStudentId,
      message: message,
      messageType: 'text',
      isSeen: false,
      createdAt: DateTime.utc(2026, 7, 22),
    );
  }

  @override
  Stream<List<ChatMessage>> streamConversation({
    required String conversationId,
    int limit = 80,
  }) => messageEvents.stream;
  @override
  Stream<List<ChatThread>> streamChatThreads({
    required String currentStudentId,
    int limit = 200,
  }) => threadEvents.stream;
}
