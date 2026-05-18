import 'dart:convert';

import 'package:aqedu/features/notification/models/data_change_models.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static const String channelId = 'data_change_channel';
  static const String channelName = 'Thông báo thay đổi dữ liệu';
  static const String channelDescription =
      'Thông báo khi điểm, lịch học, học phí hoặc dữ liệu đào tạo thay đổi';

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  Future<void> init({void Function(String? payload)? onNotificationTap}) async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        onNotificationTap?.call(response.payload);
      },
    );

    await _createAndroidChannel();
    await _requestAndroidPermission();
    _initialized = true;
  }

  Future<void> showDataChange(DataChange change) async {
    await init();

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        ticker: change.dataType.label,
        category: AndroidNotificationCategory.status,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _plugin.show(
      change.changeId.hashCode & 0x7fffffff,
      change.dataType.label,
      change.message,
      details,
      payload: jsonEncode({
        'id': change.id,
        'change_id': change.changeId,
        'data_type': change.dataType.value,
        'entity_id': change.entityId,
      }),
    );
  }

  Future<void> _createAndroidChannel() async {
    const channel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: Importance.high,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> _requestAndroidPermission() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.requestNotificationsPermission();
  }
}
