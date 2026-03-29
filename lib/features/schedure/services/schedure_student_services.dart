import "../models/Schedure_Student.dart";
import 'package:intl/intl.dart';
class TkbService {
  static Future<List<ThoiKhoaBieu>> getSchedureByDay(TkbResponse tkb) async {
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

}