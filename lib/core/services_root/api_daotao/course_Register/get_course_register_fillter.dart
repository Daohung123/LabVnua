import 'package:aqedu/core/logging/app_log.dart';
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
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/course_Register/get_course_register_fillter.dart',
        duLieu: "Retry quá số lần cho phép",
      );
      return null;
    }

    final api = ApiHelper.withSession(cookie, token);
    final payload = {};

    final res = await api.post(APICOURSEREGISTERFILLTER, payload);

    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/course_Register/get_course_register_fillter.dart',
      duLieu: "TYPE FILTER: ${res.runtimeType}",
    );
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/course_Register/get_course_register_fillter.dart',
      duLieu: "BODY FILTER: $res",
    );
    if (res.toString().contains("<!DOCTYPE")) {
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/course_Register/get_course_register_fillter.dart',
        duLieu: "Session hết hạn HTML",
      );
      final kt = await reLogin();

      if (kt == false) {
        AppLog.api(
          'Ghi nhận hoạt động runtime',
          khuVuc:
              'lib/core/services_root/api_daotao/course_Register/get_course_register_fillter.dart',
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
              'lib/core/services_root/api_daotao/course_Register/get_course_register_fillter.dart',
          duLieu: "Không lấy được session",
        );
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
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/course_Register/get_course_register_fillter.dart',
        duLieu: "API lỗi: ${jsonData["message"]}",
      );
      if (jsonData["message"] == "expired") {
        final kt = await reLogin();

        if (kt == false) {
          AppLog.api(
            'Ghi nhận hoạt động runtime',
            khuVuc:
                'lib/core/services_root/api_daotao/course_Register/get_course_register_fillter.dart',
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
                'lib/core/services_root/api_daotao/course_Register/get_course_register_fillter.dart',
            duLieu: "Không lấy được session",
          );
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
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/course_Register/get_course_register_fillter.dart',
        duLieu: "Filter response không phải List",
      );
      return null;
    }

    return jsonData.map((e) => CourseRegisterFilter.fromJson(e)).toList();
  } catch (e) {
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/course_Register/get_course_register_fillter.dart',
      duLieu: "ERROR getCourseRegisterFilterResponse",
    );
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/course_Register/get_course_register_fillter.dart',
      duLieu: e,
    );
    return null;
  }
}
