import 'package:aqedu/core/services_root/api_daotao/schedure/getTkbResponse.dart';

import "../models/Schedure_Student.dart";
import 'package:intl/intl.dart';

class TkbService {
  static Future<List<TuanTkb>> getWeekSchedures(cookie, token) async {
    try {
      TkbResponse? tkb = await core_services_get_TkbResponse(cookie, token);
      if (tkb == null) {
        print("TkbResponse null");
        return [];
      }
      return tkb.dsTuanTkb;
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<List<ThoiKhoaBieu>> getScheduleByDayInSemester(
    cookie,
    token,
  ) async {
    //Lay tat ca tiet trong 1 ky
    try {
      TkbResponse? tkb = await core_services_get_TkbResponse(cookie, token);
      if (tkb == null) return [];
      List<ThoiKhoaBieu> schedure = [];
      List<TuanTkb> schedureInWeek = tkb.dsTuanTkb ?? [];
      for (var itemTuanTkb in schedureInWeek) {
        for (var itemThoiKhoaBieu in itemTuanTkb.dsThoiKhoaBieu) {
          schedure.add(itemThoiKhoaBieu);
        }
      }
      return schedure;
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<List<ThoiKhoaBieu>> getSchedureInWeek(TkbResponse tkb) async {
    try {
      //Lấy tuần học hiện tại
      final fomatTime = DateFormat('dd/MM/yyyy');
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      final dsTkbTuan = await tkb.dsTuanTkb;

      for (var item in dsTkbTuan) {
        DateTime startDate = fomatTime.parse(item.ngayBatDau);
        DateTime endDate = fomatTime.parse(item.ngayKetThuc);
        //tranh bug gio 00:00
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        endDate = DateTime(endDate.year, endDate.month, endDate.day);
        bool isInRange = !today.isBefore(startDate) && !today.isAfter(endDate);
        if (isInRange) {
          print("Tuan thu: ${item.tuanHocKy}");
          return item.dsThoiKhoaBieu;
        }
      }

      return [];
    } catch (e) {
      print("Lỗi: $e");
      return [];
    }
  }

  static Future<List<ThoiKhoaBieu>> getSchedureInDay(
    List<ThoiKhoaBieu> schedureWeek,
  ) async {
    try {
      //Lấy tuần học hiện tại
      final fomatTime = DateFormat('dd/MM/yyyy');
      DateTime now = DateTime.now();
      int thuHomNay = now.weekday + 1;
      List<ThoiKhoaBieu> schedureDay = [];
      for (var item in schedureWeek) {
        //test xem thử thời khóa biểu thứ 7
        print(thuHomNay);
        if (item.thu == thuHomNay) {
          schedureDay.add(item);
        }
      }

      return schedureDay;
    } catch (e) {
      print("Lỗi: $e");
      return [];
    }
  }
}
