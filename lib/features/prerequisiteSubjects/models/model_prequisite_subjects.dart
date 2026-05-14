class PrerequisiteResponse {
  final PrerequisiteData? data;
  final bool? result;
  final int? code;

  PrerequisiteResponse({
    this.data,
    this.result,
    this.code,
  });

  factory PrerequisiteResponse.fromJson(Map<String, dynamic> json) {
    return PrerequisiteResponse(
      data: json['data'] != null
          ? PrerequisiteData.fromJson(json['data'])
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

class PrerequisiteData {
  final int? totalItems;
  final int? totalPages;
  final List<PrerequisiteSubject>? dsMonTienQuyet;

  PrerequisiteData({
    this.totalItems,
    this.totalPages,
    this.dsMonTienQuyet,
  });

  factory PrerequisiteData.fromJson(Map<String, dynamic> json) {
    return PrerequisiteData(
      totalItems: json['total_items'],
      totalPages: json['total_pages'],
      dsMonTienQuyet: (json['ds_mon_tien_quyet'] as List<dynamic>?)
          ?.map((e) => PrerequisiteSubject.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_items': totalItems,
      'total_pages': totalPages,
      'ds_mon_tien_quyet':
          dsMonTienQuyet?.map((e) => e.toJson()).toList(),
    };
  }
}

class PrerequisiteSubject {
  final String? maMonDangKy;
  final String? tenMonDangKy;
  final String? tenMonDangKyEg;
  final String? maMonYeuCau;
  final String? tenMonYeuCau;
  final String? tenMonYeuCauEg;
  final String? khoi;
  final String? heDaoTao;

  PrerequisiteSubject({
    this.maMonDangKy,
    this.tenMonDangKy,
    this.tenMonDangKyEg,
    this.maMonYeuCau,
    this.tenMonYeuCau,
    this.tenMonYeuCauEg,
    this.khoi,
    this.heDaoTao,
  });

  factory PrerequisiteSubject.fromJson(Map<String, dynamic> json) {
    return PrerequisiteSubject(
      maMonDangKy: json['ma_mon_dang_ky'],
      tenMonDangKy: json['ten_mon_dang_ky'],
      tenMonDangKyEg: json['ten_mon_dang_ky_eg'],
      maMonYeuCau: json['ma_mon_yeu_cau'],
      tenMonYeuCau: json['ten_mon_yeu_cau'],
      tenMonYeuCauEg: json['ten_mon_yeu_cau_eg'],
      khoi: json['khoi'],
      heDaoTao: json['he_dao_tao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ma_mon_dang_ky': maMonDangKy,
      'ten_mon_dang_ky': tenMonDangKy,
      'ten_mon_dang_ky_eg': tenMonDangKyEg,
      'ma_mon_yeu_cau': maMonYeuCau,
      'ten_mon_yeu_cau': tenMonYeuCau,
      'ten_mon_yeu_cau_eg': tenMonYeuCauEg,
      'khoi': khoi,
      'he_dao_tao': heDaoTao,
    };
  }
}