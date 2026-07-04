// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:aqedu/core/logging/app_log.dart';
import 'dart:convert';

import 'package:aqedu/core/constants/api/api_daotao.dart';
import 'package:aqedu/core/services_root/api_daotao/daotao_read_payloads.dart';
import 'package:aqedu/core/models/sqlite/session.dart';
import 'package:aqedu/core/services_root/api_daotao/auth/re_login.dart';
import 'package:aqedu/core/services_root/api_daotao/root_daotao/daotao_post_get.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/core_service_session.dart';
import 'package:aqedu/features/schedure/models/schedure_student.dart';

Future<TkbResponse?> core_services_get_TkbResponse(
  String cookie,
  String token, {
  int retry = 0,
}) async {
  try {
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/schedure/get_tkb_response.dart',
      duLieu: "Lấy TkbResponse... (Retry: $retry)",
    );
    //kiểm tra
    if (retry > 2) {
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/schedure/get_tkb_response.dart',
        duLieu: "Retry quá số lần cho phép",
      );
      return null;
    }

    final api = ApiHelper.withSession(cookie, token);

    final res = await api.post(APISCHEDURE, daotaoSchedulePayload());

    /// ❌ HTML (hết session)
    /// Nếu session còn thì sẽ trả về json nhưng nếu session hết hạn thì sẽ trả về html
    if (res.toString().contains("<!DOCTYPE")) {
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/schedure/get_tkb_response.dart',
        duLieu: "Session hết hạn (HTML response)",
      );
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/schedure/get_tkb_response.dart',
        duLieu: "Login lại...",
      );
      bool kt = await reLogin();
      if (kt == false) {
        AppLog.api(
          'Ghi nhận hoạt động runtime',
          khuVuc:
              'lib/core/services_root/api_daotao/schedure/get_tkb_response.dart',
          duLieu: "Lỗi đăng nhập",
        );
        return null;
      }
      SqliteServices db = SqliteServices();
      SessionModel? sqlite = await db.getSession();
      if (sqlite == null) {
        AppLog.api(
          'Ghi nhận hoạt động runtime',
          khuVuc:
              'lib/core/services_root/api_daotao/schedure/get_tkb_response.dart',
          duLieu: "Không lấy được session",
        );
        return null;
      }
      return core_services_get_TkbResponse(
        sqlite.cookie,
        sqlite.token,
        retry: retry + 1,
      );
    }

    /// parse json
    final jsonData = res is String
        ? jsonDecode(res)
        : res as Map<String, dynamic>;

    /// ❌ API báo lỗi
    if (jsonData["result"] == false) {
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/schedure/get_tkb_response.dart',
        duLieu: "API lỗi: ${jsonData["message"]}",
      );

      /// 🔥 xử lý riêng expired
      if (jsonData["message"] == "expired") {
        AppLog.api(
          'Ghi nhận hoạt động runtime',
          khuVuc:
              'lib/core/services_root/api_daotao/schedure/get_tkb_response.dart',
          duLieu: "Token hết hạn → cần login lại",
        );
        AppLog.api(
          'Ghi nhận hoạt động runtime',
          khuVuc:
              'lib/core/services_root/api_daotao/schedure/get_tkb_response.dart',
          duLieu: "Login lại...",
        );
        bool kt = await reLogin();
        if (kt == false) {
          AppLog.api(
            'Ghi nhận hoạt động runtime',
            khuVuc:
                'lib/core/services_root/api_daotao/schedure/get_tkb_response.dart',
            duLieu: "Lỗi đăng nhập",
          );
          return null;
        }
        SqliteServices db = SqliteServices();
        SessionModel? sqlite = await db.getSession();
        if (sqlite == null) {
          AppLog.api(
            'Ghi nhận hoạt động runtime',
            khuVuc:
                'lib/core/services_root/api_daotao/schedure/get_tkb_response.dart',
            duLieu: "Không lấy được session",
          );
          return null;
        }
        return core_services_get_TkbResponse(
          sqlite.cookie,
          sqlite.token,
          retry: retry + 1,
        );
      }

      return null;
    }

    /// ❌ data null
    if (jsonData["data"] == null) {
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/schedure/get_tkb_response.dart',
        duLieu: "Data null",
      );
      return null;
    }

    /// ✅ OK
    TkbResponse data = TkbResponse.fromJson(jsonData);
    return data;
  } catch (e) {
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/schedure/get_tkb_response.dart',
      duLieu: "Lỗi lấy TKB: $e",
    );
    return null;
  }
}
