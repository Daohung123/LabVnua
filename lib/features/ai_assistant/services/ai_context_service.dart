import 'package:aqedu/core/services_root/sqlite/notification/notification_sqlite.dart';
import 'package:aqedu/core/services_root/sqlite/schedure/schedure_sqlite.dart';
import 'package:aqedu/features/schedure/models/Schedure_Student.dart';

class AiContextSelector {
  static const notificationKeywords = [
    'thông báo',
    'tin nhắn',
    'notice',
    'notification',
    'công văn',
    'học vụ',
  ];

  static const scheduleKeywords = [
    'lịch',
    'thời khóa biểu',
    'tkb',
    'phòng',
    'giảng viên',
    'môn học',
  ];

  bool shouldLoadNotifications(String prompt) {
    final lower = prompt.toLowerCase();
    return notificationKeywords.any(lower.contains);
  }

  bool shouldLoadSchedule(String prompt) {
    final lower = prompt.toLowerCase();
    return scheduleKeywords.any(lower.contains);
  }
}

class AiContextService {
  AiContextService({
    ServiceSqlNotificationStudentRoot? notificationSql,
    ServiceSqlTkb? scheduleSql,
    AiContextSelector? selector,
  }) : _notificationSql =
           notificationSql ?? ServiceSqlNotificationStudentRoot(),
       _scheduleSql = scheduleSql ?? ServiceSqlTkb(),
       _selector = selector ?? AiContextSelector();

  final ServiceSqlNotificationStudentRoot _notificationSql;
  final ServiceSqlTkb _scheduleSql;
  final AiContextSelector _selector;

  Future<String> buildContextForPrompt(String prompt) async {
    final sections = <String>[];

    if (_selector.shouldLoadNotifications(prompt)) {
      final notifications = await _notificationSql
          .exportAllNotificationsToString();
      if (notifications.trim().isNotEmpty) {
        sections.add('Bảng Notifications:\n$notifications');
      }
    }

    if (_selector.shouldLoadSchedule(prompt)) {
      final schedules = await _scheduleSql.getAllSchedules();
      final scheduleText = _formatSchedules(schedules);
      if (scheduleText.isNotEmpty) {
        sections.add('Bảng Thời khóa biểu:\n$scheduleText');
      }
    }

    if (sections.isEmpty) {
      return 'Không cần đọc bảng cục bộ cho câu hỏi này.';
    }
    return sections.join('\n\n');
  }

  String _formatSchedules(List<ThoiKhoaBieu> schedules) {
    return schedules
        .where((item) => item.tenMon.trim().isNotEmpty)
        .take(20)
        .map(
          (item) =>
              '- ${item.ngayhoc}: ${item.tenMon}, tiết ${item.tietBatDau}, phòng ${item.phong}, GV ${item.giangVien}',
        )
        .join('\n');
  }
}
