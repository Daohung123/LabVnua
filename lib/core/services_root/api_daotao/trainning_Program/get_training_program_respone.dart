import 'package:aqedu/core/logging/app_log.dart';
import 'dart:convert';

import 'package:aqedu/core/constants/api/api_daotao.dart';
import 'package:aqedu/core/models/sqlite/session.dart';
import 'package:aqedu/core/services_root/api_daotao/auth/re_login.dart';
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
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/trainning_Program/get_training_program_respone.dart',
        duLieu: "Retry quá số lần cho phép",
      );
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

    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/trainning_Program/get_training_program_respone.dart',
      duLieu: "TYPE: ${res.runtimeType}",
    );
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/trainning_Program/get_training_program_respone.dart',
      duLieu: "BODY: $res",
    );
    if (res.toString().contains("<!DOCTYPE")) {
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/trainning_Program/get_training_program_respone.dart',
        duLieu: "Session hết hạn (HTML response)",
      );
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/trainning_Program/get_training_program_respone.dart',
        duLieu: "Login lại...",
      );
      final kt = await reLogin();

      if (kt == false) {
        AppLog.api(
          'Ghi nhận hoạt động runtime',
          khuVuc:
              'lib/core/services_root/api_daotao/trainning_Program/get_training_program_respone.dart',
          duLieu: "Lỗi đăng nhập",
        );
        return null;
      }

      final db = SqliteServices();
      final SessionModel? sqlite = await db.getSession();

      if (sqlite == null) {
        AppLog.api(
          'Ghi nhận hoạt động runtime',
          khuVuc:
              'lib/core/services_root/api_daotao/trainning_Program/get_training_program_respone.dart',
          duLieu: "Không lấy được session",
        );
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
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/trainning_Program/get_training_program_respone.dart',
        duLieu: "API lỗi: ${jsonData["message"]}",
      );
      if (jsonData["message"] == "expired") {
        AppLog.api(
          'Ghi nhận hoạt động runtime',
          khuVuc:
              'lib/core/services_root/api_daotao/trainning_Program/get_training_program_respone.dart',
          duLieu: "Token hết hạn → cần login lại",
        );
        AppLog.api(
          'Ghi nhận hoạt động runtime',
          khuVuc:
              'lib/core/services_root/api_daotao/trainning_Program/get_training_program_respone.dart',
          duLieu: "Login lại...",
        );
        final kt = await reLogin();

        if (kt == false) {
          AppLog.api(
            'Ghi nhận hoạt động runtime',
            khuVuc:
                'lib/core/services_root/api_daotao/trainning_Program/get_training_program_respone.dart',
            duLieu: "Lỗi đăng nhập",
          );
          return null;
        }

        final db = SqliteServices();
        final SessionModel? sqlite = await db.getSession();

        if (sqlite == null) {
          AppLog.api(
            'Ghi nhận hoạt động runtime',
            khuVuc:
                'lib/core/services_root/api_daotao/trainning_Program/get_training_program_respone.dart',
            duLieu: "Không lấy được session",
          );
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
      AppLog.api(
        'Ghi nhận hoạt động runtime',
        khuVuc:
            'lib/core/services_root/api_daotao/trainning_Program/get_training_program_respone.dart',
        duLieu: "Data null",
      );
      return null;
    }

    return ProgramTrainingResponse.fromJson(jsonData);
  } catch (e) {
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/trainning_Program/get_training_program_respone.dart',
      duLieu: "Hey ERROR",
    );
    AppLog.api(
      'Ghi nhận hoạt động runtime',
      khuVuc:
          'lib/core/services_root/api_daotao/trainning_Program/get_training_program_respone.dart',
      duLieu: e,
    );
    return null;
  }
}
