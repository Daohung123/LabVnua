import 'package:aqedu/core/logging/app_log.dart';
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
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/course_Register/get_course_register_respone.dart',
        duLieu: "Retry quá số lần cho phép",
      );
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

    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/course_Register/get_course_register_respone.dart',
      duLieu: "TYPE COURSE REGISTER: ${res.runtimeType}",
    );
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/course_Register/get_course_register_respone.dart',
      duLieu: "BODY COURSE REGISTER: $res",
    );
    if (res.toString().contains("<!DOCTYPE")) {
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/course_Register/get_course_register_respone.dart',
        duLieu: "Session hết hạn HTML",
      );
      final kt = await reLogin();

      if (kt == false) {
        AppLog.api(
          'Ghi nhận hoạt động runtime',
          khuVuc:
              'lib/core/services_root/api_daotao/course_Register/get_course_register_respone.dart',
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
              'lib/core/services_root/api_daotao/course_Register/get_course_register_respone.dart',
          duLieu: "Không lấy được session",
        );
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
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/course_Register/get_course_register_respone.dart',
        duLieu: "API lỗi: ${jsonData["message"]}",
      );
      if (jsonData["message"] == "expired") {
        final kt = await reLogin();

        if (kt == false) {
          AppLog.api(
            'Ghi nhận hoạt động runtime',
            khuVuc:
                'lib/core/services_root/api_daotao/course_Register/get_course_register_respone.dart',
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
                'lib/core/services_root/api_daotao/course_Register/get_course_register_respone.dart',
            duLieu: "Không lấy được session",
          );
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
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/course_Register/get_course_register_respone.dart',
        duLieu: "Data null",
      );
      return null;
    }

    return CourseRegisterResponse.fromJson(jsonData);
  } catch (e) {
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/course_Register/get_course_register_respone.dart',
      duLieu: "ERROR getCourseRegisterResponse",
    );
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/course_Register/get_course_register_respone.dart',
      duLieu: e,
    );
    return null;
  }
}
