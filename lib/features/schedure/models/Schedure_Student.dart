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
    final data = json["data"];

    return TkbResponse(
      totalItems: data["total_items"],
      totalPages: data["total_pages"],
      dsTietTrongNgay: (data["ds_tiet_trong_ngay"] as List)
          .map((e) => TietTrongNgay.fromJson(e))
          .toList(),
      dsTuanTkb: (data["ds_tuan_tkb"] as List)
          .map((e) => TuanTkb.fromJson(e))
          .toList(),
    );
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
      tiet: json["tiet"],
      gioBatDau: json["gio_bat_dau"],
      gioKetThuc: json["gio_ket_thuc"],
    );
  }
}

class TuanTkb {
  final int tuanHocKy;
  final String thongTinTuan;
  final List<ThoiKhoaBieu> dsThoiKhoaBieu;

  TuanTkb({
    required this.tuanHocKy,
    required this.thongTinTuan,
    required this.dsThoiKhoaBieu,
  });

  factory TuanTkb.fromJson(Map<String, dynamic> json) {
    return TuanTkb(
      tuanHocKy: json["tuan_hoc_ky"],
      thongTinTuan: json["thong_tin_tuan"],
      dsThoiKhoaBieu: (json["ds_thoi_khoa_bieu"] as List)
          .map((e) => ThoiKhoaBieu.fromJson(e))
          .toList(),
    );
  }
}

class ThoiKhoaBieu {
  final int thu;
  final int tietBatDau;
  final int soTiet;
  final String tenMon;
  final String giangVien;
  final String phong;

  ThoiKhoaBieu({
    required this.thu,
    required this.tietBatDau,
    required this.soTiet,
    required this.tenMon,
    required this.giangVien,
    required this.phong,
  });

  factory ThoiKhoaBieu.fromJson(Map<String, dynamic> json) {
    return ThoiKhoaBieu(
      thu: json["thu_kieu_so"],
      tietBatDau: json["tiet_bat_dau"],
      soTiet: json["so_tiet"],
      tenMon: json["ten_mon"],
      giangVien: json["ten_giang_vien"],
      phong: json["ma_phong"],
    );
  }
}