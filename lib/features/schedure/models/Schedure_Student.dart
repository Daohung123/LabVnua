class TkbResponse {
  final int totalItems;
  final int totalPages;
  final List<TietTrongNgay> dsTietTrongNgay;
  final List<TuanTkb> dsTuanTkb;

  TkbResponse({
    required this.totalItems,
    required this.totalPages,
    required this.dsTietTrongNgay,
    required this.dsTuanTkb,
  });

  factory TkbResponse.fromJson(Map<String, dynamic> json) {
    final data = json["data"] as Map<String, dynamic>;

    return TkbResponse(
      totalItems: data["total_items"] as int? ?? 0,
      totalPages: data["total_pages"] as int? ?? 0,
      dsTietTrongNgay: _parseList<TietTrongNgay>(
        data["ds_tiet_trong_ngay"],
        (e) => TietTrongNgay.fromJson(e),
      ),
      dsTuanTkb: _parseList<TuanTkb>(
        data["ds_tuan_tkb"],
        (e) => TuanTkb.fromJson(e),
      ),
    );
  }

  static List<T> _parseList<T>(
    dynamic data,
    T Function(Map<String, dynamic>) mapper,
  ) {
    if (data is! List) return [];
    return data.whereType<Map<String, dynamic>>().map(mapper).toList();
  }
}

class TietTrongNgay {
  final int tiet;
  final String gioBatDau;
  final String gioKetThuc;

  TietTrongNgay({
    required this.tiet,
    required this.gioBatDau,
    required this.gioKetThuc,
  });

  factory TietTrongNgay.fromJson(Map<String, dynamic> json) {
    return TietTrongNgay(
      tiet: json["tiet"] as int? ?? 0,
      gioBatDau: json["gio_bat_dau"] as String? ?? '',
      gioKetThuc: json["gio_ket_thuc"] as String? ?? '',
    );
  }
}

class TuanTkb {
  final int tuanHocKy;
  final String thongTinTuan;
  final String ngayBatDau;
  final String ngayKetThuc;
  final List<ThoiKhoaBieu> dsThoiKhoaBieu;

  TuanTkb({
    required this.tuanHocKy,
    required this.thongTinTuan,
    required this.ngayBatDau,
    required this.ngayKetThuc,
    required this.dsThoiKhoaBieu,
  });

  factory TuanTkb.fromJson(Map<String, dynamic> json) {
    return TuanTkb(
      tuanHocKy: json["tuan_hoc_ky"] as int? ?? 0,
      thongTinTuan: json["thong_tin_tuan"] as String? ?? '',
      ngayBatDau: json["ngay_bat_dau"] as String? ?? '',
      ngayKetThuc: json["ngay_ket_thuc"] as String? ?? '',
      dsThoiKhoaBieu: _parseScheduleList(json["ds_thoi_khoa_bieu"]),
    );
  }

  static List<ThoiKhoaBieu> _parseScheduleList(dynamic data) {
    if (data is! List) return [];
    return data
        .whereType<Map<String, dynamic>>()
        .map((e) => ThoiKhoaBieu.fromJson(e))
        .toList();
  }
}

class ThoiKhoaBieu {
  final int thu;
  final int tietBatDau;
  final int soTiet;
  final String tenMon;
  final String giangVien;
  final String phong;
  final String ngayhoc;

  ThoiKhoaBieu({
    required this.thu,
    required this.tietBatDau,
    required this.soTiet,
    required this.tenMon,
    required this.giangVien,
    required this.phong,
    required this.ngayhoc,
  });

  factory ThoiKhoaBieu.fromJson(Map<String, dynamic> json) {
    return ThoiKhoaBieu(
      thu: json["thu_kieu_so"] as int? ?? 0,
      tietBatDau: json["tiet_bat_dau"] as int? ?? 0,
      soTiet: json["so_tiet"] as int? ?? 0,
      tenMon: json["ten_mon"] as String? ?? '',
      giangVien: json["ten_giang_vien"] as String? ?? '',
      phong: json["ma_phong"] as String? ?? '',
      ngayhoc: json["ngay_hoc"] as String? ?? '',
    );
  }
}
