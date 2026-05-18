import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationChannels {
  NotificationChannels._();

  static const String chatMessage = 'chat_message';
  static const String important = 'important';
  static const String scheduleUpdate = 'schedule_update';
  static const String scoreUpdate = 'score_update';

  static String channelName(String channelId) {
    switch (channelId) {
      case important:
        return 'Thông báo quan trọng';
      case scheduleUpdate:
        return 'Cập nhật lịch học';
      case scoreUpdate:
        return 'Cập nhật điểm số';
      default:
        return 'Tin nhắn';
    }
  }

  static String channelDescription(String channelId) {
    switch (channelId) {
      case important:
        return 'Các tin nhắn hệ thống quan trọng và cảnh báo.';
      case scheduleUpdate:
        return 'Thông báo cập nhật thời khóa biểu và lịch học.';
      case scoreUpdate:
        return 'Thông báo cập nhật điểm số và kết quả học tập.';
      default:
        return 'Tin nhắn chat thời gian thực với bạn bè và đồng nghiệp.';
    }
  }

  static String groupKeyFor(String channelId) {
    switch (channelId) {
      case important:
        return 'grp_important_notifications';
      case scheduleUpdate:
        return 'grp_schedule_notifications';
      case scoreUpdate:
        return 'grp_score_notifications';
      default:
        return 'grp_chat_messages';
    }
  }

  static const List<AndroidNotificationChannel> androidChannels = [
    AndroidNotificationChannel(
      chatMessage,
      'Tin nhắn',
      description: 'Thông báo tin nhắn mới từ chat',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
      showBadge: true,
    ),
    AndroidNotificationChannel(
      important,
      'Quan trọng',
      description: 'Thông báo hệ thống quan trọng và cảnh báo',
      importance: Importance.max,
      enableVibration: true,
      playSound: true,
      showBadge: true,
    ),
    AndroidNotificationChannel(
      scheduleUpdate,
      'Cập nhật lịch học',
      description: 'Thông báo thay đổi thời khóa biểu và lịch học',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
      showBadge: true,
    ),
    AndroidNotificationChannel(
      scoreUpdate,
      'Cập nhật điểm số',
      description: 'Thông báo khi điểm số hoặc kết quả học tập được cập nhật',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
      showBadge: true,
    ),
  ];
}
