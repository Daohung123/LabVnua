import '../ctrl/ctrl_schedure.dart';
import '../model/schedure_Student.dart';

Future<void> viewSchedure(String cookie, String token) async {

  TkbResponse? tkb = await ctrlTkb(cookie, token);

  if (tkb == null) {
    print("Không lấy được thời khóa biểu");
    return;
  }

  print("===== THỜI KHÓA BIỂU =====");

  for (var tuan in tkb.dsTuanTkb) {

    print("\n${tuan.thongTinTuan}");

    for (var mon in tuan.dsThoiKhoaBieu) {

      print(
          "Thứ ${mon.thu} | Tiết ${mon.tietBatDau} | ${mon.tenMon} | ${mon.giangVien} | Phòng ${mon.phong}");
    }
  }

}