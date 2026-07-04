// ignore_for_file: avoid_print, non_constant_identifier_names

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
    print("Lấy TkbResponse... (Retry: $retry)");
    //kiểm tra
    if (retry > 2) {
      print("Retry quá số lần cho phép");
      return null;
    }

    final api = ApiHelper.withSession(cookie, token);

    final res = await api.post(APISCHEDURE, daotaoSchedulePayload());

    /// ❌ HTML (hết session)
    /// Nếu session còn thì sẽ trả về json nhưng nếu session hết hạn thì sẽ trả về html
    if (res.toString().contains("<!DOCTYPE")) {
      print("Session hết hạn (HTML response)");
      print("Login lại...");
      bool kt = await reLogin();
      if (kt == false) {
        print("Lỗi đăng nhập");
        return null;
      }
      SqliteServices db = SqliteServices();
      SessionModel? sqlite = await db.getSession();
      if (sqlite == null) {
        print("Không lấy được session");
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
      print("API lỗi: ${jsonData["message"]}");

      /// 🔥 xử lý riêng expired
      if (jsonData["message"] == "expired") {
        print("Token hết hạn → cần login lại");
        print("Login lại...");
        bool kt = await reLogin();
        if (kt == false) {
          print("Lỗi đăng nhập");
          return null;
        }
        SqliteServices db = SqliteServices();
        SessionModel? sqlite = await db.getSession();
        if (sqlite == null) {
          print("Không lấy được session");
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
      print("Data null");
      return null;
    }

    /// ✅ OK
    TkbResponse data = TkbResponse.fromJson(jsonData);
    return data;
  } catch (e) {
    print("Lỗi lấy TKB: $e");
    return null;
  }
}
