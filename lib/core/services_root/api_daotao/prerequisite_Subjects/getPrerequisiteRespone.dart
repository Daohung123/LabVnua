import 'dart:convert';

import 'package:aqedu/core/constants/api/api_daotao.dart';
import 'package:aqedu/core/models/sqlite/Session.dart';
import 'package:aqedu/core/services_root/api_daotao/auth/reLogin.dart';
import 'package:aqedu/core/services_root/api_daotao/root_daotao/daotao_post_get.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/core_service_session.dart';
import '../../../../features/prerequisite_subjects/models/model_prequisite_subjects.dart';

Future<PrerequisiteResponse?> getPrerequisiteResponse(
  String cookie,
  String token, {
  int loaiTienQuyet = 1,
  int retry = 0,
}) async {
  try {
    if (retry > 2) {
      print("Retry quá số lần cho phép");
      return null;
    }

    final api = ApiHelper.withSession(cookie, token);

    final payload = {
      "loai_tien_quyet": loaiTienQuyet,
      "additional": {
        "paging": {
          "limit": 40,
          "page": 1,
        },
        "ordering": [
          {
            "name": null,
            "order_type": null,
          },
        ],
      },
    };

    final res = await api.post(APIPREREQUISTESUBJECT, payload);

    print("TYPE: ${res.runtimeType}");
    print("BODY: $res");

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

      return getPrerequisiteResponse(
        sqlite.cookie,
        sqlite.token,
        loaiTienQuyet: loaiTienQuyet,
        retry: retry + 1,
      );
    }

    final jsonData =
        res is String ? jsonDecode(res) : res as Map<String, dynamic>;

    if (jsonData["result"] == false) {
      print("API lỗi: ${jsonData["message"]}");

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

        return getPrerequisiteResponse(
          sqlite.cookie,
          sqlite.token,
          loaiTienQuyet: loaiTienQuyet,
          retry: retry + 1,
        );
      }

      return null;
    }

    if (jsonData["data"] == null) {
      print("Data null");
      return null;
    }

    return PrerequisiteResponse.fromJson(jsonData);
  } catch (e) {
    print("Hey ERROR");
    print(e);
    return null;
  }
}