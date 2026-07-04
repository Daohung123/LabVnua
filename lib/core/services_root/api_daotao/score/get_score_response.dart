import 'package:aqedu/core/logging/app_log.dart';
import 'dart:convert';

import 'package:aqedu/core/constants/api/api_daotao.dart';
import 'package:aqedu/core/models/sqlite/session.dart';
import 'package:aqedu/core/services_root/api_daotao/auth/re_login.dart';
import 'package:aqedu/core/services_root/api_daotao/root_daotao/daotao_post_get.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/core_service_session.dart';
import 'package:aqedu/features/score_data/models/model_score_student.dart';

Future<ScoreResponse?> getScoreResponse(
  String cookie,
  String token, {
  int retry = 0,
}) async {
  try {
    //kiểm tra
    if (retry > 2) {
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/score/get_score_response.dart',
        duLieu: "Retry quá số lần cho phép",
      );
      return null;
    }

    //khai bao doi tuong api với token và cookiee
    final api = ApiHelper.withSession(cookie, token);
    final payload = {};

    //goi phuong thuc post
    final res = await api.post(APISCOREDATA, payload);

    /// debug
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc: 'lib/core/services_root/api_daotao/score/get_score_response.dart',
      duLieu: "TYPE: ${res.runtimeType}",
    );
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc: 'lib/core/services_root/api_daotao/score/get_score_response.dart',
      duLieu: "BODY: $res",
    );

    /// ❌ HTML (hết session)
    /// Nếu session còn thì sẽ trả về json nhưng nếu session hết hạn thì sẽ trả về html
    if (res.toString().contains("<!DOCTYPE")) {
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/score/get_score_response.dart',
        duLieu: "Session hết hạn (HTML response)",
      );
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/score/get_score_response.dart',
        duLieu: "Login lại...",
      );
      bool kt = await reLogin();
      if (kt == false) {
        AppLog.api(
          'Ghi nhận hoạt động runtime',
          khuVuc:
              'lib/core/services_root/api_daotao/score/get_score_response.dart',
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
              'lib/core/services_root/api_daotao/score/get_score_response.dart',
          duLieu: "Không lấy được session",
        );
        return null;
      }
      return getScoreResponse(sqlite.cookie, sqlite.token, retry: retry + 1);
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
            'lib/core/services_root/api_daotao/score/get_score_response.dart',
        duLieu: "API lỗi: ${jsonData["message"]}",
      );

      /// 🔥 xử lý riêng expired
      if (jsonData["message"] == "expired") {
        AppLog.api(
          'Ghi nhận hoạt động runtime',
          khuVuc:
              'lib/core/services_root/api_daotao/score/get_score_response.dart',
          duLieu: "Token hết hạn → cần login lại",
        );
        AppLog.api(
          'Ghi nhận hoạt động runtime',
          khuVuc:
              'lib/core/services_root/api_daotao/score/get_score_response.dart',
          duLieu: "Login lại...",
        );
        bool kt = await reLogin();
        if (kt == false) {
          AppLog.api(
            'Ghi nhận hoạt động runtime',
            khuVuc:
                'lib/core/services_root/api_daotao/score/get_score_response.dart',
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
                'lib/core/services_root/api_daotao/score/get_score_response.dart',
            duLieu: "Không lấy được session",
          );
          return null;
        }
        return getScoreResponse(sqlite.cookie, sqlite.token, retry: retry + 1);
      }

      return null;
    }

    /// ❌ data null
    if (jsonData["data"] == null) {
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/score/get_score_response.dart',
        duLieu: "Data null",
      );
      return null;
    }

    return ScoreResponse.fromJson(res);
  } catch (e) {
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc: 'lib/core/services_root/api_daotao/score/get_score_response.dart',
      duLieu: "Hey ERROR",
    );
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc: 'lib/core/services_root/api_daotao/score/get_score_response.dart',
      duLieu: e,
    );
    return null;
  }
}
