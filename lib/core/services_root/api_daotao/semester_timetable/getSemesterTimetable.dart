import 'dart:convert';

import 'package:aqedu/core/constants/api/api_daotao.dart';
import 'package:aqedu/core/models/sqlite/Session.dart';
import 'package:aqedu/core/services_root/api_daotao/auth/reLogin.dart';
import 'package:aqedu/core/services_root/api_daotao/root_daotao/daotao_post_get.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/core_service_session.dart';
import 'package:aqedu/features/semester_timetable/models/model_semester_timetable.dart';

Future<SemesterTimetableResponse?> getSemesterTimetableResponse(
  String cookie,
  String token, {
  int retry = 0,
}) async {
  try {
    /// retry quá số lần
    if (retry > 2) {
      print("Retry quá số lần cho phép");
      return null;
    }

    /// khởi tạo api
    final api = ApiHelper.withSession(cookie, token);

    /// payload
    final payload = {"hoc_ky": 20252, "loai_doi_tuong": 1, "id_du_lieu": null};

    /// gọi api
    final res = await api.post(APISEMESTERTIMTABLE, payload);

    /// debug
    print("TYPE: ${res.runtimeType}");
    print("BODY: $res");

    /// session hết hạn -> html
    if (res.toString().contains("<!DOCTYPE")) {
      print("Session hết hạn (HTML response)");
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

      return getSemesterTimetableResponse(
        sqlite.cookie,
        sqlite.token,
        retry: retry + 1,
      );
    }

    /// parse json
    final jsonData = res is String
        ? jsonDecode(res)
        : res as Map<String, dynamic>;

    /// api báo lỗi
    if (jsonData["result"] == false) {
      print("API lỗi: ${jsonData["message"]}");

      /// token expired
      if (jsonData["message"] == "expired") {
        print("Token hết hạn → login lại");

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

        return getSemesterTimetableResponse(
          sqlite.cookie,
          sqlite.token,
          retry: retry + 1,
        );
      }

      return null;
    }

    /// data null
    if (jsonData["data"] == null) {
      print("Data null");
      return null;
    }

    /// parse model
    return SemesterTimetableResponse.fromJson(jsonData);
  } catch (e) {
    print("Hey ERROR");
    print(e);
    return null;
  }
}
