import 'package:aqedu/core/logging/app_log.dart';
import 'dart:convert';

import 'package:aqedu/core/constants/api/api_daotao.dart';
import 'package:aqedu/core/models/sqlite/session.dart';
import 'package:aqedu/core/services_root/api_daotao/auth/re_login.dart';
import 'package:aqedu/core/services_root/api_daotao/root_daotao/daotao_post_get.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/core_service_session.dart';
import 'package:aqedu/features/infor/models/models_infor_student.dart';

//thay gia tri tra ve, doi ten ham
Future<StudentResponse?> getInformationResponse(
  String cookie,
  String token, {
  int retry = 0,
}) async {
  try {
    /// retry max
    if (retry > 2) {
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/information_Student/get_information.dart',
        duLieu: "Retry quá số lần cho phép",
      );
      return null;
    }

    /// init api
    final api = ApiHelper.withSession(cookie, token);

    final payload = {}; //Thay payload

    /// call api
    final res = await api.post(APIINFORMATION, payload); //thay api

    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/information_Student/get_information.dart',
      duLieu: "========== RESPONSE ==========",
    );
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/information_Student/get_information.dart',
      duLieu: res,
    );
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/information_Student/get_information.dart',
      duLieu: "TYPE: ${res.runtimeType}",
    );

    /// response null
    if (res == null) {
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/information_Student/get_information.dart',
        duLieu: "Response null",
      );
      return null;
    }

    /// session expired -> html
    if (res.toString().contains("<!DOCTYPE")) {
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/information_Student/get_information.dart',
        duLieu: "Session hết hạn (HTML response)",
      );
      return await _handleRelogin(retry);
    }

    /// parse json safely
    dynamic decoded;

    try {
      decoded = res is String ? jsonDecode(res) : res;
    } catch (e) {
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/information_Student/get_information.dart',
        duLieu: "JSON decode error",
      );
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/information_Student/get_information.dart',
        duLieu: e,
      );
      return null;
    }

    /// check map
    if (decoded is! Map<String, dynamic>) {
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/information_Student/get_information.dart',
        duLieu: "Response không phải Map<String,dynamic>",
      );
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/information_Student/get_information.dart',
        duLieu: decoded.runtimeType,
      );
      return null;
    }

    final Map<String, dynamic> jsonData = decoded;

    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/information_Student/get_information.dart',
      duLieu: "========== JSON ==========",
    );
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/information_Student/get_information.dart',
      duLieu: jsonEncode(jsonData),
    );

    /// api result false
    if (jsonData["result"] == false) {
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/information_Student/get_information.dart',
        duLieu: "API lỗi: ${jsonData["message"]}",
      );

      /// token expired
      if (jsonData["message"]?.toString().toLowerCase() == "expired") {
        AppLog.api(
          'Ghi nhận hoạt động runtime',
          khuVuc:
              'lib/core/services_root/api_daotao/information_Student/get_information.dart',
          duLieu: "Token hết hạn",
        );
        return await _handleRelogin(retry);
      }

      return null;
    }

    /// data null
    final data = jsonData["data"];

    if (data == null) {
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/information_Student/get_information.dart',
        duLieu: "Data null",
      );
      return null;
    }

    /// data not map
    if (data is! Map<String, dynamic>) {
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/information_Student/get_information.dart',
        duLieu: "Data không đúng format",
      );
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/information_Student/get_information.dart',
        duLieu: "TYPE DATA: ${data.runtimeType}",
      );
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/information_Student/get_information.dart',
        duLieu: data,
      );
      return null;
    }

    /// parse model
    try {
      return StudentResponse.fromJson(jsonData);
    } catch (e) {
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/information_Student/get_information.dart',
        duLieu: "Parse StudentResponse lỗi",
      );
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/information_Student/get_information.dart',
        duLieu: e,
      );
      return null;
    }
  } catch (e, stackTrace) {
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/information_Student/get_information.dart',
      duLieu: "========== ERROR ==========",
    );
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/information_Student/get_information.dart',
      duLieu: e,
    );
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/information_Student/get_information.dart',
      duLieu: stackTrace,
    );
    return null;
  }
}

/// handle relogin
Future<StudentResponse?> _handleRelogin(int retry) async {
  try {
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/information_Student/get_information.dart',
      duLieu: "Login lại...",
    );
    bool kt = await reLogin();

    if (!kt) {
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/information_Student/get_information.dart',
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
            'lib/core/services_root/api_daotao/information_Student/get_information.dart',
        duLieu: "Không lấy được session",
      );
      return null;
    }

    return await getInformationResponse(
      sqlite.cookie,
      sqlite.token,
      retry: retry + 1,
    );
  } catch (e) {
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/information_Student/get_information.dart',
      duLieu: "Relogin error",
    );
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/information_Student/get_information.dart',
      duLieu: e,
    );
    return null;
  }
}
