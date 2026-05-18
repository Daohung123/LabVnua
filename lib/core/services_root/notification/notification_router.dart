import 'dart:convert';

import 'package:aqedu/features/chat/screens/chat_room_screen.dart';
import 'package:flutter/material.dart';

class NotificationRouter {
  NotificationRouter._();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<void> handleNotificationTap(String? payload) async {
    if (payload == null || payload.trim().isEmpty) return;

    final chatPayload = _parsePayload(payload);
    if (chatPayload == null) return;

    await openChatRoom(chatPayload);
  }

  static ChatNotificationPayload? _parsePayload(String payload) {
    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      return ChatNotificationPayload(
        conversationId: data['conversationId']?.toString() ?? '',
        senderStudentId: data['senderStudentId']?.toString() ?? '',
        senderName: data['senderName']?.toString() ?? '',
        senderAvatarUrl: data['senderAvatarUrl']?.toString() ?? '',
        receiverStudentId: data['receiverStudentId']?.toString() ?? '',
        messagePreview: data['messagePreview']?.toString() ?? '',
      );
    } catch (_) {
      return null;
    }
  }

  static Future<void> openChatRoom(ChatNotificationPayload payload) async {
    final navigator = navigatorKey.currentState;
    if (navigator == null) return;

    navigator.push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => FadeTransition(
          opacity: animation,
          child: ChatRoomScreen(receiverStudentId: payload.senderStudentId),
        ),
        transitionDuration: const Duration(milliseconds: 260),
        reverseTransitionDuration: const Duration(milliseconds: 220),
      ),
    );
  }
}

class ChatNotificationPayload {
  ChatNotificationPayload({
    required this.conversationId,
    required this.senderStudentId,
    required this.senderName,
    required this.senderAvatarUrl,
    required this.receiverStudentId,
    this.messagePreview = '',
  });

  final String conversationId;
  final String senderStudentId;
  final String senderName;
  final String senderAvatarUrl;
  final String receiverStudentId;
  String messagePreview;

  Map<String, dynamic> toJson() {
    return {
      'conversationId': conversationId,
      'senderStudentId': senderStudentId,
      'senderName': senderName,
      'senderAvatarUrl': senderAvatarUrl,
      'receiverStudentId': receiverStudentId,
      'messagePreview': messagePreview,
    };
  }
}
