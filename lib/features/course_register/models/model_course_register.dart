class CourseRegisterResponse {
  final CourseRegisterData? data;

  CourseRegisterResponse({this.data});

  factory CourseRegisterResponse.fromJson(Map<String, dynamic> json) {
    return CourseRegisterResponse(
      data: json['data'] != null
          ? CourseRegisterData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
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

  CourseRegisterFaculty({
    this.ma,
    this.ten,
  });

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

  CourseRegisterStudentClass({
    this.ma,
    this.ten,
  });

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

  final String? maMon;
  final String? tenMon;
  final String? tenMonEg;

  final String? soTc;
  final double? soTcSo;

  final String? nhomTo;
  final String? lop;

  final int? slDk;
  final int? slCp;
  final int? slCl;

  final String? tkb;

  final bool? enable;
  final bool? isDk;

  final String? gcEnable;

  CourseRegisterClass({
    this.idToHoc,
    this.idMon,
    this.maMon,
    this.tenMon,
    this.tenMonEg,
    this.soTc,
    this.soTcSo,
    this.nhomTo,
    this.lop,
    this.slDk,
    this.slCp,
    this.slCl,
    this.tkb,
    this.enable,
    this.isDk,
    this.gcEnable,
  });

  factory CourseRegisterClass.fromJson(Map<String, dynamic> json) {
    return CourseRegisterClass(
      idToHoc: json['id_to_hoc'],
      idMon: json['id_mon'],

      maMon: json['ma_mon'],
      tenMon: json['ten_mon'],
      tenMonEg: json['ten_mon_eg'],

      soTc: json['so_tc'],
      soTcSo: (json['so_tc_so'] as num?)?.toDouble(),

      nhomTo: json['nhom_to'],
      lop: json['lop'],

      slDk: json['sl_dk'],
      slCp: json['sl_cp'],
      slCl: json['sl_cl'],

      tkb: json['tkb'],

      enable: json['enable'],
      isDk: json['is_dk'],

      gcEnable: json['gc_enable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_to_hoc': idToHoc,
      'id_mon': idMon,

      'ma_mon': maMon,
      'ten_mon': tenMon,
      'ten_mon_eg': tenMonEg,

      'so_tc': soTc,
      'so_tc_so': soTcSo,

      'nhom_to': nhomTo,
      'lop': lop,

      'sl_dk': slDk,
      'sl_cp': slCp,
      'sl_cl': slCl,

      'tkb': tkb,

      'enable': enable,
      'is_dk': isDk,

      'gc_enable': gcEnable,
    };
  }
}