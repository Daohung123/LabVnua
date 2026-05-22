import 'package:aqedu/core/services_root/sqlite/semesterTimetable/semester_timetable_sqlite.dart';
import 'package:aqedu/features/semester_timetable/models/model_semester_timetable.dart';
import 'package:aqedu/features/semester_timetable/services/services_api_semester_timetable_copy.dart';

class ServicesSqlSemesterTimetable {
  static Future<void> syncSemesterTimetable() async {
    final SemesterTimetableSqliteRoot serviceSql =
        SemesterTimetableSqliteRoot();
    final ServiceSemesterTimetable serviceApi =
        await ServiceSemesterTimetable.create();
    final List<SemesterTimetableItem> result = await serviceApi
        .getSemesterTimetable();
    await serviceSql.insertListSemesterTimetable(result);
  }

  static Future<List<SemesterTimetableItem>> getAllSemesterTimetable() async {
    final SemesterTimetableSqliteRoot serviceSql =
        SemesterTimetableSqliteRoot();
    return await serviceSql.getAllSemesterTimetable();
  }
}
