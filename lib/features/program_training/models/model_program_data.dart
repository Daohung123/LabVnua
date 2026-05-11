class ProgramTrainingResponse {
  final ProgramTrainingData? data;

  ProgramTrainingResponse({this.data});

  factory ProgramTrainingResponse.fromJson(Map<String, dynamic> json) {
    return ProgramTrainingResponse(
      data: json['data'] != null
          ? ProgramTrainingData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data?.toJson()};
  }
}

class ProgramTrainingData {
  final int? totalItems;
  final int? totalPages;

  final bool? isXemTaiLieu;
  final bool? isShowNhomtc;
  final bool? isViewSodo;

  final List<ProgramTrainingMajor>? dsNganhSinhVien;
  final List<dynamic>? dsChuyenNganhSv;

  final List<ProgramTrainingSemester>? dsCtdtHocky;

  ProgramTrainingData({
    this.totalItems,
    this.totalPages,
    this.isXemTaiLieu,
    this.isShowNhomtc,
    this.isViewSodo,
    this.dsNganhSinhVien,
    this.dsChuyenNganhSv,
    this.dsCtdtHocky,
  });

  factory ProgramTrainingData.fromJson(Map<String, dynamic> json) {
    return ProgramTrainingData(
      totalItems: json['total_items'],
      totalPages: json['total_pages'],

      isXemTaiLieu: json['is_xem_tai_lieu'],
      isShowNhomtc: json['is_show_nhomtc'],
      isViewSodo: json['is_view_sodo'],

      dsNganhSinhVien: (json['ds_nganh_sinh_vien'] as List<dynamic>?)
          ?.map((e) => ProgramTrainingMajor.fromJson(e))
          .toList(),

      dsChuyenNganhSv: json['ds_chuyen_nganh_sv'],

      dsCtdtHocky: (json['ds_CTDT_hocky'] as List<dynamic>?)
          ?.map((e) => ProgramTrainingSemester.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_items': totalItems,
      'total_pages': totalPages,

      'is_xem_tai_lieu': isXemTaiLieu,
      'is_show_nhomtc': isShowNhomtc,
      'is_view_sodo': isViewSodo,

      'ds_nganh_sinh_vien': dsNganhSinhVien?.map((e) => e.toJson()).toList(),

      'ds_chuyen_nganh_sv': dsChuyenNganhSv,

      'ds_CTDT_hocky': dsCtdtHocky?.map((e) => e.toJson()).toList(),
    };
  }
}

class ProgramTrainingMajor {
  final int? loaiNganh;

  final String? maNganh;
  final String? tenNganh;

  ProgramTrainingMajor({this.loaiNganh, this.maNganh, this.tenNganh});

  factory ProgramTrainingMajor.fromJson(Map<String, dynamic> json) {
    return ProgramTrainingMajor(
      loaiNganh: json['loai_nganh'],
      maNganh: json['ma_nganh'],
      tenNganh: json['ten_nganh'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loai_nganh': loaiNganh,
      'ma_nganh': maNganh,
      'ten_nganh': tenNganh,
    };
  }
}

class ProgramTrainingSemester {
  final String? hocKy;
  final String? tenHocKy;

  final List<ProgramTrainingSubject>? dsCtdtMonHoc;

  ProgramTrainingSemester({this.hocKy, this.tenHocKy, this.dsCtdtMonHoc});

  factory ProgramTrainingSemester.fromJson(Map<String, dynamic> json) {
    return ProgramTrainingSemester(
      hocKy: json['hoc_ky'],
      tenHocKy: json['ten_hoc_ky'],

      dsCtdtMonHoc: (json['ds_CTDT_mon_hoc'] as List<dynamic>?)
          ?.map((e) => ProgramTrainingSubject.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hoc_ky': hocKy,
      'ten_hoc_ky': tenHocKy,

      'ds_CTDT_mon_hoc': dsCtdtMonHoc?.map((e) => e.toJson()).toList(),
    };
  }
}

class ProgramTrainingSubject {
  final String? maMon;

  final String? tenMon;
  final String? tenMonEg;

  final String? soTinChi;

  final String? lyThuyet;
  final String? thucHanh;
  final String? tongTiet;

  final String? monBatBuoc;
  final String? monDaHoc;
  final String? monDaDat;

  final List<ProgramTrainingComponent>? dsTietThanhPhan;

  ProgramTrainingSubject({
    this.maMon,
    this.tenMon,
    this.tenMonEg,
    this.soTinChi,
    this.lyThuyet,
    this.thucHanh,
    this.tongTiet,
    this.monBatBuoc,
    this.monDaHoc,
    this.monDaDat,
    this.dsTietThanhPhan,
  });

  factory ProgramTrainingSubject.fromJson(Map<String, dynamic> json) {
    return ProgramTrainingSubject(
      maMon: json['ma_mon'],

      tenMon: json['ten_mon'],
      tenMonEg: json['ten_mon_eg'],

      soTinChi: json['so_tin_chi'],

      lyThuyet: json['ly_thuyet'],
      thucHanh: json['thuc_hanh'],
      tongTiet: json['tong_tiet'],

      monBatBuoc: json['mon_bat_buoc'],

      monDaHoc: json['mon_da_hoc'],
      monDaDat: json['mon_da_dat'],

      dsTietThanhPhan: (json['ds_tiet_thanh_phan'] as List<dynamic>?)
          ?.map((e) => ProgramTrainingComponent.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ma_mon': maMon,

      'ten_mon': tenMon,
      'ten_mon_eg': tenMonEg,

      'so_tin_chi': soTinChi,

      'ly_thuyet': lyThuyet,
      'thuc_hanh': thucHanh,
      'tong_tiet': tongTiet,

      'mon_bat_buoc': monBatBuoc,

      'mon_da_hoc': monDaHoc,
      'mon_da_dat': monDaDat,

      'ds_tiet_thanh_phan': dsTietThanhPhan?.map((e) => e.toJson()).toList(),
    };
  }
}

class ProgramTrainingComponent {
  final String? tenThanhPhan;
  final String? soTiet;

  ProgramTrainingComponent({this.tenThanhPhan, this.soTiet});

  factory ProgramTrainingComponent.fromJson(Map<String, dynamic> json) {
    return ProgramTrainingComponent(
      tenThanhPhan: json['ten_thanh_phan'],

      soTiet: json['so_tiet'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'ten_thanh_phan': tenThanhPhan, 'so_tiet': soTiet};
  }
}
