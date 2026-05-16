import 'dart:convert';

import 'package:aqedu/core/constants/api/api_daotao.dart';
import 'package:aqedu/core/models/sqlite/Session.dart';
import 'package:aqedu/core/services_root/api_daotao/auth/reLogin.dart';
import 'package:aqedu/core/services_root/api_daotao/root_daotao/daotao_post_get.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/core_service_session.dart';
import 'package:aqedu/features/infor/models/models_inforStudent.dart';
//thay gia tri tra ve, doi ten ham
Future<StudentResponse?> getInformationResponse(
  String cookie,
  String token, {
  int retry = 0,
}) async {
  try {
    /// retry max
    if (retry > 2) {
      print("Retry quá số lần cho phép");
      return null;
    }

    /// init api
    final api = ApiHelper.withSession(cookie, token);

    final payload = {};//Thay payload

    /// call api
    final res = await api.post(APIINFORMATION, payload);//thay api

    print("========== RESPONSE ==========");
    print(res);
    print("TYPE: ${res.runtimeType}");

    /// response null
    if (res == null) {
      print("Response null");
      return null;
    }

    /// session expired -> html
    if (res.toString().contains("<!DOCTYPE")) {
      print("Session hết hạn (HTML response)");
      return await _handleRelogin(retry);
    }

    /// parse json safely
    dynamic decoded;

    try {
      decoded = res is String ? jsonDecode(res) : res;
    } catch (e) {
      print("JSON decode error");
      print(e);
      return null;
    }

    /// check map
    if (decoded is! Map<String, dynamic>) {
      print("Response không phải Map<String,dynamic>");
      print(decoded.runtimeType);
      return null;
    }

    final Map<String, dynamic> jsonData = decoded;

    print("========== JSON ==========");
    print(jsonEncode(jsonData));

    /// api result false
    if (jsonData["result"] == false) {
      print("API lỗi: ${jsonData["message"]}");

      /// token expired
      if (jsonData["message"]?.toString().toLowerCase() ==
          "expired") {
        print("Token hết hạn");
        return await _handleRelogin(retry);
      }

      return null;
    }

    /// data null
    final data = jsonData["data"];

    if (data == null) {
      print("Data null");
      return null;
    }

    /// data not map
    if (data is! Map<String, dynamic>) {
      print("Data không đúng format");
      print("TYPE DATA: ${data.runtimeType}");
      print(data);
      return null;
    }

    /// parse model
    try {
      return StudentResponse.fromJson(jsonData);
    } catch (e) {
      print("Parse StudentResponse lỗi");
      print(e);
      return null;
    }
  } catch (e, stackTrace) {
    print("========== ERROR ==========");
    print(e);
    print(stackTrace);
    return null;
  }
}

/// handle relogin
Future<StudentResponse?> _handleRelogin(int retry) async {
  try {
    print("Login lại...");

    bool kt = await reLogin();

    if (!kt) {
      print("Lỗi đăng nhập");
      return null;
    }

    SqliteServices db = SqliteServices();

    SessionModel? sqlite = await db.getSession();

    if (sqlite == null) {
      print("Không lấy được session");
      return null;
    }

    return await getInformationResponse(
      sqlite.cookie,
      sqlite.token,
      retry: retry + 1,
    );
  } catch (e) {
    print("Relogin error");
    print(e);
    return null;
  }
}