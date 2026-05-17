class LichThi {
  final String? idNhomThi;
  final String maMon;
  final String tenMon;
  final String maPhong;
  final String ngayThi;
  final String gioBatDau;
  final String soPhut;
  final String hinhThucThi;
  final int? siSo;
  final String? soTiet;
  final String? toThi;
  final String? ghiChu;

  LichThi({
    this.idNhomThi, required this.maMon, required this.tenMon, required this.maPhong,
    required this.ngayThi, required this.gioBatDau, required this.soPhut,
    required this.hinhThucThi, this.siSo, this.soTiet, this.toThi, this.ghiChu,
  });

  factory LichThi.fromJson(Map<String, dynamic> json) {
    return LichThi(
      idNhomThi: json['id_nhom_thi']?.toString(), // Dùng String cho số cực lớn
      maMon: json['ma_mon']?.toString() ?? '',
      tenMon: json['ten_mon']?.toString() ?? '',
      maPhong: json['ma_phong']?.toString() ?? '',
      ngayThi: json['ngay_thi']?.toString() ?? '',
      gioBatDau: json['gio_bat_dau']?.toString() ?? '',
      soPhut: json['so_phut']?.toString() ?? '',
      hinhThucThi: json['hinh_thuc_thi']?.toString() ?? '',
      siSo: json['si_so'] is int ? json['si_so'] : int.tryParse(json['si_so']?.toString() ?? '0'),
      soTiet: json['so_tiet']?.toString(),
      toThi: json['to_thi']?.toString() ?? json['nhom_thi']?.toString(),
      ghiChu: (json['ghi_chu_sv']?.toString() ?? '') + (json['ghi_chu_htt']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
    'id_nhom_thi': idNhomThi, 'ma_mon': maMon, 'ten_mon': tenMon, 'ma_phong': maPhong,
    'ngay_thi': ngayThi, 'gio_bat_dau': gioBatDau, 'so_phut': soPhut,
    'hinh_thuc_thi': hinhThucThi, 'si_so': siSo, 'so_tiet': soTiet, 'to_thi': toThi, 'ghi_chu': ghiChu,
  };

  Map<String, dynamic> toMap(int hocKyId) {
    var map = toJson();
    map['hoc_ky_id'] = hocKyId;
    return map;
  }

  factory LichThi.fromMap(Map<String, dynamic> map) {
    return LichThi(
      idNhomThi: map['id_nhom_thi']?.toString(),
      maMon: map['ma_mon'] ?? '',
      tenMon: map['ten_mon'] ?? '',
      maPhong: map['ma_phong'] ?? '',
      ngayThi: map['ngay_thi'] ?? '',
      gioBatDau: map['gio_bat_dau'] ?? '',
      soPhut: map['so_phut']?.toString() ?? '',
      hinhThucThi: map['hinh_thuc_thi'] ?? '',
      siSo: map['si_so'],
      soTiet: map['so_tiet'],
      toThi: map['to_thi'],
      ghiChu: map['ghi_chu'],
    );
  }
}
