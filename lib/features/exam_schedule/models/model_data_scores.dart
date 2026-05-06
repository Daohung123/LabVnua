class DiemMonHoc {
  final String tenMon;
  final bool monHocNganh;
  final int ketQua;
  final bool hienThiKetQua;
  final int khoaThi;
  final int khongTinhDiemTbtl;
  final List<dynamic> dsDiemThanhPhan;

  DiemMonHoc({
    required this.tenMon,
    required this.monHocNganh,
    required this.ketQua,
    required this.hienThiKetQua,
    required this.khoaThi,
    required this.khongTinhDiemTbtl,
    required this.dsDiemThanhPhan,
  });

  factory DiemMonHoc.fromJson(Map<String, dynamic> json) {
    return DiemMonHoc(
      tenMon: json['ten_mon'] ?? '',
      monHocNganh: json['mon_hoc_nganh'] ?? false,
      ketQua: json['ket_qua'] ?? 0,
      hienThiKetQua: json['hien_thi_ket_qua'] ?? false,
      khoaThi: json['KhoaThi'] ?? 0,
      khongTinhDiemTbtl: json['khong_tinh_diem_tbtl'] ?? 0,
      dsDiemThanhPhan: json['ds_diem_thanh_phan'] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'ten_mon': tenMon,
        'mon_hoc_nganh': monHocNganh,
        'ket_qua': ketQua,
        'hien_thi_ket_qua': hienThiKetQua,
        'KhoaThi': khoaThi,
        'khong_tinh_diem_tbtl': khongTinhDiemTbtl,
        'ds_diem_thanh_phan': dsDiemThanhPhan,
      };
}