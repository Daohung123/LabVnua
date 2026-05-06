class HocPhiHocKy {
  final int nhhk;
  final String tenNhomCt;
  final String tenHocKy;

  final String hocPhi;
  final String mienGiam;
  final String duocHoTro;
  final String phaiThu;
  final String tongHocBong;
  final String daThu;
  final String conNo;
  final String ghiChu;
  final String donGia;

  HocPhiHocKy({
    required this.nhhk,
    required this.tenNhomCt,
    required this.tenHocKy,
    required this.hocPhi,
    required this.mienGiam,
    required this.duocHoTro,
    required this.phaiThu,
    required this.tongHocBong,
    required this.daThu,
    required this.conNo,
    required this.ghiChu,
    required this.donGia,
  });

  factory HocPhiHocKy.fromJson(Map<String, dynamic> json) {
    return HocPhiHocKy(
      nhhk: json['nhhk'],
      tenNhomCt: json['ten_nhom_ct'] ?? '',
      tenHocKy: json['ten_hoc_ky'] ?? '',
      hocPhi: json['hoc_phi'] ?? '0',
      mienGiam: json['mien_giam'] ?? '0',
      duocHoTro: json['duoc_ho_tro'] ?? '0',
      phaiThu: json['phai_thu'] ?? '0',
      tongHocBong: json['tong_hoc_bong'] ?? '',
      daThu: json['da_thu'] ?? '0',
      conNo: json['con_no'] ?? '0',
      ghiChu: json['ghi_chu'] ?? '',
      donGia: json['don_gia'] ?? '0',
    );
  }

  Map<String, dynamic> toJson() => {
        'nhhk': nhhk,
        'ten_nhom_ct': tenNhomCt,
        'ten_hoc_ky': tenHocKy,
        'hoc_phi': hocPhi,
        'mien_giam': mienGiam,
        'duoc_ho_tro': duocHoTro,
        'phai_thu': phaiThu,
        'tong_hoc_bong': tongHocBong,
        'da_thu': daThu,
        'con_no': conNo,
        'ghi_chu': ghiChu,
        'don_gia': donGia,
      };
}