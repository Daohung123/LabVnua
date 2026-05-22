import 'package:aqedu/core/services_root/api_daotao/semester_timetable/getSemesterTimetable.dart';
import "package:aqedu/core/services_root/sqlite/sessions/services_get_cookie_token.dart";

import 'package:aqedu/features/semester_timetable/models/model_semester_timetable.dart';

class ServiceSemesterTimetable {
  final String _cookie;
  final String _token;

  ServiceSemesterTimetable._(this._cookie, this._token);

  static Future<ServiceSemesterTimetable> create() async {
    final cookie = await GETDB.getCookie();
    final token = await GETDB.getToken();

    return ServiceSemesterTimetable._(cookie, token);
  }

  Future<List<SemesterTimetableItem>> getSemesterTimetable() async {
    try {
      SemesterTimetableResponse? semesterTimetableResponse =
          await getSemesterTimetableResponse(_cookie, _token);
      if (semesterTimetableResponse == null) {
        print("service_timetable_error: response null");
        return [];
      }

      SemesterTimetableData? data = semesterTimetableResponse.data;
      if (data == null) {
        print("service_timetable_error: data null");
        return [];
      }

      List<SemesterTimetableItem>? list = data.dsNhomTo;
      if (list == null) {
        print("service_timetable_error: list null");
        return [];
      }
      return list;
    } catch (e) {
      print("service_timetable_error: $e");
      return [];
    }
  }
}
