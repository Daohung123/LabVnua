import 'dart:convert';

import 'package:aqedu/core/constants/api/api_daotao.dart';
import 'package:aqedu/core/models/sqlite/session.dart';
import 'package:aqedu/core/services_root/api_daotao/auth/re_login.dart';
import 'package:aqedu/core/services_root/api_daotao/root_daotao/daotao_post_get.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/core_service_session.dart';
import '../../../../features/course_register/models/model_course_register_fillter.dart';

Future<List<CourseRegisterFilter>?> getCourseRegisterFilterResponse(
  String cookie,
  String token, {
  int retry = 0,
}) async {
  try {
    if (retry > 2) {
      print("Retry quá số lần cho phép");
      return null;
    }

    final api = ApiHelper.withSession(cookie, token);
    final payload = {};

    final res = await api.post(APICOURSEREGISTERFILLTER, payload);

    print("TYPE FILTER: ${res.runtimeType}");
    print("BODY FILTER: $res");

    if (res.toString().contains("<!DOCTYPE")) {
      print("Session hết hạn HTML");
      final kt = await reLogin();

      if (kt == false) {
        print("Lỗi đăng nhập lại");
        return null;
      }

      final db = SqliteServices();
      final SessionModel? sqlite = await db.getSession();

      if (sqlite == null) {
        print("Không lấy được session");
        return null;
      }

      return getCourseRegisterFilterResponse(
        sqlite.cookie,
        sqlite.token,
        retry: retry + 1,
      );
    }

    final jsonData = res is String ? jsonDecode(res) : res;

    if (jsonData is Map<String, dynamic> && jsonData["result"] == false) {
      print("API lỗi: ${jsonData["message"]}");

      if (jsonData["message"] == "expired") {
        final kt = await reLogin();

        if (kt == false) {
          print("Lỗi đăng nhập lại");
          return null;
        }

        final db = SqliteServices();
        final SessionModel? sqlite = await db.getSession();

        if (sqlite == null) {
          print("Không lấy được session");
          return null;
        }

        return getCourseRegisterFilterResponse(
          sqlite.cookie,
          sqlite.token,
          retry: retry + 1,
        );
      }

      return null;
    }

    if (jsonData is! List) {
      print("Filter response không phải List");
      return null;
    }

    return jsonData.map((e) => CourseRegisterFilter.fromJson(e)).toList();
  } catch (e) {
    print("ERROR getCourseRegisterFilterResponse");
    print(e);
    return null;
  }
}
