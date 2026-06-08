class CourseRegisterResultResponse {
  final CourseRegisterResultData? data;
  final bool? result;
  final int? code;

  CourseRegisterResultResponse({
    this.data,
    this.result,
    this.code,
  });

  factory CourseRegisterResultResponse.fromJson(Map<String, dynamic> json) {
    return CourseRegisterResultResponse(
      data: json['data'] != null
          ? CourseRegisterResultData.fromJson(json['data'])
          : null,
      result: json['result'],
      code: json['code'],
    );
  }
}

class CourseRegisterResultData {
  final int? totalItems;
  final int? totalPages;
  final int? soTinChiMin;
  final String? ngayIn;
  final List<CourseRegisterResultItem>? dsKqdkmh;

  CourseRegisterResultData({
    this.totalItems,
    this.totalPages,
    this.soTinChiMin,
    this.ngayIn,
    this.dsKqdkmh,
  });

  factory CourseRegisterResultData.fromJson(Map<String, dynamic> json) {
    return CourseRegisterResultData(
      totalItems: json['total_items'],
      totalPages: json['total_pages'],
      soTinChiMin: json['so_tin_chi_min'],
      ngayIn: json['ngay_in'],
      dsKqdkmh: (json['ds_kqdkmh'] as List<dynamic>?)
          ?.map((e) => CourseRegisterResultItem.fromJson(e))
          .toList(),
    );
  }
}

class CourseRegisterResultItem {
  final String? idToHoc;
  final String? maMon;
  final String? tenMon;
  final String? tenMonEg;
  final String? soTc;
  final String? nhomTo;
  final String? lop;
  final String? tkb;
  final bool? enableXoa;

  CourseRegisterResultItem({
    this.idToHoc,
    this.maMon,
    this.tenMon,
    this.tenMonEg,
    this.soTc,
    this.nhomTo,
    this.lop,
    this.tkb,
    this.enableXoa,
  });

  factory CourseRegisterResultItem.fromJson(Map<String, dynamic> json) {
    final toHoc = json['to_hoc'];

    return CourseRegisterResultItem(
      idToHoc: json['id_to_hoc'] ?? toHoc?['id_to_hoc'],
      maMon: json['ma_mon'] ?? toHoc?['ma_mon'],
      tenMon: json['ten_mon'] ?? toHoc?['ten_mon'],
      tenMonEg: json['ten_mon_eg'] ?? toHoc?['ten_mon_eg'],
      soTc: json['so_tc'] ?? toHoc?['so_tc'],
      nhomTo: json['nhom_to'] ?? toHoc?['nhom_to'],
      lop: json['lop'] ?? toHoc?['lop'],
      tkb: json['tkb'] ?? toHoc?['tkb'],
      enableXoa: json['enable_xoa'],
    );
  }
}