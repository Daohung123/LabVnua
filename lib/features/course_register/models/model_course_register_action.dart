class CourseRegisterActionResponse {
  final CourseRegisterActionData? data;
  final bool? result;
  final int? code;
  final String? message;

  CourseRegisterActionResponse({
    this.data,
    this.result,
    this.code,
    this.message,
  });

  factory CourseRegisterActionResponse.fromJson(Map<String, dynamic> json) {
    return CourseRegisterActionResponse(
      data: json['data'] != null
          ? CourseRegisterActionData.fromJson(json['data'])
          : null,
      result: json['result'],
      code: json['code'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'result': result,
      'code': code,
      'message': message,
    };
  }
}

class CourseRegisterActionData {
  final bool? isThanhCong;
  final String? thongBaoLoi;
  final bool? isChungNhomMonHoc;
  final bool? isShowNganhHoc;
  final CourseRegisterActionResult? ketQuaDangKy;
  final String? thongBaoTienQuyet;
  final String? idToHocXoa;
  final bool? isChoose;
  final String? idToHocChoose;
  final String? idRs;

  CourseRegisterActionData({
    this.isThanhCong,
    this.thongBaoLoi,
    this.isChungNhomMonHoc,
    this.isShowNganhHoc,
    this.ketQuaDangKy,
    this.thongBaoTienQuyet,
    this.idToHocXoa,
    this.isChoose,
    this.idToHocChoose,
    this.idRs,
  });

  factory CourseRegisterActionData.fromJson(Map<String, dynamic> json) {
    return CourseRegisterActionData(
      isThanhCong: json['is_thanh_cong'],
      thongBaoLoi: json['thong_bao_loi'],
      isChungNhomMonHoc: json['is_chung_nhom_mon_hoc'],
      isShowNganhHoc: json['is_show_nganh_hoc'],
      ketQuaDangKy: json['ket_qua_dang_ky'] != null
          ? CourseRegisterActionResult.fromJson(json['ket_qua_dang_ky'])
          : null,
      thongBaoTienQuyet: json['thong_bao_tien_quyet'],
      idToHocXoa: json['id_to_hoc_xoa'],
      isChoose: json['is_choose'],
      idToHocChoose: json['id_to_hoc_choose'],
      idRs: json['id_rs'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_thanh_cong': isThanhCong,
      'thong_bao_loi': thongBaoLoi,
      'is_chung_nhom_mon_hoc': isChungNhomMonHoc,
      'is_show_nganh_hoc': isShowNganhHoc,
      'ket_qua_dang_ky': ketQuaDangKy?.toJson(),
      'thong_bao_tien_quyet': thongBaoTienQuyet,
      'id_to_hoc_xoa': idToHocXoa,
      'is_choose': isChoose,
      'id_to_hoc_choose': idToHocChoose,
      'id_rs': idRs,
    };
  }
}

class CourseRegisterActionResult {
  final String? idKqdk;
  final String? trangThaiMon;
  final String? ngayDangKy;
  final String? nguoiDangKy;
  final bool? isDaRutMonHoc;
  final bool? enableXoa;
  final String? dienGiaiEnableXoa;
  final double? hocPhiTamTinh;
  final CourseRegisterActionToHoc? toHoc;
  final String? idDiaDiemThi;

  CourseRegisterActionResult({
    this.idKqdk,
    this.trangThaiMon,
    this.ngayDangKy,
    this.nguoiDangKy,
    this.isDaRutMonHoc,
    this.enableXoa,
    this.dienGiaiEnableXoa,
    this.hocPhiTamTinh,
    this.toHoc,
    this.idDiaDiemThi,
  });

  factory CourseRegisterActionResult.fromJson(Map<String, dynamic> json) {
    return CourseRegisterActionResult(
      idKqdk: json['id_kqdk'],
      trangThaiMon: json['trang_thai_mon'],
      ngayDangKy: json['ngay_dang_ky'],
      nguoiDangKy: json['nguoi_dang_ky'],
      isDaRutMonHoc: json['is_da_rut_mon_hoc'],
      enableXoa: json['enable_xoa'],
      dienGiaiEnableXoa: json['dien_giai_enable_xoa'],
      hocPhiTamTinh: (json['hoc_phi_tam_tinh'] as num?)?.toDouble(),
      toHoc: json['to_hoc'] != null
          ? CourseRegisterActionToHoc.fromJson(json['to_hoc'])
          : null,
      idDiaDiemThi: json['id_dia_diem_thi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_kqdk': idKqdk,
      'trang_thai_mon': trangThaiMon,
      'ngay_dang_ky': ngayDangKy,
      'nguoi_dang_ky': nguoiDangKy,
      'is_da_rut_mon_hoc': isDaRutMonHoc,
      'enable_xoa': enableXoa,
      'dien_giai_enable_xoa': dienGiaiEnableXoa,
      'hoc_phi_tam_tinh': hocPhiTamTinh,
      'to_hoc': toHoc?.toJson(),
      'id_dia_diem_thi': idDiaDiemThi,
    };
  }
}

class CourseRegisterActionToHoc {
  final String? idToHoc;
  final String? idMon;
  final String? maMon;
  final String? tenMon;
  final String? soTc;
  final double? soTcSo;
  final bool? isVuot;
  final String? nhomTo;
  final String? lop;
  final bool? isKdk;
  final int? slDk;
  final int? slCp;
  final int? slCl;
  final String? tkb;
  final bool? isHl;
  final bool? enable;
  final bool? hauk;
  final bool? isDk;
  final bool? isRot;
  final bool? isCtdt;
  final bool? isChctdt;
  final bool? isKgLt;
  final int? thu;
  final int? tbd;
  final int? soTiet;
  final bool? isKgHuyKqdk;
  final bool? isKgXetTrungtkb;
  final int? slNghiDay;
  final int? slDayBu;
  final bool? isDayBu;

  CourseRegisterActionToHoc({
    this.idToHoc,
    this.idMon,
    this.maMon,
    this.tenMon,
    this.soTc,
    this.soTcSo,
    this.isVuot,
    this.nhomTo,
    this.lop,
    this.isKdk,
    this.slDk,
    this.slCp,
    this.slCl,
    this.tkb,
    this.isHl,
    this.enable,
    this.hauk,
    this.isDk,
    this.isRot,
    this.isCtdt,
    this.isChctdt,
    this.isKgLt,
    this.thu,
    this.tbd,
    this.soTiet,
    this.isKgHuyKqdk,
    this.isKgXetTrungtkb,
    this.slNghiDay,
    this.slDayBu,
    this.isDayBu,
  });

  factory CourseRegisterActionToHoc.fromJson(Map<String, dynamic> json) {
    return CourseRegisterActionToHoc(
      idToHoc: json['id_to_hoc'],
      idMon: json['id_mon'],
      maMon: json['ma_mon'],
      tenMon: json['ten_mon'],
      soTc: json['so_tc'],
      soTcSo: (json['so_tc_so'] as num?)?.toDouble(),
      isVuot: json['is_vuot'],
      nhomTo: json['nhom_to'],
      lop: json['lop'],
      isKdk: json['is_kdk'],
      slDk: json['sl_dk'],
      slCp: json['sl_cp'],
      slCl: json['sl_cl'],
      tkb: json['tkb'],
      isHl: json['is_hl'],
      enable: json['enable'],
      hauk: json['hauk'],
      isDk: json['is_dk'],
      isRot: json['is_rot'],
      isCtdt: json['is_ctdt'],
      isChctdt: json['is_chctdt'],
      isKgLt: json['is_kg_lt'],
      thu: json['thu'],
      tbd: json['tbd'],
      soTiet: json['so_tiet'],
      isKgHuyKqdk: json['is_kg_huy_kqdk'],
      isKgXetTrungtkb: json['is_kg_xet_trungtkb'],
      slNghiDay: json['sl_nghi_day'],
      slDayBu: json['sl_day_bu'],
      isDayBu: json['is_day_bu'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_to_hoc': idToHoc,
      'id_mon': idMon,
      'ma_mon': maMon,
      'ten_mon': tenMon,
      'so_tc': soTc,
      'so_tc_so': soTcSo,
      'is_vuot': isVuot,
      'nhom_to': nhomTo,
      'lop': lop,
      'is_kdk': isKdk,
      'sl_dk': slDk,
      'sl_cp': slCp,
      'sl_cl': slCl,
      'tkb': tkb,
      'is_hl': isHl,
      'enable': enable,
      'hauk': hauk,
      'is_dk': isDk,
      'is_rot': isRot,
      'is_ctdt': isCtdt,
      'is_chctdt': isChctdt,
      'is_kg_lt': isKgLt,
      'thu': thu,
      'tbd': tbd,
      'so_tiet': soTiet,
      'is_kg_huy_kqdk': isKgHuyKqdk,
      'is_kg_xet_trungtkb': isKgXetTrungtkb,
      'sl_nghi_day': slNghiDay,
      'sl_day_bu': slDayBu,
      'is_day_bu': isDayBu,
    };
  }
}