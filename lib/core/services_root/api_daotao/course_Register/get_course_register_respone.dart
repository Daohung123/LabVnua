import 'dart:convert';

import 'package:aqedu/core/constants/api/api_daotao.dart';
import 'package:aqedu/core/models/sqlite/session.dart';
import 'package:aqedu/core/services_root/api_daotao/auth/re_login.dart';
import 'package:aqedu/core/services_root/api_daotao/root_daotao/daotao_post_get.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/core_service_session.dart';
import '../../../../features/course_register/models/model_course_register.dart';

Future<CourseRegisterResponse?> getCourseRegisterResponse(
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
    final payload = {
      "is_CVHT": false,
      "additional": {
        "paging": {"limit": 99999, "page": 1},
        "ordering": [
          {"name": "", "order_type": ""},
        ],
      },
    };
    final res = await api.post(APICOURSEREGISTERCLASSES, payload);

    print("TYPE COURSE REGISTER: ${res.runtimeType}");
    print("BODY COURSE REGISTER: $res");

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

      return getCourseRegisterResponse(
        sqlite.cookie,
        sqlite.token,
        retry: retry + 1,
      );
    }

    final jsonData = res is String
        ? jsonDecode(res)
        : res as Map<String, dynamic>;

    if (jsonData["result"] == false) {
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

        return getCourseRegisterResponse(
          sqlite.cookie,
          sqlite.token,
          retry: retry + 1,
        );
      }

      return null;
    }

    if (jsonData["data"] == null) {
      print("Data null");
      return null;
    }

    return CourseRegisterResponse.fromJson(jsonData);
  } catch (e) {
    print("ERROR getCourseRegisterResponse");
    print(e);
    return null;
  }
}
