import 'dart:convert';

import 'package:aqedu/core/constants/api/api_daotao.dart';
import 'package:aqedu/core/models/sqlite/Session.dart';
import 'package:aqedu/core/services_root/api_daotao/auth/reLogin.dart';
import 'package:aqedu/core/services_root/api_daotao/root_daotao/daotao_post_get.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/core_service_session.dart';
import '../../../../features/program_training/models/model_program_data.dart';

Future<ProgramTrainingResponse?> getProgramTrainingResponse(
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
    final payload = {
      "filter": {"loai_chuong_trinh_dao_tao": 1},

      "additional": {
        "paging": {"limit": 500, "page": 1},

        "ordering": [
          {"name": null, "order_type": null},
        ],
      },
    };

    final res = await api.post(APITRAININGPROGRAM, payload);

    print("TYPE: ${res.runtimeType}");
    print("BODY: $res");

    if (res.toString().contains("<!DOCTYPE")) {
      print("Session hết hạn (HTML response)");
      print("Login lại...");

      final kt = await reLogin();

      if (kt == false) {
        print("Lỗi đăng nhập");
        return null;
      }

      final db = SqliteServices();
      final SessionModel? sqlite = await db.getSession();

      if (sqlite == null) {
        print("Không lấy được session");
        return null;
      }

      return getProgramTrainingResponse(
        sqlite.cookie,
        sqlite.token,
        retry: retry + 1,
      );
    }

    final Map<String, dynamic> jsonData = res is String
        ? jsonDecode(res)
        : res as Map<String, dynamic>;

    if (jsonData["result"] == false) {
      print("API lỗi: ${jsonData["message"]}");

      if (jsonData["message"] == "expired") {
        print("Token hết hạn → cần login lại");
        print("Login lại...");

        final kt = await reLogin();

        if (kt == false) {
          print("Lỗi đăng nhập");
          return null;
        }

        final db = SqliteServices();
        final SessionModel? sqlite = await db.getSession();

        if (sqlite == null) {
          print("Không lấy được session");
          return null;
        }

        return getProgramTrainingResponse(
          sqlite.cookie,
          sqlite.token,
          retry: retry + 1,
        );
      }

      return null;
    }

    if (jsonData["data"] == null) {
      print("Data null");
      return null;
    }

    return ProgramTrainingResponse.fromJson(jsonData);
  } catch (e) {
    print("Hey ERROR");
    print(e);
    return null;
  }
}
