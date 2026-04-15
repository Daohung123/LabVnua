import 'package:aqedu/core/constants/env_api_daotao.dart';
import 'package:aqedu/features/schedure/models/Schedure_Student.dart';
import './service_api_daotao_post_get.dart';
import 'dart:convert';
import '../../features/auth/ctrls/ctrl_login.dart';
import '../../config/config_DB.dart';
import '../../shared/models/sqlite/cookie_token_model.dart';

Future<TkbResponse?> core_services_get_TkbResponse(
  String cookie,
  String token, {
  int retry = 0,
}) async {
  try {
    //kiểm tra
    if (retry > 2) {
      print("Retry quá số lần cho phép");
      return null;
    }

    final api = ApiHelper.withSession(cookie, token);

    final res = await api.post(APISCHEDURE, {
      "filter": {"hoc_ky": 20252, "ten_hoc_ky": ""},
      "additional": {
        "paging": {"limit": 100, "page": 1},
        "ordering": [
          {"name": null, "order_type": null},
        ],
      },
    });

    /// debug
    print("TYPE: ${res.runtimeType}");
    print("BODY: $res");

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
      DBHelper db = DBHelper();
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
        DBHelper db = DBHelper();
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
    return TkbResponse.fromJson(jsonData);
  } catch (e) {
    print("Lỗi lấy TKB: $e");
    return null;
  }
}

Future<bool> reLogin() async {
  DBHelper sqlite = DBHelper();
  SessionModel? customer = await sqlite.getSession();
  if (customer == null) {
    print("Lỗi dữ liệu customer null!!");
    return false;
  }
  return await ctrl_login(customer.user, customer.pass);
}

Future<bool> checkLogin() async {
  DBHelper db = DBHelper();
  SessionModel? customer = await db.getSession();
  print("user: ${customer!.user}");
  print("pass: ${customer!.pass}");
  print("cookie: ${customer!.cookie}");
  print("token: ${customer!.token}");
  bool checkCount = await db.checkLogin();
  if (checkCount != true) {
    print("Lỗi count sql: ${checkCount}");
    return false;
  }
  if (customer == null) {
    print("Lỗi dữ liệu customer null!!");
    return false;
  }
  return await ctrl_login(customer.user, customer.pass);
}
