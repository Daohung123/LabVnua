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
      print("Ctrl: Lấy lịch học hôm nay...");
      TkbResponse? tkb = await core_services_get_TkbResponse(_cookie, _token);
      if (tkb == null) return [];
      return await TkbService.getScheduleInDay(
        await TkbService.getScheduleInWeek(tkb),
      );
    } catch (e) {
      log("Lỗi lấy TKB: $e");
      return [];
    }
  }

  Future<ThoiKhoaBieu> getTkbTodayItem() async {
    try {
      ThoiKhoaBieu data = await TkbService.getScheduleToday(_cookie, _token);

      return data;
    } catch (e) {
      print("Lỗi lấy TKB hôm nay: $e");
      print(e);
      return ThoiKhoaBieu(
        giangVien: "Không có giảng viên",
        ngayhoc: "",
        phong: "Không có phòng học",
        soTiet: 0,
        tenMon: "Không có lịch học hôm nay",
        thu: 0,
        tietBatDau: 0,
      );
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
