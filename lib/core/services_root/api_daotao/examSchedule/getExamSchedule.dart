import 'dart:convert';

import 'package:aqedu/core/constants/api/api_daotao.dart';
import 'package:aqedu/core/models/sqlite/Session.dart';
import 'package:aqedu/core/services_root/api_daotao/auth/reLogin.dart';
import 'package:aqedu/core/services_root/api_daotao/root_daotao/daotao_post_get.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/core_service_session.dart';
import 'package:aqedu/features/exam_schedule/models/model_exam_schedule.dart';

/// Lấy danh sách học kỳ lịch thi
Future<dynamic> getExamSemestersResponse(
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

    // CẬP NHẬT PAYLOAD CHUẨN THEO DEVTOOLS
    final payload = {
      "filter": {"is_tieng_anh": null},
      "additional": {
        "paging": {"limit": 100, "page": 1},
        "ordering": [{"name": null, "order_type": 1}]
      }
    };

    final res = await api.post(APIEXAM_SEMESTER, payload);

    if (res == null) {
      print("Response null");
      return null;
    }

    if (res.toString().contains("<!DOCTYPE")) {
      print("Session hết hạn (HTML response)");
      return await _handleRelogin(retry, (c, t) => getExamSemestersResponse(c, t, retry: retry + 1));
    }

    return res;
  } catch (e) {
    print("Error getExamSemestersResponse: $e");
    return null;
  }
}

/// Lấy mã đối tượng xem lịch thi (ObjectId)
Future<dynamic> getExamObjectIdResponse(
  String cookie,
  String token,
  int hocKy, {
  int retry = 0,
}) async {
  try {
    if (retry > 2) return null;

    final api = ApiHelper.withSession(cookie, token);
    final payload = {"filter": {"hoc_ky": hocKy}};

    final res = await api.post(APIEXAM_OBJECT, payload);

    if (res == null) return null;
    if (res.toString().contains("<!DOCTYPE")) {
      return await _handleRelogin(retry, (c, t) => getExamObjectIdResponse(c, t, hocKy, retry: retry + 1));
    }

    return res;
  } catch (e) {
    print("Error getExamObjectIdResponse: $e");
    return null;
  }
}

/// Lấy chi tiết lịch thi
Future<LichThiResponse?> getExamScheduleResponse(
  String cookie,
  String token,
  int hocKy,
  int objectId, {
  int retry = 0,
}) async {
  try {
    if (retry > 2) return null;

    final api = ApiHelper.withSession(cookie, token);
    
    // CẬP NHẬT PAYLOAD: Bổ sung các trường thường thiếu dẫn đến lỗi source
    final payload = {
      "filter": {
        "hoc_ky": hocKy, 
        "id_doituong": objectId,
        "is_tieng_anh": null
      },
      "additional": {
        "paging": {"limit": 100, "page": 1},
        "ordering": [{"name": null, "order_type": 1}]
      }
    };

    final res = await api.post(APIEXAM_SCHEDULE, payload);

    if (res == null) return null;
    if (res.toString().contains("<!DOCTYPE")) {
      return await _handleRelogin(retry, (c, t) => getExamScheduleResponse(c, t, hocKy, objectId, retry: retry + 1));
    }

    dynamic decoded = res is String ? jsonDecode(res) : res;
    if (decoded is! Map<String, dynamic>) return null;

    // THÊM LOG ĐỂ KIỂM TRA CẤU TRÚC DỮ LIỆU
    print("DEBUG: JSON Raw: $decoded");

    if (decoded["result"] == false) {
      if (decoded["message"]?.toString().toLowerCase() == "expired") {
        return await _handleRelogin(retry, (c, t) => getExamScheduleResponse(c, t, hocKy, objectId, retry: retry + 1));
      }
      return null;
    }

    return LichThiResponse.fromJson(decoded);
  } catch (e) {
    print("Error getExamScheduleResponse: $e");
    return null;
  }
}

/// Hàm hỗ trợ Login lại khi hết session
Future<T?> _handleRelogin<T>(int retry, Future<T?> Function(String cookie, String token) retryAction) async {
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

  return await retryAction(sqlite.cookie, sqlite.token);
}
