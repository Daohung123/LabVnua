import 'package:aqedu/core/services_root/sqlite/notification/notification_sqlite.dart';
import 'package:aqedu/features/notification/models/notification_student.dart';
import 'package:aqedu/features/notification/services/service_api_notification_student%20copy.dart';

class ServiceSqlNotificationStudent {
  static Future<void> syncNotifications() async {
    final ServiceSqlNotificationStudentRoot serviceSql =
        ServiceSqlNotificationStudentRoot();
    final ServiceNotiStudent serviceApi = await ServiceNotiStudent.create();
    final List<NotificationItem> result = await serviceApi.getNotification();
    await serviceSql.insertListNotification(result);
  }

  static Future<List<NotificationItem>> getAllNotifications() async {
    final ServiceSqlNotificationStudentRoot serviceSql =
        ServiceSqlNotificationStudentRoot();
    return await serviceSql.getAllNotifications();
  }
}
