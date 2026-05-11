import 'package:aqedu/features/notification/services/service_sql_notification_student.dart';

Future<void> syncData() async {
  //sync notification
  await ServiceSqlNotificationStudent.syncNotifications();
  
}