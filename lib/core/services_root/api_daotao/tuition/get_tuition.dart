import 'package:aqedu/core/logging/app_log.dart';
import 'dart:convert';

import 'package:aqedu/core/constants/api/api_daotao.dart';
import 'package:aqedu/core/models/sqlite/session.dart';
import 'package:aqedu/core/services_root/api_daotao/auth/re_login.dart';
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
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc: 'lib/core/services_root/api_daotao/tuition/get_tuition.dart',
        duLieu: "Retry quá số lần cho phép",
      );
      return null;
    }

    final api = ApiHelper.withSession(cookie, token);

    // Nếu API của bạn chỉ cần gọi GET thì đổi sang api.get(APITUITON)
    // Nếu cần POST thì giữ api.post(APITUITON, payload)
    final payload = {};
    final res = await api.post(APITUITON, payload);

    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc: 'lib/core/services_root/api_daotao/tuition/get_tuition.dart',
      duLieu: "TYPE: ${res.runtimeType}",
    );
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc: 'lib/core/services_root/api_daotao/tuition/get_tuition.dart',
      duLieu: "BODY: $res",
    );

    /// Nếu session hết hạn thì server thường trả về HTML
    if (res.toString().contains("<!DOCTYPE")) {
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc: 'lib/core/services_root/api_daotao/tuition/get_tuition.dart',
        duLieu: "Session hết hạn (HTML response)",
      );
      bool kt = await reLogin();
      if (!kt) {
        AppLog.api(
          'Ghi nhận hoạt động runtime',
          khuVuc: 'lib/core/services_root/api_daotao/tuition/get_tuition.dart',
          duLieu: "Lỗi đăng nhập lại",
        );
        return null;
      }

      SqliteServices db = SqliteServices();
      SessionModel? sqlite = await db.getSession();
      if (sqlite == null) {
        AppLog.api(
          'Ghi nhận hoạt động runtime',
          khuVuc: 'lib/core/services_root/api_daotao/tuition/get_tuition.dart',
          duLieu: "Không lấy được session mới",
        );
        return null;
      }

      return getHocPhiResponse(sqlite.cookie, sqlite.token, retry: retry + 1);
    }

    /// Parse JSON
    final Map<String, dynamic> jsonData = res is String
        ? jsonDecode(res) as Map<String, dynamic>
        : res as Map<String, dynamic>;

    /// API báo lỗi
    if (jsonData["result"] == false) {
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc: 'lib/core/services_root/api_daotao/tuition/get_tuition.dart',
        duLieu: "API lỗi: ${jsonData["message"]}",
      );

      /// Xử lý riêng expired nếu API có trả message này
      if (jsonData["message"] == "expired") {
        AppLog.api(
          'Ghi nhận hoạt động runtime',
          khuVuc: 'lib/core/services_root/api_daotao/tuition/get_tuition.dart',
          duLieu: "Token hết hạn → login lại",
        );
        bool kt = await reLogin();
        if (!kt) {
          AppLog.api(
            'Ghi nhận hoạt động runtime',
            khuVuc:
                'lib/core/services_root/api_daotao/tuition/get_tuition.dart',
            duLieu: "Lỗi đăng nhập lại",
          );
          return null;
        }

        SqliteServices db = SqliteServices();
        SessionModel? sqlite = await db.getSession();
        if (sqlite == null) {
          AppLog.api(
            'Ghi nhận hoạt động runtime',
            khuVuc:
                'lib/core/services_root/api_daotao/tuition/get_tuition.dart',
            duLieu: "Không lấy được session mới",
          );
          return null;
        }

        return getHocPhiResponse(sqlite.cookie, sqlite.token, retry: retry + 1);
      }

      return null;
    }

    /// Data null
    if (jsonData["data"] == null) {
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc: 'lib/core/services_root/api_daotao/tuition/get_tuition.dart',
        duLieu: "Data null",
      );
      return null;
    }

    /// Parse sang model
    return HocPhiResponse.fromJson(jsonData);
  } catch (e) {
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc: 'lib/core/services_root/api_daotao/tuition/get_tuition.dart',
      duLieu: "ERROR getHocPhiResponse",
    );
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc: 'lib/core/services_root/api_daotao/tuition/get_tuition.dart',
      duLieu: e,
    );
    return null;
  }
}
