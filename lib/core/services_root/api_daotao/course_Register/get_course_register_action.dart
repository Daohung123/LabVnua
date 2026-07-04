import 'package:aqedu/core/logging/app_log.dart';
import 'dart:convert';

import 'package:aqedu/core/constants/api/api_daotao.dart';
import 'package:aqedu/core/models/sqlite/session.dart';
import 'package:aqedu/core/services_root/api_daotao/auth/re_login.dart';
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
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/course_Register/get_course_register_action.dart',
        duLieu: "Retry quá số lần cho phép",
      );
      return null;
    }

    final api = ApiHelper.withSession(cookie, token);

    final payload = {
      "filter": {
        "id_to_hoc": idToHoc,
        "is_checked": isChecked,
        "sv_nganh": svNganh,
        "id_rs": idRs,
      },
    };

    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/course_Register/get_course_register_action.dart',
      duLieu: "===== ACTION PAYLOAD =====",
    );
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/course_Register/get_course_register_action.dart',
      duLieu: payload,
    );
    final res = await api.post(APICOURSEREGISTERACTION, payload);

    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/course_Register/get_course_register_action.dart',
      duLieu: "TYPE COURSE REGISTER ACTION: ${res.runtimeType}",
    );
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/course_Register/get_course_register_action.dart',
      duLieu: "BODY COURSE REGISTER ACTION: $res",
    );
    if (res.toString().contains("<!DOCTYPE")) {
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/course_Register/get_course_register_action.dart',
        duLieu: "Session hết hạn HTML",
      );
      final kt = await reLogin();

      if (kt == false) {
        AppLog.api(
          'Ghi nhận hoạt động runtime',
          khuVuc:
              'lib/core/services_root/api_daotao/course_Register/get_course_register_action.dart',
          duLieu: "Lỗi đăng nhập lại",
        );
        return null;
      }

      final db = SqliteServices();
      final SessionModel? sqlite = await db.getSession();

      if (sqlite == null) {
        AppLog.api(
          'Ghi nhận hoạt động runtime',
          khuVuc:
              'lib/core/services_root/api_daotao/course_Register/get_course_register_action.dart',
          duLieu: "Không lấy được session",
        );
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
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/course_Register/get_course_register_action.dart',
        duLieu: "Course register action response không phải Map",
      );
      return null;
    }

    if (jsonData["result"] == false) {
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/course_Register/get_course_register_action.dart',
        duLieu: "API lỗi: ${jsonData["message"]}",
      );
      if (jsonData["message"] == "expired") {
        final kt = await reLogin();

        if (kt == false) {
          AppLog.api(
            'Ghi nhận hoạt động runtime',
            khuVuc:
                'lib/core/services_root/api_daotao/course_Register/get_course_register_action.dart',
            duLieu: "Lỗi đăng nhập lại",
          );
          return null;
        }

        final db = SqliteServices();
        final SessionModel? sqlite = await db.getSession();

        if (sqlite == null) {
          AppLog.api(
            'Ghi nhận hoạt động runtime',
            khuVuc:
                'lib/core/services_root/api_daotao/course_Register/get_course_register_action.dart',
            duLieu: "Không lấy được session",
          );
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
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/course_Register/get_course_register_action.dart',
        duLieu: "Data null",
      );
      return null;
    }

    return CourseRegisterActionResponse.fromJson(jsonData);
  } catch (e) {
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/course_Register/get_course_register_action.dart',
      duLieu: "ERROR actionCourseRegisterResponse",
    );
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/course_Register/get_course_register_action.dart',
      duLieu: e,
    );
    return null;
  }
}
