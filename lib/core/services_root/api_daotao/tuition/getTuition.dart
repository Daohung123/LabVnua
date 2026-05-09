import 'dart:convert';

import 'package:aqedu/core/constants/api/api_daotao.dart';
import 'package:aqedu/core/models/sqlite/Session.dart';
import 'package:aqedu/core/services_root/api_daotao/auth/reLogin.dart';
import 'package:aqedu/core/services_root/api_daotao/root_daotao/daotao_post_get.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/core_service_session.dart';
import 'package:aqedu/features/tuition/models/models_tuition.dart';


Future<HocPhiResponse?> getHocPhiResponse(
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

    // Nếu API của bạn chỉ cần gọi GET thì đổi sang api.get(APITUITON)
    // Nếu cần POST thì giữ api.post(APITUITON, payload)
    final payload = {};
    final res = await api.post(APITUITON, payload);

    print("TYPE: ${res.runtimeType}");
    print("BODY: $res");

    /// Nếu session hết hạn thì server thường trả về HTML
    if (res.toString().contains("<!DOCTYPE")) {
      print("Session hết hạn (HTML response)");
      bool kt = await reLogin();
      if (!kt) {
        print("Lỗi đăng nhập lại");
        return null;
      }

      SqliteServices db = SqliteServices();
      SessionModel? sqlite = await db.getSession();
      if (sqlite == null) {
        print("Không lấy được session mới");
        return null;
      }

      return getHocPhiResponse(
        sqlite.cookie,
        sqlite.token,
        retry: retry + 1,
      );
    }

    /// Parse JSON
    final Map<String, dynamic> jsonData = res is String
        ? jsonDecode(res) as Map<String, dynamic>
        : res as Map<String, dynamic>;

    /// API báo lỗi
    if (jsonData["result"] == false) {
      print("API lỗi: ${jsonData["message"]}");

      /// Xử lý riêng expired nếu API có trả message này
      if (jsonData["message"] == "expired") {
        print("Token hết hạn → login lại");

        bool kt = await reLogin();
        if (!kt) {
          print("Lỗi đăng nhập lại");
          return null;
        }

        SqliteServices db = SqliteServices();
        SessionModel? sqlite = await db.getSession();
        if (sqlite == null) {
          print("Không lấy được session mới");
          return null;
        }

        return getHocPhiResponse(
          sqlite.cookie,
          sqlite.token,
          retry: retry + 1,
        );
      }

      return null;
    }

    /// Data null
    if (jsonData["data"] == null) {
      print("Data null");
      return null;
    }

    /// Parse sang model
    return HocPhiResponse.fromJson(jsonData);
  } catch (e) {
    print("ERROR getHocPhiResponse");
    print(e);
    return null;
  }
}