class CourseRegisterResponse {
  final CourseRegisterData? data;
  final bool? result;
  final int? code;
  final String? idRs;

  CourseRegisterResponse({
    this.data,
    this.result,
    this.code,
    this.idRs,
  });

  factory CourseRegisterResponse.fromJson(Map<String, dynamic> json) {
    return CourseRegisterResponse(
      data: json['data'] != null
          ? CourseRegisterData.fromJson(json['data'])
          : null,
      result: json['result'],
      code: json['code'],
      idRs: json['id_rs'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'result': result,
      'code': code,
      'id_rs': idRs,
    };
  }
}

class CourseRegisterData {
  final int? totalItems;
  final int? totalPages;

  final List<CourseRegisterFaculty>? dsKhoa;
  final List<CourseRegisterStudentClass>? dsLop;
  final List<CourseRegisterSubject>? dsMonHoc;
  final List<CourseRegisterClass>? dsNhomTo;

  CourseRegisterData({
    this.totalItems,
    this.totalPages,
    this.dsKhoa,
    this.dsLop,
    this.dsMonHoc,
    this.dsNhomTo,
  });

  factory CourseRegisterData.fromJson(Map<String, dynamic> json) {
    return CourseRegisterData(
      totalItems: json['total_items'],
      totalPages: json['total_pages'],
      dsKhoa: (json['ds_khoa'] as List<dynamic>?)
          ?.map((e) => CourseRegisterFaculty.fromJson(e))
          .toList(),
      dsLop: (json['ds_lop'] as List<dynamic>?)
          ?.map((e) => CourseRegisterStudentClass.fromJson(e))
          .toList(),
      dsMonHoc: (json['ds_mon_hoc'] as List<dynamic>?)
          ?.map((e) => CourseRegisterSubject.fromJson(e))
          .toList(),
      dsNhomTo: (json['ds_nhom_to'] as List<dynamic>?)
          ?.map((e) => CourseRegisterClass.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_items': totalItems,
      'total_pages': totalPages,
      'ds_khoa': dsKhoa?.map((e) => e.toJson()).toList(),
      'ds_lop': dsLop?.map((e) => e.toJson()).toList(),
      'ds_mon_hoc': dsMonHoc?.map((e) => e.toJson()).toList(),
      'ds_nhom_to': dsNhomTo?.map((e) => e.toJson()).toList(),
    };
  }
}

class CourseRegisterFaculty {
  final String? ma;
  final String? ten;

  CourseRegisterFaculty({this.ma, this.ten});

  factory CourseRegisterFaculty.fromJson(Map<String, dynamic> json) {
    return CourseRegisterFaculty(
      ma: json['ma'],
      ten: json['ten'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ma': ma,
      'ten': ten,
    };
  }
}

class CourseRegisterStudentClass {
  final String? ma;
  final String? ten;

  CourseRegisterStudentClass({this.ma, this.ten});

  factory CourseRegisterStudentClass.fromJson(Map<String, dynamic> json) {
    return CourseRegisterStudentClass(
      ma: json['ma'],
      ten: json['ten'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ma': ma,
      'ten': ten,
    };
  }
}

class CourseRegisterSubject {
  final String? ma;
  final String? ten;
  final String? tenEg;

  CourseRegisterSubject({
    this.ma,
    this.ten,
    this.tenEg,
  });

  factory CourseRegisterSubject.fromJson(Map<String, dynamic> json) {
    return CourseRegisterSubject(
      ma: json['ma'],
      ten: json['ten'],
      tenEg: json['ten_eg'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ma': ma,
      'ten': ten,
      'ten_eg': tenEg,
    };
  }
}

class CourseRegisterClass {
  final String? idToHoc;
  final String? idMon;
  final String? idRs;

  final String? maMon;
  final String? tenMon;
  final String? tenMonEg;

  final String? soTc;
  final double? soTcSo;

  final String? to;
  final String? nhomTo;
  final String? lop;

  final List<String>? dsLop;
  final List<String>? dsKhoa;

  final int? slDk;
  final int? slCp;
  final int? slCl;

  final String? tkb;

  final bool? enable;
  final bool? isDk;
  final bool? isCtdt;
  final bool? isChctdt;
  final bool? isRot;

  final String? gcEnable;

  CourseRegisterClass({
    this.idToHoc,
    this.idMon,
    this.idRs,
    this.maMon,
    this.tenMon,
    this.tenMonEg,
    this.soTc,
    this.soTcSo,
    this.to,
    this.nhomTo,
    this.lop,
    this.dsLop,
    this.dsKhoa,
    this.slDk,
    this.slCp,
    this.slCl,
    this.tkb,
    this.enable,
    this.isDk,
    this.isCtdt,
    this.isChctdt,
    this.isRot,
    this.gcEnable,
  });

  factory CourseRegisterClass.fromJson(Map<String, dynamic> json) {
    return CourseRegisterClass(
      idToHoc: json['id_to_hoc'],
      idMon: json['id_mon'],
      idRs: json['id_rs'],
      maMon: json['ma_mon'],
      tenMon: json['ten_mon'],
      tenMonEg: json['ten_mon_eg'],
      soTc: json['so_tc'],
      soTcSo: (json['so_tc_so'] as num?)?.toDouble(),
      to: json['to'],
      nhomTo: json['nhom_to'],
      lop: json['lop'],
      dsLop: (json['ds_lop'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      dsKhoa: (json['ds_khoa'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      slDk: json['sl_dk'],
      slCp: json['sl_cp'],
      slCl: json['sl_cl'],
      tkb: json['tkb'],
      enable: json['enable'],
      isDk: json['is_dk'],
      isCtdt: json['is_ctdt'],
      isChctdt: json['is_chctdt'],
      isRot: json['is_rot'],
      gcEnable: json['gc_enable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_to_hoc': idToHoc,
      'id_mon': idMon,
      'id_rs': idRs,
      'ma_mon': maMon,
      'ten_mon': tenMon,
      'ten_mon_eg': tenMonEg,
      'so_tc': soTc,
      'so_tc_so': soTcSo,
      'to': to,
      'nhom_to': nhomTo,
      'lop': lop,
      'ds_lop': dsLop,
      'ds_khoa': dsKhoa,
      'sl_dk': slDk,
      'sl_cp': slCp,
      'sl_cl': slCl,
      'tkb': tkb,
      'enable': enable,
      'is_dk': isDk,
      'is_ctdt': isCtdt,
      'is_chctdt': isChctdt,
      'is_rot': isRot,
      'gc_enable': gcEnable,
    };
  }
}