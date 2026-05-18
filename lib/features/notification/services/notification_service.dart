import 'dart:convert';
import 'dart:ui';

import 'package:aqedu/features/notification/models/data_change_models.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static const String channelId = 'data_change_channel';
  static const String channelName = 'Thông báo thay đổi dữ liệu';
  static const String channelDescription =
      'Thông báo khi điểm, lịch học, học phí hoặc dữ liệu đào tạo thay đổi';
  static const String _appName = 'AqEdu';

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

    final notificationTitle = _buildNotificationTitle(change);
    final notificationBody = _cleanText(change.message);
    final accentColor = _accentColorFor(change.dataType);
    final summaryText = _buildSummaryText(change);

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        styleInformation: BigTextStyleInformation(
          notificationBody,
          contentTitle: notificationTitle,
          summaryText: summaryText,
        ),
        color: accentColor,
        subText: change.dataType.label,
        ticker: notificationBody,
        groupKey: 'aqedu_${change.dataType.value}',
        groupAlertBehavior: GroupAlertBehavior.all,
        visibility: NotificationVisibility.private,
        category: _categoryFor(change.dataType),
        enableVibration: true,
        playSound: true,
        channelShowBadge: true,
        autoCancel: true,
        onlyAlertOnce: true,
        showWhen: true,
        when: change.createdAt.millisecondsSinceEpoch,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        subtitle: change.dataType.label,
        threadIdentifier: 'aqedu_${change.dataType.value}',
      ),
    );

    await _plugin.show(
      change.changeId.hashCode & 0x7fffffff,
      notificationTitle,
      notificationBody,
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
      enableVibration: true,
      playSound: true,
      showBadge: true,
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

  String _buildNotificationTitle(DataChange change) {
    switch (change.changeType) {
      case DataChangeType.added:
        return '$_appName - ${change.dataType.label} mới';
      case DataChangeType.updated:
        return '$_appName - ${change.dataType.label} cập nhật';
      case DataChangeType.removed:
        return '$_appName - ${change.dataType.label} thay đổi';
    }
  }

  String _buildSummaryText(DataChange change) {
    switch (change.changeType) {
      case DataChangeType.added:
        return 'Dữ liệu mới từ hệ thống đào tạo';
      case DataChangeType.updated:
        return 'Có cập nhật từ hệ thống đào tạo';
      case DataChangeType.removed:
        return 'Một mục dữ liệu đã thay đổi trạng thái';
    }
  }

  AndroidNotificationCategory _categoryFor(WatchedDataType dataType) {
    switch (dataType) {
      case WatchedDataType.schedule:
      case WatchedDataType.examSchedule:
        return AndroidNotificationCategory.event;
      case WatchedDataType.trainingNotification:
        return AndroidNotificationCategory.message;
      case WatchedDataType.score:
      case WatchedDataType.tuition:
      case WatchedDataType.courseRegister:
        return AndroidNotificationCategory.status;
    }
  }

  Color _accentColorFor(WatchedDataType dataType) {
    switch (dataType) {
      case WatchedDataType.score:
        return const Color(0xFF2563EB);
      case WatchedDataType.schedule:
        return const Color(0xFF0891B2);
      case WatchedDataType.examSchedule:
        return const Color(0xFF7C3AED);
      case WatchedDataType.tuition:
        return const Color(0xFF059669);
      case WatchedDataType.trainingNotification:
        return const Color(0xFF104492);
      case WatchedDataType.courseRegister:
        return const Color(0xFFEA580C);
    }
  }

  String _cleanText(String value) {
    return value.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
