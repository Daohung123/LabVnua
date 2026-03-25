import "../models/Schedure_Student.dart";
class TkbService {
  /// Parse an toàn (tránh crash null)
  static TkbResponse parse(dynamic json) {
    try {
      return TkbResponse.fromJson(json);
    } catch (e) {
      throw Exception("Parse TKB lỗi: $e");
    }
  }

  /// Lấy tuần hiện tại
  static TuanTkb? getCurrentWeek(TkbResponse tkb, int tuan) {
    try {
      return tkb.dsTuanTkb.firstWhere(
        (e) => e.tuanHocKy == tuan,
      );
    } catch (_) {
      return null;
    }
  }

  /// Lấy danh sách môn theo thứ (2-7)
  static List<ThoiKhoaBieu> getSubjectsByThu(
      TuanTkb tuan, int thu) {
    return tuan.dsThoiKhoaBieu
        .where((e) => e.thu == thu)
        .toList();
  }

  /// Lấy môn theo ngày hôm nay
  static List<ThoiKhoaBieu> getTodaySubjects(
      TkbResponse tkb, int tuan) {
    final today = DateTime.now().weekday; // 1-7
    final currentWeek = getCurrentWeek(tkb, tuan);

    if (currentWeek == null) return [];

    return getSubjectsByThu(currentWeek, today);
  }

  /// Lấy giờ bắt đầu - kết thúc của 1 môn
  static String getTimeRange(
      ThoiKhoaBieu mon, List<TietTrongNgay> tietList) {
    final startTiet = tietList.firstWhere(
      (t) => t.tiet == mon.tietBatDau,
      orElse: () => TietTrongNgay(
        tiet: 0,
        gioBatDau: "",
        gioKetThuc: "",
      ),
    );

    final endTiet = tietList.firstWhere(
      (t) => t.tiet == mon.tietBatDau + mon.soTiet - 1,
      orElse: () => startTiet,
    );

    return "${startTiet.gioBatDau} - ${endTiet.gioKetThuc}";
  }

  /// Format hiển thị đẹp
  static String formatSubject(
      ThoiKhoaBieu mon, List<TietTrongNgay> tietList) {
    final time = getTimeRange(mon, tietList);

    return """
📘 ${mon.tenMon}
👨‍🏫 ${mon.giangVien}
🏫 ${mon.phong}
⏰ $time
""";
  }
}