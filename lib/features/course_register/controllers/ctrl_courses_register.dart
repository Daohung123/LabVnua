import 'dart:developer';

import 'package:aqedu/core/services_root/sqlite/sessions/services_get_cookie_token.dart';
import '../models/model_course_register_fillter.dart';
import '../models/model_course_register.dart';
import '../services/service_courses_register.dart';
import '../services/service_courses_register_fillter.dart';

class CtrlCourseRegister {
  final String _cookie;
  final String _token;

  CtrlCourseRegister._(this._cookie, this._token);

  static Future<CtrlCourseRegister> create() async {
    final cookie = await GETDB.getCookie();
    final token = await GETDB.getToken();

    return CtrlCourseRegister._(cookie, token);
  }

  Future<List<CourseRegisterFilter>> getFilters() async {
    try {
      return await CourseRegisterFilterService.getFilters(
        _cookie,
        _token,
      );
    } catch (e) {
      log("Lỗi getFilters: $e");
      return [];
    }
  }

  Future<List<CourseRegisterClass>> getClasses() async {
    try {
      return await CourseRegisterService.getClasses(
        _cookie,
        _token,
      );
    } catch (e) {
      log("Lỗi getClasses: $e");
      return [];
    }
  }
}