import 'dart:async';
import 'dart:collection';

import 'package:aqedu/features/chat/models/chat_message.dart';
import 'package:aqedu/features/chat/models/chat_user.dart';
import 'package:aqedu/features/chat/services/chat_service.dart';
import 'package:aqedu/core/services_root/notification/notification_manager.dart';
import 'package:flutter/foundation.dart';

class ChatNotificationService {
  ChatNotificationService._();

  static final ChatNotificationService instance = ChatNotificationService._();

  final ChatService _chatService = ChatService();
  StreamSubscription<ChatMessage>? _subscription;
  String? _currentStudentId;
  ChatUser? _currentUser;
  final LinkedHashSet<String> _seenMessageIds = LinkedHashSet<String>();

  Future<void> startForUser(ChatUser currentUser) async {
    final studentId = currentUser.studentId.trim();
    if (studentId.isEmpty) return;
    if (_currentStudentId == studentId && _subscription != null) return;

    await stop();
    _currentStudentId = studentId;
    _currentUser = currentUser;

    _subscription = _chatService
        .streamIncomingMessages(currentStudentId: studentId)
        .listen(
      (message) async {
        if (message.senderStudentId.trim() == studentId) return;
        final messageId = message.id.toString();
        if (_seenMessageIds.contains(messageId)) return;
        _seenMessageIds.add(messageId);
        if (_seenMessageIds.length > 500) {
          _seenMessageIds.remove(_seenMessageIds.first);
        }

        try {
          final sender = await _chatService.getUserByStudentId(message.senderStudentId) ??
              ChatUser(
                id: message.senderStudentId,
                studentId: message.senderStudentId,
                fullName: message.senderStudentId,
                avatarUrl: '',
                faculty: '',
                className: '',
              );

          await NotificationManager.instance.handleIncomingChatMessage(
            message: message,
            sender: sender,
            receiver: currentUser,
          );
        } catch (error) {
          debugPrint('Chat notification handling failed: $error');
        }
      },
      onError: (error) {
        debugPrint('ChatNotificationService error: $error');
      },
      cancelOnError: false,
    );
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
    _currentStudentId = null;
    _currentUser = null;
    _seenMessageIds.clear();
  }
}
