import 'dart:convert';
import 'dart:ui';

import 'package:aqedu/features/notification/models/data_change_models.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Notification icon resource names (drawable).
/// Add the corresponding vector drawables to `android/app/src/main/res/drawable/`:
///   ic_notif_score.xml, ic_notif_schedule.xml, ic_notif_exam.xml,
///   ic_notif_tuition.xml, ic_notif_announcement.xml, ic_notif_course.xml
/// All must be white-on-transparent (monochrome) to follow Material Design spec.
class _Icons {
  static const String score = 'ic_notif_score';
  static const String schedule = 'ic_notif_schedule';
  static const String exam = 'ic_notif_exam';
  static const String tuition = 'ic_notif_tuition';
  static const String announcement = 'ic_notif_announcement';
  static const String course = 'ic_notif_course';
}

class NotificationService {
  // ── Channel ids (one per category for granular user control) ──────────────
  static const String _channelAcademic = 'ch_academic';
  static const String _channelFinance = 'ch_finance';
  static const String _channelAnnouncement = 'ch_announcement';

  // ── Notification group keys ───────────────────────────────────────────────
  static const String _groupAcademic = 'grp_academic';
  static const String _groupFinance = 'grp_finance';
  static const String _groupAnnouncement = 'grp_announcement';

  // ── Summary notification ids (must be stable) ─────────────────────────────
  static const int _summaryAcademic = 900001;
  static const int _summaryFinance = 900002;
  static const int _summaryAnnouncement = 900003;

  static const String _appName = 'EduAI';

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  // ── Init ──────────────────────────────────────────────────────────────────

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
      onDidReceiveNotificationResponse: (r) => onNotificationTap?.call(r.payload),
    );

    await _createAllAndroidChannels();
    await _requestAndroidPermission();
    _initialized = true;
  }

  // ── Public API ────────────────────────────────────────────────────────────

  Future<void> showDataChange(DataChange change) async {
    await init();

    final id = change.changeId.hashCode & 0x7FFFFFFF;
    final title = _buildTitle(change);
    final body = _cleanText(change.message);
    final payload = _buildPayload(change);

    await _plugin.show(
      id,
      title,
      body,
      _buildDetails(change, title, body),
      payload: payload,
    );

    // Post (or refresh) the inbox-style group summary so the shade shows a
    // tidy collapsed view – exactly like Gmail, Slack, etc.
    await _postGroupSummary(change);
  }

  // ── Notification details ──────────────────────────────────────────────────

  NotificationDetails _buildDetails(
    DataChange change,
    String title,
    String body,
  ) {
    final channelId = _channelIdFor(change.dataType);
    final accentColor = _accentColorFor(change.dataType);
    final smallIcon = _smallIconFor(change.dataType);
    final groupKey = _groupKeyFor(change.dataType);

    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        _channelNameFor(channelId),
        channelDescription: _channelDescFor(channelId),
        importance: Importance.high,
        priority: Priority.high,

        // ── Visual ─────────────────────────────────────────────────────────
        icon: smallIcon,          // per-category monochrome icon
        color: accentColor,       // tints the icon on Android 12+
        colorized: false,         // keep background white (set true for heads-up accent bg)
        subText: change.dataType.label,

        // ── Rich text style ─────────────────────────────────────────────────
        // BigTextStyle expands the notification to show the full message,
        // exactly like Google apps.
        styleInformation: BigTextStyleInformation(
          body,
          htmlFormatBigText: false,
          contentTitle: title,
          htmlFormatContentTitle: false,
          summaryText: _buildSummaryLine(change),
          htmlFormatSummaryText: false,
        ),

        // ── Quick-action buttons ─────────────────────────────────────────
        // Gives one contextual action without opening the app – common in
        // professional apps (Gmail "Reply", Calendar "Snooze", etc.).
        actions: _buildActions(change),

        // ── Grouping (inbox collapsing) ──────────────────────────────────
        groupKey: groupKey,
        setAsGroupSummary: false,
        groupAlertBehavior: GroupAlertBehavior.children,

        // ── Behaviour ────────────────────────────────────────────────────
        category: _categoryFor(change.dataType),
        visibility: NotificationVisibility.private,
        ticker: body,
        enableVibration: true,
        playSound: true,
        channelShowBadge: true,
        autoCancel: true,
        // onlyAlertOnce = false so every distinct change rings/vibrates,
        // but we deduplicate by id so re-delivered FCM won't double-ring.
        onlyAlertOnce: false,
        showWhen: true,
        when: change.createdAt.millisecondsSinceEpoch,
        usesChronometer: false,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        subtitle: change.dataType.label,
        threadIdentifier: groupKey,         // groups in Notification Centre
        interruptionLevel: InterruptionLevel.active,
        categoryIdentifier: _iosCategoryFor(change.dataType),
      ),
    );
  }

  // ── Group summary (Android inbox style) ──────────────────────────────────

  /// Posts an InboxStyleInformation summary notification for the group.
  /// Android collapses all individual notifications under this when there are
  /// 4+ in the same group – the same mechanism used by Gmail.
  Future<void> _postGroupSummary(DataChange change) async {
    final groupKey = _groupKeyFor(change.dataType);
    final channelId = _channelIdFor(change.dataType);
    final summaryId = _summaryIdFor(change.dataType);
    final accentColor = _accentColorFor(change.dataType);

    final summaryDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        _channelNameFor(channelId),
        channelDescription: _channelDescFor(channelId),
        importance: Importance.low,   // summary itself is silent
        priority: Priority.low,
        styleInformation: InboxStyleInformation(
          [],                          // Android fills lines from child notifs
          htmlFormatLines: false,
          contentTitle: _appName,
          htmlFormatContentTitle: false,
          summaryText: change.dataType.label,
          htmlFormatSummaryText: false,
        ),
        groupKey: groupKey,
        setAsGroupSummary: true,       // ← this is the key flag
        groupAlertBehavior: GroupAlertBehavior.children,
        color: accentColor,
        autoCancel: true,
        showWhen: false,
      ),
      // iOS groups natively via threadIdentifier – no summary needed.
    );

    await _plugin.show(summaryId, _appName, '', summaryDetails);
  }

  // ── Android notification channels ────────────────────────────────────────

  Future<void> _createAllAndroidChannels() async {
    final impl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    for (final channel in _androidChannels) {
      await impl?.createNotificationChannel(channel);
    }
  }

  static const List<AndroidNotificationChannel> _androidChannels = [
    AndroidNotificationChannel(
      _channelAcademic,
      'Học vụ',
      description: 'Điểm số, lịch học, lịch thi, đăng ký học phần',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
      showBadge: true,
    ),
    AndroidNotificationChannel(
      _channelFinance,
      'Tài chính',
      description: 'Học phí và các khoản thu',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
      showBadge: true,
    ),
    AndroidNotificationChannel(
      _channelAnnouncement,
      'Thông báo đào tạo',
      description: 'Thông báo chung từ phòng đào tạo',
      importance: Importance.defaultImportance,
      enableVibration: false,
      playSound: true,
      showBadge: true,
    ),
  ];

  Future<void> _requestAndroidPermission() async {
    final impl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await impl?.requestNotificationsPermission();
  }

  // ── Quick-action buttons ──────────────────────────────────────────────────

  List<AndroidNotificationAction> _buildActions(DataChange change) {
    switch (change.dataType) {
      case WatchedDataType.score:
        return const [
          AndroidNotificationAction(
            'action_view_score',
            'Xem bảng điểm',
            showsUserInterface: true,
            cancelNotification: true,
          ),
        ];
      case WatchedDataType.schedule:
      case WatchedDataType.examSchedule:
        return const [
          AndroidNotificationAction(
            'action_view_schedule',
            'Xem lịch',
            showsUserInterface: true,
            cancelNotification: true,
          ),
        ];
      case WatchedDataType.tuition:
        return const [
          AndroidNotificationAction(
            'action_view_tuition',
            'Xem học phí',
            showsUserInterface: true,
            cancelNotification: true,
          ),
        ];
      case WatchedDataType.courseRegister:
        return const [
          AndroidNotificationAction(
            'action_view_courses',
            'Xem đăng ký',
            showsUserInterface: true,
            cancelNotification: true,
          ),
        ];
      case WatchedDataType.trainingNotification:
        return const [
          AndroidNotificationAction(
            'action_view_announcement',
            'Đọc thông báo',
            showsUserInterface: true,
            cancelNotification: true,
          ),
        ];
    }
  }

  // ── Mapping helpers ───────────────────────────────────────────────────────

  String _channelIdFor(WatchedDataType t) {
    switch (t) {
      case WatchedDataType.tuition:
        return _channelFinance;
      case WatchedDataType.trainingNotification:
        return _channelAnnouncement;
      default:
        return _channelAcademic;
    }
  }

  String _channelNameFor(String id) {
    switch (id) {
      case _channelFinance:
        return 'Tài chính';
      case _channelAnnouncement:
        return 'Thông báo đào tạo';
      default:
        return 'Học vụ';
    }
  }

  String _channelDescFor(String id) {
    switch (id) {
      case _channelFinance:
        return 'Học phí và các khoản thu';
      case _channelAnnouncement:
        return 'Thông báo chung từ phòng đào tạo';
      default:
        return 'Điểm số, lịch học, lịch thi, đăng ký học phần';
    }
  }

  String _groupKeyFor(WatchedDataType t) {
    switch (t) {
      case WatchedDataType.tuition:
        return _groupFinance;
      case WatchedDataType.trainingNotification:
        return _groupAnnouncement;
      default:
        return _groupAcademic;
    }
  }

  int _summaryIdFor(WatchedDataType t) {
    switch (t) {
      case WatchedDataType.tuition:
        return _summaryFinance;
      case WatchedDataType.trainingNotification:
        return _summaryAnnouncement;
      default:
        return _summaryAcademic;
    }
  }

  String _smallIconFor(WatchedDataType t) {
    switch (t) {
      case WatchedDataType.score:
        return _Icons.score;
      case WatchedDataType.schedule:
        return _Icons.schedule;
      case WatchedDataType.examSchedule:
        return _Icons.exam;
      case WatchedDataType.tuition:
        return _Icons.tuition;
      case WatchedDataType.trainingNotification:
        return _Icons.announcement;
      case WatchedDataType.courseRegister:
        return _Icons.course;
    }
  }

  Color _accentColorFor(WatchedDataType t) {
    switch (t) {
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

  AndroidNotificationCategory _categoryFor(WatchedDataType t) {
    switch (t) {
      case WatchedDataType.schedule:
      case WatchedDataType.examSchedule:
        return AndroidNotificationCategory.event;
      case WatchedDataType.trainingNotification:
        return AndroidNotificationCategory.message;
      default:
        return AndroidNotificationCategory.status;
    }
  }

  /// Maps data type to an iOS UNNotificationCategory identifier.
  /// Register matching categories in AppDelegate / UNUserNotificationCenter
  /// to enable action buttons on iOS.
  String _iosCategoryFor(WatchedDataType t) {
    switch (t) {
      case WatchedDataType.score:
        return 'CAT_SCORE';
      case WatchedDataType.schedule:
        return 'CAT_SCHEDULE';
      case WatchedDataType.examSchedule:
        return 'CAT_EXAM';
      case WatchedDataType.tuition:
        return 'CAT_TUITION';
      case WatchedDataType.trainingNotification:
        return 'CAT_ANNOUNCEMENT';
      case WatchedDataType.courseRegister:
        return 'CAT_COURSE';
    }
  }

  // ── Text builders ─────────────────────────────────────────────────────────

  String _buildTitle(DataChange change) {
    final label = change.dataType.label;
    switch (change.changeType) {
      case DataChangeType.added:
        return '$label mới';
      case DataChangeType.updated:
        return '$label vừa cập nhật';
      case DataChangeType.removed:
        return '$label có thay đổi';
    }
  }

  String _buildSummaryLine(DataChange change) {
    switch (change.changeType) {
      case DataChangeType.added:
        return 'Dữ liệu mới từ hệ thống đào tạo';
      case DataChangeType.updated:
        return 'Có cập nhật từ hệ thống đào tạo';
      case DataChangeType.removed:
        return 'Một mục dữ liệu đã thay đổi trạng thái';
    }
  }

  String _buildPayload(DataChange change) => jsonEncode({
        'id': change.id,
        'change_id': change.changeId,
        'data_type': change.dataType.value,
        'entity_id': change.entityId,
        'action_route': _routeFor(change.dataType),
      });

  /// Deep-link route embedded in payload so the tap handler can navigate
  /// directly without extra lookups.
  String _routeFor(WatchedDataType t) {
    switch (t) {
      case WatchedDataType.score:
        return '/score';
      case WatchedDataType.schedule:
        return '/schedule';
      case WatchedDataType.examSchedule:
        return '/exam-schedule';
      case WatchedDataType.tuition:
        return '/tuition';
      case WatchedDataType.trainingNotification:
        return '/announcements';
      case WatchedDataType.courseRegister:
        return '/course-registration';
    }
  }

  String _cleanText(String value) => value.replaceAll(RegExp(r'\s+'), ' ').trim();
}