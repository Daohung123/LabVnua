import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:aqedu/config/config_db.dart';
import 'package:aqedu/core/services_root/notification/in_app_notification_overlay.dart';
import 'package:aqedu/core/services_root/notification/local_notification_service.dart';
import 'package:aqedu/core/services_root/notification/notification_router.dart';
import 'package:aqedu/features/chat/models/chat_message.dart';
import 'package:aqedu/features/chat/models/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sqflite/sqflite.dart';

class NotificationManager with WidgetsBindingObserver {
  NotificationManager._();

  static final NotificationManager instance = NotificationManager._();

  final LocalNotificationService _localNotificationService =
      LocalNotificationService.instance;
  final _ChatNotificationCache _cache = _ChatNotificationCache();

  GlobalKey<NavigatorState>? _navigatorKey;
  AppLifecycleState _lifecycleState = AppLifecycleState.resumed;
  String? _activeChatPeerStudentId;
  final LinkedHashSet<String> _recentNotificationIds = LinkedHashSet<String>();
  final Map<String, DateTime> _roomCooldown = <String, DateTime>{};

  bool get isForeground => _lifecycleState == AppLifecycleState.resumed;

  Future<void> init({
    required GlobalKey<NavigatorState> navigatorKey,
    void Function(String? payload)? onNotificationTap,
  }) async {
    _navigatorKey = navigatorKey;
    WidgetsBinding.instance.addObserver(this);
    await _localNotificationService.init(onNotificationTap: onNotificationTap);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _lifecycleState = state;
  }

  void setActiveChatPeerStudentId(String? studentId) {
    _activeChatPeerStudentId = studentId?.trim().isNotEmpty == true
        ? studentId
        : null;
  }

  bool isActiveChatPeer(String studentId) {
    return _activeChatPeerStudentId?.trim() == studentId.trim();
  }

  Future<void> handleIncomingChatMessage({
    required ChatMessage message,
    required ChatUser sender,
    required ChatUser receiver,
  }) async {
    final messageId = message.id.toString();
    final conversationId = message.conversationId;
    if (messageId.isEmpty || conversationId.isEmpty) return;

    if (_recentNotificationIds.contains(messageId)) return;
    _recentNotificationIds.add(messageId);
    if (_recentNotificationIds.length > 200) {
      _recentNotificationIds.remove(_recentNotificationIds.first);
    }

    final lastSent = _roomCooldown[conversationId];
    final now = DateTime.now();
    if (lastSent != null &&
        now.difference(lastSent) < const Duration(seconds: 8)) {
      return;
    }
    _roomCooldown[conversationId] = now;

    await _cache.insertNotification(
      ChatNotificationRecord(
        id: messageId,
        conversationId: conversationId,
        senderStudentId: sender.studentId,
        senderName: sender.fullName,
        senderAvatarUrl: sender.avatarUrl,
        message: message.message,
        createdAt: now,
        isRead: false,
      ),
    );

    if (isForeground && !isActiveChatPeer(sender.studentId)) {
      final currentContext = _navigatorKey?.currentContext;
      if (currentContext != null) {
        InAppNotificationOverlay.show(
          context: currentContext,
          payload: ChatNotificationPayload(
            conversationId: conversationId,
            senderStudentId: sender.studentId,
            senderName: sender.fullName,
            senderAvatarUrl: sender.avatarUrl,
            receiverStudentId: receiver.studentId,
          )..messagePreview = message.message,
          onTap: () async {
            await NotificationRouter.openChatRoom(
              ChatNotificationPayload(
                conversationId: conversationId,
                senderStudentId: sender.studentId,
                senderName: sender.fullName,
                senderAvatarUrl: sender.avatarUrl,
                receiverStudentId: receiver.studentId,
              )..messagePreview = message.message,
            );
            await markConversationAsRead(sender.studentId);
          },
        );
      }
      return;
    }

    await _localNotificationService.showChatNotification(
      messageId: messageId,
      conversationId: conversationId,
      title: sender.fullName.isNotEmpty ? sender.fullName : 'Tin nhắn mới',
      body: message.message,
      senderName: sender.fullName,
      senderAvatarUrl: sender.avatarUrl,
      payload: jsonEncode(
        ChatNotificationPayload(
          conversationId: conversationId,
          senderStudentId: sender.studentId,
          senderName: sender.fullName,
          senderAvatarUrl: sender.avatarUrl,
          receiverStudentId: receiver.studentId,
        ).toJson(),
      ),
    );
  }

  Future<void> markConversationAsRead(String senderStudentId) async {
    await _cache.markConversationRead(senderStudentId);
  }

  Future<int> unreadCount() async {
    return _cache.unreadCount();
  }
}

class ChatNotificationRecord {
  ChatNotificationRecord({
    required this.id,
    required this.conversationId,
    required this.senderStudentId,
    required this.senderName,
    required this.senderAvatarUrl,
    required this.message,
    required this.createdAt,
    required this.isRead,
  });

  final String id;
  final String conversationId;
  final String senderStudentId;
  final String senderName;
  final String senderAvatarUrl;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_student_id': senderStudentId,
      'sender_name': senderName,
      'sender_avatar_url': senderAvatarUrl,
      'message': message,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead ? 1 : 0,
    };
  }
}

class _ChatNotificationCache {
  final DataBaseConfig _dbConfig = DataBaseConfig();

  Future<void> insertNotification(ChatNotificationRecord record) async {
    final db = await _dbConfig.database;
    await db.insert(
      'chat_notifications',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> markConversationRead(String senderStudentId) async {
    final db = await _dbConfig.database;
    await db.update(
      'chat_notifications',
      {'is_read': 1},
      where: 'sender_student_id = ?',
      whereArgs: [senderStudentId],
    );
  }

  Future<int> unreadCount() async {
    final db = await _dbConfig.database;
    final result = await db.rawQuery('''
      SELECT COUNT(*) as count
      FROM chat_notifications
      WHERE is_read = 0
    ''');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
