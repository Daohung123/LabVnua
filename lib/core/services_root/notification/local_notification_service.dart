import 'dart:convert';

import 'package:aqedu/core/services_root/notification/notification_channels.dart';
import 'package:aqedu/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class LocalNotificationService {
  LocalNotificationService._();

  static final LocalNotificationService instance = LocalNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init({void Function(String? payload)? onNotificationTap}) async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: (details) {
        onNotificationTap?.call(details.payload);
      },
    );

    final androidImpl =
        _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    for (final channel in NotificationChannels.androidChannels) {
      await androidImpl?.createNotificationChannel(channel);
    }

    _initialized = true;
  }

  Future<void> showChatNotification({
    required String messageId,
    required String conversationId,
    required String title,
    required String body,
    required String senderName,
    required String senderAvatarUrl,
    required String payload,
  }) async {
    await init();

    final notificationId = _stableNotificationId(messageId);
    final groupKey = 'grp_chat_$conversationId';
    final summaryId = _summaryIdForConversation(conversationId);
    final AndroidBitmap<Object>? largeIcon = await _createLargeIcon(senderAvatarUrl);

    final contentDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        NotificationChannels.chatMessage,
        NotificationChannels.channelName(NotificationChannels.chatMessage),
        channelDescription:
            NotificationChannels.channelDescription(NotificationChannels.chatMessage),
        importance: Importance.high,
        priority: Priority.high,
        groupKey: groupKey,
        setAsGroupSummary: false,
        groupAlertBehavior: GroupAlertBehavior.children,
        enableLights: true,
        enableVibration: true,
        playSound: true,
        sound: const RawResourceAndroidNotificationSound('notif_chat'),
        color: AppColors.primary,
        icon: '@mipmap/ic_launcher',
        largeIcon: largeIcon,
        styleInformation: BigTextStyleInformation(
          body,
          contentTitle: title,
          summaryText: senderName,
          htmlFormatContentTitle: false,
          htmlFormatSummaryText: false,
          htmlFormatBigText: false,
        ),
        autoCancel: true,
        onlyAlertOnce: false,
        showWhen: true,
        visibility: NotificationVisibility.public,
        ticker: body,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'notif_chat.aiff',
        threadIdentifier: groupKey,
      ),
    );

    await _plugin.show(notificationId, title, body, contentDetails, payload: payload);
    await _postChatGroupSummary(
      groupKey: groupKey,
      summaryId: summaryId,
      roomTitle: senderName,
      channelId: NotificationChannels.chatMessage,
    );
  }

  Future<AndroidBitmap<Object>?> _createLargeIcon(String avatarUrl) async {
    if (avatarUrl.trim().isEmpty) return null;

    try {
      final response = await http.get(Uri.parse(avatarUrl)).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
        return ByteArrayAndroidBitmap(response.bodyBytes);
      }
    } catch (_) {
      // ignore and fallback to the default icon
    }
    return null;
  }

  Future<void> _postChatGroupSummary({
    required String groupKey,
    required int summaryId,
    required String roomTitle,
    required String channelId,
  }) async {
    final summaryDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        NotificationChannels.channelName(channelId),
        channelDescription: NotificationChannels.channelDescription(channelId),
        importance: Importance.low,
        priority: Priority.low,
        groupKey: groupKey,
        setAsGroupSummary: true,
        groupAlertBehavior: GroupAlertBehavior.children,
        autoCancel: true,
        showWhen: false,
      ),
      iOS: DarwinNotificationDetails(threadIdentifier: groupKey),
    );

    await _plugin.show(summaryId, roomTitle, '', summaryDetails);
  }

  int _stableNotificationId(String messageId) => messageId.hashCode & 0x7FFFFFFF;

  int _summaryIdForConversation(String conversationId) {
    return (conversationId.hashCode & 0x1FFFFFFF) + 0x60000000;
  }
}
