class HocPhiResponse {
  final HocPhiData data;

  HocPhiResponse({required this.data});

  factory HocPhiResponse.fromJson(Map<String, dynamic> json) {
    return HocPhiResponse(
      data: HocPhiData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "data": data.toJson(),
    };
  }
}
class HocPhiData {
  final int totalItems;
  final int totalPages;
  final bool isTinhTong;
  final bool isShowHocBong;
  final bool isTgDongHocPhi;
  final bool isHvsg;
  final bool isShowDonGia;
  final List<HocPhiHocKy> dsHocPhiHocKy;

  HocPhiData({
    required this.totalItems,
    required this.totalPages,
    required this.isTinhTong,
    required this.isShowHocBong,
    required this.isTgDongHocPhi,
    required this.isHvsg,
    required this.isShowDonGia,
    required this.dsHocPhiHocKy,
  });

  factory HocPhiData.fromJson(Map<String, dynamic> json) {
    return HocPhiData(
      totalItems: json['total_items'],
      totalPages: json['total_pages'],
      isTinhTong: json['is_tinh_tong'],
      isShowHocBong: json['is_show_hoc_bong'],
      isTgDongHocPhi: json['is_tg_dong_hoc_phi'],
      isHvsg: json['is_hvsg'],
      isShowDonGia: json['is_show_don_gia'],
      dsHocPhiHocKy: (json['ds_hoc_phi_hoc_ky'] as List)
          .map((e) => HocPhiHocKy.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "total_items": totalItems,
      "total_pages": totalPages,
      "is_tinh_tong": isTinhTong,
      "is_show_hoc_bong": isShowHocBong,
      "is_tg_dong_hoc_phi": isTgDongHocPhi,
      "is_hvsg": isHvsg,
      "is_show_don_gia": isShowDonGia,
      "ds_hoc_phi_hoc_ky":
          dsHocPhiHocKy.map((e) => e.toJson()).toList(),
    };
  }
}
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
      tenNhomCt: json['ten_nhom_ct'],
      tenHocKy: json['ten_hoc_ky'],
      hocPhi: json['hoc_phi'],
      mienGiam: json['mien_giam'],
      duocHoTro: json['duoc_ho_tro'],
      phaiThu: json['phai_thu'],
      tongHocBong: json['tong_hoc_bong'] ?? "",
      daThu: json['da_thu'],
      conNo: json['con_no'],
      ghiChu: json['ghi_chu'] ?? "",
      donGia: json['don_gia'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nhhk": nhhk,
      "ten_nhom_ct": tenNhomCt,
      "ten_hoc_ky": tenHocKy,
      "hoc_phi": hocPhi,
      "mien_giam": mienGiam,
      "duoc_ho_tro": duocHoTro,
      "phai_thu": phaiThu,
      "tong_hoc_bong": tongHocBong,
      "da_thu": daThu,
      "con_no": conNo,
      "ghi_chu": ghiChu,
      "don_gia": donGia,
    };
  }
}