class ScoreResponse {
  final ScoreData? data;

  ScoreResponse({this.data});

  factory ScoreResponse.fromJson(Map<String, dynamic> json) {
    return ScoreResponse(
      data: json['data'] != null ? ScoreData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
    };
  }
}

class ScoreData {
  final int? totalItems;
  final int? totalPages;
  final bool? isKkbd;
  final List<SemesterScore>? dsDiemHocky;

  ScoreData({
    this.totalItems,
    this.totalPages,
    this.isKkbd,
    this.dsDiemHocky,
  });

  factory ScoreData.fromJson(Map<String, dynamic> json) {
    return ScoreData(
      totalItems: json['total_items'],
      totalPages: json['total_pages'],
      isKkbd: json['is_kkbd'],
      dsDiemHocky: (json['ds_diem_hocky'] as List<dynamic>?)
          ?.map((e) => SemesterScore.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_items': totalItems,
      'total_pages': totalPages,
      'is_kkbd': isKkbd,
      'ds_diem_hocky': dsDiemHocky?.map((e) => e.toJson()).toList(),
    };
  }
}

class SemesterScore {
  final int? loaiNganh;
  final String? hocKy;
  final String? tenHocKy;
  final String? dtbHkHe10;
  final String? dtbHkHe4;
  final String? dtbTichLuyHe10;
  final String? dtbTichLuyHe4;
  final String? soTinChiDatHk;
  final String? soTinChiDatTichLuy;
  final bool? hienThiTkHe10;
  final bool? hienThiTkHe4;
  final String? xepLoaiTkbHk;
  final String? xepLoaiTkbHkEg;
  final String? canhCaoHocTap;
  final String? canhCaoHocTapEg;
  final List<SubjectScore>? dsDiemMonHoc;

  SemesterScore({
    this.loaiNganh,
    this.hocKy,
    this.tenHocKy,
    this.dtbHkHe10,
    this.dtbHkHe4,
    this.dtbTichLuyHe10,
    this.dtbTichLuyHe4,
    this.soTinChiDatHk,
    this.soTinChiDatTichLuy,
    this.hienThiTkHe10,
    this.hienThiTkHe4,
    this.xepLoaiTkbHk,
    this.xepLoaiTkbHkEg,
    this.canhCaoHocTap,
    this.canhCaoHocTapEg,
    this.dsDiemMonHoc,
  });

  factory SemesterScore.fromJson(Map<String, dynamic> json) {
    return SemesterScore(
      loaiNganh: json['loai_nganh'],
      hocKy: json['hoc_ky'],
      tenHocKy: json['ten_hoc_ky'],
      dtbHkHe10: json['dtb_hk_he10'],
      dtbHkHe4: json['dtb_hk_he4'],
      dtbTichLuyHe10: json['dtb_tich_luy_he_10'],
      dtbTichLuyHe4: json['dtb_tich_luy_he_4'],
      soTinChiDatHk: json['so_tin_chi_dat_hk'],
      soTinChiDatTichLuy: json['so_tin_chi_dat_tich_luy'],
      hienThiTkHe10: json['hien_thi_tk_he_10'],
      hienThiTkHe4: json['hien_thi_tk_he_4'],
      xepLoaiTkbHk: json['xep_loai_tkb_hk'],
      xepLoaiTkbHkEg: json['xep_loai_tkb_hk_eg'],
      canhCaoHocTap: json['canh_cao_hoc_tap'],
      canhCaoHocTapEg: json['canh_cao_hoc_tap_eg'],
      dsDiemMonHoc: (json['ds_diem_mon_hoc'] as List<dynamic>?)
          ?.map((e) => SubjectScore.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loai_nganh': loaiNganh,
      'hoc_ky': hocKy,
      'ten_hoc_ky': tenHocKy,
      'dtb_hk_he10': dtbHkHe10,
      'dtb_hk_he4': dtbHkHe4,
      'dtb_tich_luy_he_10': dtbTichLuyHe10,
      'dtb_tich_luy_he_4': dtbTichLuyHe4,
      'so_tin_chi_dat_hk': soTinChiDatHk,
      'so_tin_chi_dat_tich_luy': soTinChiDatTichLuy,
      'hien_thi_tk_he_10': hienThiTkHe10,
      'hien_thi_tk_he_4': hienThiTkHe4,
      'xep_loai_tkb_hk': xepLoaiTkbHk,
      'xep_loai_tkb_hk_eg': xepLoaiTkbHkEg,
      'canh_cao_hoc_tap': canhCaoHocTap,
      'canh_cao_hoc_tap_eg': canhCaoHocTapEg,
      'ds_diem_mon_hoc': dsDiemMonHoc?.map((e) => e.toJson()).toList(),
    };
  }
}

class SubjectScore {
  final String? chuyenDiemVeHocKy;
  final String? maMon;
  final String? maMonTt;
  final String? nhomTo;
  final String? tenMon;
  final String? tenMonEg;
  final bool? monHocNganh;
  final String? soTinChi;
  final String? diemThi;
  final String? diemGiuaKy;
  final String? diemTk;
  final String? diemTkSo;
  final String? diemTkChu;
  final int? ketQua;
  final bool? hienThiKetQua;
  final int? loaiNganh;
  final int? khoaThi;
  final int? khongTinhDiemTbtl;
  final String? lyDoKhongTinhDiemTbtl;
  final List<ComponentScore>? dsDiemThanhPhan;

  SubjectScore({
    this.chuyenDiemVeHocKy,
    this.maMon,
    this.maMonTt,
    this.nhomTo,
    this.tenMon,
    this.tenMonEg,
    this.monHocNganh,
    this.soTinChi,
    this.diemThi,
    this.diemGiuaKy,
    this.diemTk,
    this.diemTkSo,
    this.diemTkChu,
    this.ketQua,
    this.hienThiKetQua,
    this.loaiNganh,
    this.khoaThi,
    this.khongTinhDiemTbtl,
    this.lyDoKhongTinhDiemTbtl,
    this.dsDiemThanhPhan,
  });

  factory SubjectScore.fromJson(Map<String, dynamic> json) {
    return SubjectScore(
      chuyenDiemVeHocKy: json['chuyen_diem_ve_hoc_ky'],
      maMon: json['ma_mon'],
      maMonTt: json['ma_mon_tt'],
      nhomTo: json['nhom_to'],
      tenMon: json['ten_mon'],
      tenMonEg: json['ten_mon_eg'],
      monHocNganh: json['mon_hoc_nganh'],
      soTinChi: json['so_tin_chi'],
      diemThi: json['diem_thi'],
      diemGiuaKy: json['diem_giua_ky'],
      diemTk: json['diem_tk'],
      diemTkSo: json['diem_tk_so'],
      diemTkChu: json['diem_tk_chu'],
      ketQua: json['ket_qua'],
      hienThiKetQua: json['hien_thi_ket_qua'],
      loaiNganh: json['loai_nganh'],
      khoaThi: json['KhoaThi'],
      khongTinhDiemTbtl: json['khong_tinh_diem_tbtl'],
      lyDoKhongTinhDiemTbtl: json['ly_do_khong_tinh_diem_tbtl'],
      dsDiemThanhPhan: (json['ds_diem_thanh_phan'] as List<dynamic>?)
          ?.map((e) => ComponentScore.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chuyen_diem_ve_hoc_ky': chuyenDiemVeHocKy,
      'ma_mon': maMon,
      'ma_mon_tt': maMonTt,
      'nhom_to': nhomTo,
      'ten_mon': tenMon,
      'ten_mon_eg': tenMonEg,
      'mon_hoc_nganh': monHocNganh,
      'so_tin_chi': soTinChi,
      'diem_thi': diemThi,
      'diem_giua_ky': diemGiuaKy,
      'diem_tk': diemTk,
      'diem_tk_so': diemTkSo,
      'diem_tk_chu': diemTkChu,
      'ket_qua': ketQua,
      'hien_thi_ket_qua': hienThiKetQua,
      'loai_nganh': loaiNganh,
      'KhoaThi': khoaThi,
      'khong_tinh_diem_tbtl': khongTinhDiemTbtl,
      'ly_do_khong_tinh_diem_tbtl': lyDoKhongTinhDiemTbtl,
      'ds_diem_thanh_phan': dsDiemThanhPhan?.map((e) => e.toJson()).toList(),
    };
  }
}

class ComponentScore {
  final String? kyHieu;
  final String? tenThanhPhan;
  final String? trongSo;
  final String? diemThanhPhan;

  ComponentScore({
    this.kyHieu,
    this.tenThanhPhan,
    this.trongSo,
    this.diemThanhPhan,
  });

  factory ComponentScore.fromJson(Map<String, dynamic> json) {
    return ComponentScore(
      kyHieu: json['ky_hieu'],
      tenThanhPhan: json['ten_thanh_phan'],
      trongSo: json['trong_so'],
      diemThanhPhan: json['diem_thanh_phan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ky_hieu': kyHieu,
      'ten_thanh_phan': tenThanhPhan,
      'trong_so': trongSo,
      'diem_thanh_phan': diemThanhPhan,
    };
  }
}