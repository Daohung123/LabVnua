import 'dart:async';

import 'package:aqedu/features/chat/models/chat_thread.dart';
import 'package:aqedu/features/chat/models/chat_user.dart';
import 'package:aqedu/features/chat/services/chat_service.dart';
import 'package:flutter/foundation.dart';

class ChatRealtimeConnectionService {
  ChatRealtimeConnectionService._();

  static final ChatRealtimeConnectionService instance =
      ChatRealtimeConnectionService._();

  final ChatService _chatService = ChatService();

  StreamSubscription<List<ChatThread>>? _threadsSubscription;
  String? _activeStudentId;

  bool get isConnected => _threadsSubscription != null;

  Future<void> connect(ChatUser user) async {
    final studentId = user.studentId;
    if (_activeStudentId == studentId && _threadsSubscription != null) return;

    await disconnect();
    _activeStudentId = studentId;
    _threadsSubscription = _chatService
        .streamChatThreads(currentStudentId: studentId)
        .listen(
          (_) {},
          onError: (Object error) {
            debugPrint('Chat realtime connection failed: $error');
          },
        );
  }

  Future<void> disconnect() async {
    await _threadsSubscription?.cancel();
    _threadsSubscription = null;
    _activeStudentId = null;
  }
}
