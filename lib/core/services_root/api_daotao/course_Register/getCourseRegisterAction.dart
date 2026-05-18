import 'dart:convert';

import 'package:aqedu/core/constants/api/api_daotao.dart';
import 'package:aqedu/core/models/sqlite/Session.dart';
import 'package:aqedu/core/services_root/api_daotao/auth/reLogin.dart';
import 'package:aqedu/core/services_root/api_daotao/root_daotao/daotao_post_get.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/core_service_session.dart';
import '../../../../features/course_register/models/model_course_register_action.dart';

Future<CourseRegisterActionResponse?> actionCourseRegisterResponse(
  String cookie,
  String token, {
  required String idToHoc,
  required bool isChecked,
  required int svNganh,
  required String idRs,
  int retry = 0,
}) async {
  try {
    if (retry > 2) {
      print("Retry quá số lần cho phép");
      return null;
    }

    final api = ApiHelper.withSession(cookie, token);

    final payload = {
      "filter": {
        "id_to_hoc": idToHoc,
        "is_checked": isChecked,
        "sv_nganh": svNganh,
        "id_rs": idRs,
      }
    };

    final res = await api.post(APICOURSEREGISTERACTION, payload);

    print("TYPE COURSE REGISTER ACTION: ${res.runtimeType}");
    print("BODY COURSE REGISTER ACTION: $res");

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

      return actionCourseRegisterResponse(
        sqlite.cookie,
        sqlite.token,
        idToHoc: idToHoc,
        isChecked: isChecked,
        svNganh: svNganh,
        idRs: idRs,
        retry: retry + 1,
      );
    }

    final jsonData = res is String ? jsonDecode(res) : res;

    if (jsonData is! Map<String, dynamic>) {
      print("Course register action response không phải Map");
      return null;
    }

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

        return actionCourseRegisterResponse(
          sqlite.cookie,
          sqlite.token,
          idToHoc: idToHoc,
          isChecked: isChecked,
          svNganh: svNganh,
          idRs: idRs,
          retry: retry + 1,
        );
      }

      return null;
    }

    if (jsonData["data"] == null) {
      print("Data null");
      return null;
    }

    return CourseRegisterActionResponse.fromJson(jsonData);
  } catch (e) {
    print("ERROR actionCourseRegisterResponse");
    print(e);
    return null;
  }
}