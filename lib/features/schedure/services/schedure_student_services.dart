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
      final fomatTime = DateFormat('dd/MM/yyyy');
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      final dsTkbTuan = tkb.dsTuanTkb;

      for (var item in dsTkbTuan) {
        DateTime startDate = fomatTime.parse(item.ngayBatDau);
        DateTime endDate = fomatTime.parse(item.ngayKetThuc);
        // Tránh bug giờ 00:00
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        endDate = DateTime(endDate.year, endDate.month, endDate.day);
        bool isInRange = !today.isBefore(startDate) && !today.isAfter(endDate);
        if (isInRange) {
          print("Tuần thứ: ${item.tuanHocKy}");
          return item.dsThoiKhoaBieu;
        }
      }

      return [];
    } catch (e) {
      print("Lỗi getSchedureInWeek: $e");
      return [];
    }
  }

  static Future<List<ThoiKhoaBieu>> getSchedureInDay(
    List<ThoiKhoaBieu> schedureWeek,
  ) async {
    try {
      // ✅ FIX: So sánh trực tiếp theo ngayhoc thay vì dùng thu + weekday
      //
      // BUG CŨ: int thuHomNay = now.weekday + 1;
      //   → Dart weekday: 1=Mon ... 7=Sun
      //   → Cộng 1 → Chủ Nhật = 8
      //   → Nhưng hệ thống VN dùng Chủ Nhật = 1 → không bao giờ khớp
      //   → Chủ Nhật luôn trả về rỗng dù có lịch
      //
      // FIX MỚI: Parse ngayhoc ("dd/MM/yyyy") rồi so sánh với ngày hôm nay
      //   → Chính xác 100%, không phụ thuộc cách encode "thu" của server
      final fomatTime = DateFormat('dd/MM/yyyy');
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);

      List<ThoiKhoaBieu> schedureDay = [];
      for (var item in schedureWeek) {
        try {
          final ngay = fomatTime.parse(item.ngayhoc);
          final ngayOnly = DateTime(ngay.year, ngay.month, ngay.day);
          if (ngayOnly == today) {
            schedureDay.add(item);
          }
        } catch (_) {
          // Bỏ qua item có ngayhoc không parse được
        }
      }

      return schedureDay;
    } catch (e) {
      print("Lỗi getSchedureInDay: $e");
      return [];
    }
  }
}
