class CourseRegisterResultResponse {
  final CourseRegisterResultData? data;
  final bool? result;
  final int? code;

  CourseRegisterResultResponse({
    this.data,
    this.result,
    this.code,
  });

  factory CourseRegisterResultResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return CourseRegisterResultResponse(
      data: json['data'] != null
          ? CourseRegisterResultData.fromJson(json['data'])
          : null,
      result: json['result'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'result': result,
      'code': code,
    };
  }
}

class CourseRegisterResultData {
  final int? totalItems;
  final int? totalPages;
  final int? soTinChiMin;
  final String? ngayIn;
  final bool? isShowNganhHoc;
  final bool? isShowDiaDiemThi;
  final List<dynamic>? dsKqdkmh;
  final bool? isGuiMailRutMh;
  final bool? isXacNhanKqdk;

  CourseRegisterResultData({
    this.totalItems,
    this.totalPages,
    this.soTinChiMin,
    this.ngayIn,
    this.isShowNganhHoc,
    this.isShowDiaDiemThi,
    this.dsKqdkmh,
    this.isGuiMailRutMh,
    this.isXacNhanKqdk,
  });

  factory CourseRegisterResultData.fromJson(
    Map<String, dynamic> json,
  ) {
    return CourseRegisterResultData(
      totalItems: json['total_items'],
      totalPages: json['total_pages'],
      soTinChiMin: json['so_tin_chi_min'],
      ngayIn: json['ngay_in'],
      isShowNganhHoc: json['is_show_nganh_hoc'],
      isShowDiaDiemThi: json['is_show_dia_diem_thi'],
      dsKqdkmh: json['ds_kqdkmh'] as List<dynamic>?,
      isGuiMailRutMh: json['is_gui_mail_rut_mh'],
      isXacNhanKqdk: json['is_xac_nhan_kqdk'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_items': totalItems,
      'total_pages': totalPages,
      'so_tin_chi_min': soTinChiMin,
      'ngay_in': ngayIn,
      'is_show_nganh_hoc': isShowNganhHoc,
      'is_show_dia_diem_thi': isShowDiaDiemThi,
      'ds_kqdkmh': dsKqdkmh,
      'is_gui_mail_rut_mh': isGuiMailRutMh,
      'is_xac_nhan_kqdk': isXacNhanKqdk,
    };
  }
}