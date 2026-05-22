import 'package:aqedu/features/infor/services/service_sqlite_informationStudent.dart';
import 'package:aqedu/features/notification/services/service_sql_notification_student.dart';
import 'package:aqedu/features/semester_timetable/services/services_sql_semester_timetable.dart';

Future<void> syncData() async {
  //sync notification
  await ServiceSqlNotificationStudent.syncNotifications();
  await ServiceSqlInformationStudent.syncInformation();
  await ServicesSqlSemesterTimetable.syncSemesterTimetable();
}
