import 'package:aqedu/core/logging/app_log.dart';
import 'dart:convert';

import 'package:aqedu/core/constants/api/api_daotao.dart';
import 'package:aqedu/core/models/sqlite/session.dart';
import 'package:aqedu/core/services_root/api_daotao/auth/re_login.dart';
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
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/prerequisite_Subjects/get_prerequisite_respone.dart',
        duLieu: "Retry quá số lần cho phép",
      );
      return null;
    }

    final api = ApiHelper.withSession(cookie, token);

    final payload = {
      "loai_tien_quyet": loaiTienQuyet,
      "additional": {
        "paging": {"limit": 40, "page": 1},
        "ordering": [
          {"name": null, "order_type": null},
        ],
      },
    };

    final res = await api.post(APIPREREQUISTESUBJECT, payload);

    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/prerequisite_Subjects/get_prerequisite_respone.dart',
      duLieu: "TYPE: ${res.runtimeType}",
    );
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/prerequisite_Subjects/get_prerequisite_respone.dart',
      duLieu: "BODY: $res",
    );
    if (res.toString().contains("<!DOCTYPE")) {
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/prerequisite_Subjects/get_prerequisite_respone.dart',
        duLieu: "Session hết hạn (HTML response)",
      );
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/prerequisite_Subjects/get_prerequisite_respone.dart',
        duLieu: "Login lại...",
      );
      bool kt = await reLogin();
      if (kt == false) {
        AppLog.api(
          'Ghi nhận hoạt động runtime',
          khuVuc:
              'lib/core/services_root/api_daotao/prerequisite_Subjects/get_prerequisite_respone.dart',
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
              'lib/core/services_root/api_daotao/prerequisite_Subjects/get_prerequisite_respone.dart',
          duLieu: "Không lấy được session",
        );
        return null;
      }

      return getPrerequisiteResponse(
        sqlite.cookie,
        sqlite.token,
        loaiTienQuyet: loaiTienQuyet,
        retry: retry + 1,
      );
    }

    final jsonData = res is String
        ? jsonDecode(res)
        : res as Map<String, dynamic>;

    if (jsonData["result"] == false) {
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/prerequisite_Subjects/get_prerequisite_respone.dart',
        duLieu: "API lỗi: ${jsonData["message"]}",
      );
      if (jsonData["message"] == "expired") {
        AppLog.api(
          'Ghi nhận hoạt động runtime',
          khuVuc:
              'lib/core/services_root/api_daotao/prerequisite_Subjects/get_prerequisite_respone.dart',
          duLieu: "Token hết hạn → cần login lại",
        );
        AppLog.api(
          'Ghi nhận hoạt động runtime',
          khuVuc:
              'lib/core/services_root/api_daotao/prerequisite_Subjects/get_prerequisite_respone.dart',
          duLieu: "Login lại...",
        );
        bool kt = await reLogin();
        if (kt == false) {
          AppLog.api(
            'Ghi nhận hoạt động runtime',
            khuVuc:
                'lib/core/services_root/api_daotao/prerequisite_Subjects/get_prerequisite_respone.dart',
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
                'lib/core/services_root/api_daotao/prerequisite_Subjects/get_prerequisite_respone.dart',
            duLieu: "Không lấy được session",
          );
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
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/prerequisite_Subjects/get_prerequisite_respone.dart',
        duLieu: "Data null",
      );
      return null;
    }

    return PrerequisiteResponse.fromJson(jsonData);
  } catch (e) {
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/prerequisite_Subjects/get_prerequisite_respone.dart',
      duLieu: "Hey ERROR",
    );
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/prerequisite_Subjects/get_prerequisite_respone.dart',
      duLieu: e,
    );
    return null;
  }
}
