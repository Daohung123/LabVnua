import 'dart:developer';

import 'package:aqedu/core/services_root/sqlite/sessions/services_get_cookie_token.dart';
import '../models/model_course_register_fillter.dart';
import '../models/model_course_register.dart';
import '../services/service_courses_register.dart';
import '../services/service_courses_register_fillter.dart';

import '../models/model_course_register_action.dart';
import '../services/service_courses_register_action.dart';

import '../models/model_course_register_results.dart';
import '../services/service_courses_register_results.dart';

import 'package:aqedu/features/infor/models/models_inforStudent.dart';
import '../services/service_course_register_student.dart';

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
      return await CourseRegisterFilterService.getFilters(_cookie, _token);
    } catch (e) {
      log("Lỗi getFilters: $e");
      return [];
    }
  }

  Future<List<CourseRegisterClass>> getClasses() async {
    try {
      return await CourseRegisterService.getClasses(_cookie, _token);
    } catch (e) {
      log("Lỗi getClasses: $e");
      return [];
    }
  }

  Future<CourseRegisterActionResponse?> actionCourseRegister({
    required String idToHoc,
    required bool isChecked,
    required int svNganh,
    required String idRs,
  }) async {
    try {
      return await CourseRegisterActionService.actionCourseRegister(
        _cookie,
        _token,
        idToHoc: idToHoc,
        isChecked: isChecked,
        svNganh: svNganh,
        idRs: idRs,
      );
    } catch (e) {
      log("Lỗi actionCourseRegister: $e");
      return null;
    }
  }

  Future<CourseRegisterResultResponse?> getCourseRegisterResult() async {
    try {
      return await CourseRegisterResultService.getCourseRegisterResult(
        _cookie,
        _token,
      );
    } catch (e) {
      log("Lỗi getCourseRegisterResult: $e");
      return null;
    }
  }

  Future<CourseRegisterResponse?> getCourseRegisterFull() async {
    try {
      return await CourseRegisterService.getCourseRegisterFull(_cookie, _token);
    } catch (e) {
      log("Lỗi getCourseRegisterFull: $e");
      return null;
    }
  }

  Future<StudentData?> getStudentData() async {
    try {
      return await CourseRegisterStudentService.getStudentData(_cookie, _token);
    } catch (e) {
      log("Lỗi getStudentData: $e");
      return null;
    }
  }
}
