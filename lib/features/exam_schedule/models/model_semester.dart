class SemesterResponse {
  final SemesterData data;
  final bool result;
  final int code;

  SemesterResponse({required this.data, required this.result, required this.code});

  factory SemesterResponse.fromJson(Map<String, dynamic> json) {
    return SemesterResponse(
      data: SemesterData.fromJson(json['data'] ?? {}),
      result: json['result'] ?? true,
      code: json['code'] ?? 0,
    );
  }
}

class SemesterData {
  final List<SemesterModel> dsHocKy;
  SemesterData({required this.dsHocKy});

  factory SemesterData.fromJson(Map<String, dynamic> json) {
    return SemesterData(
      dsHocKy: (json['ds_hoc_ky'] as List?)
              ?.map((e) => SemesterModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class SemesterModel {
  final int hocKy;
  final String tenHocKy;

  SemesterModel({required this.hocKy, required this.tenHocKy});

  factory SemesterModel.fromJson(Map<String, dynamic> json) => 
      SemesterModel(
        hocKy: json['hoc_ky'], 
        tenHocKy: json['ten_hoc_ky'] ?? ''
      );
}
