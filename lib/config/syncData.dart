import 'package:aqedu/features/infor/services/service_sqlite_informationStudent.dart';
import 'package:aqedu/features/notification/services/service_sql_notification_student.dart';

Future<void> syncData() async {
  //sync notification
  await ServiceSqlNotificationStudent.syncNotifications();
  await ServiceSqlInformationStudent.syncInformation();
  
}