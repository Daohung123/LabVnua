import "package:aqedu/features/notification/services/service_sql_notification_student.dart";

import "../models/notification_student.dart";

class CtrlNotiStudent {
  Future<List<NotificationItem>> getNotification() async {
    try {
      final List<NotificationItem> dataNotifications =
          await ServiceSqlNotificationStudent.getAllNotifications();

      return dataNotifications;
    } catch (e) {
      return [];
    }
  }
}
