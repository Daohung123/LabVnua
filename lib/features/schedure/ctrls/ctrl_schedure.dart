import 'dart:developer';

import 'package:aqedu/core/services_root/api_daotao/schedure/getTkbResponse.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/services_get_cookie_token.dart';

import '../models/Schedure_Student.dart';
import '../services/schedure_student_services.dart';

class CtrlSchedure {
  final String _cookie;
  final String _token;

  CtrlSchedure._(this._cookie, this._token);

  static Future<CtrlSchedure> create() async {
    final cookie = await GETDB.getCookie();
    final token = await GETDB.getToken();
    return CtrlSchedure._(cookie, token);
  }

  // Long_sua :(Cập nhật hàm để nhận thêm tham số semesterId khi gọi API)
  Future<TkbResponse?> getFullTkbResponse({int? semesterId}) async {
    try {
      return await core_services_get_TkbResponse(_cookie, _token);
    } catch (e) {
      log("Lỗi lấy TkbResponse: $e");
      return null;
    }
  }

  Future<List<ThoiKhoaBieu>> getTkbToday() async {
    try {
      TkbResponse? tkb = await core_services_get_TkbResponse(_cookie, _token);
      if (tkb == null) return [];
      return await TkbService.getSchedureInDay(
        await TkbService.getSchedureInWeek(tkb),
      );
    } catch (e) {
      log("Lỗi lấy TKB: $e");
      return [];
    }
  }

  Future<List<ThoiKhoaBieu>> getTkbInSemester() async {
    try {
      return await TkbService.getScheduleByDayInSemester(_cookie, _token);
    } catch (e) {
      print(e);
      return [];
    }
  }
}
