class InforStudentFillResponse {
  final InforStudentFillData data;
  final bool result;
  final int code;

  InforStudentFillResponse({
    required this.data,
    required this.result,
    required this.code,
  });

  factory InforStudentFillResponse.fromJson(Map<String, dynamic> json) {
    return InforStudentFillResponse(
      data: InforStudentFillData.fromJson(json['data']),
      result: json['result'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
      'result': result,
      'code': code,
    };
  }
}

class InforStudentFillData {
  final String name;
  final String maSv;
  final String ngaySinh;
  final String gioiTinh;
  final String lop;
  final String khoa;
  final String heDaoTao;
  final String nganh;
  final String nienKhoa;
  final String trangThai;

  InforStudentFillData({
    required this.name,
    required this.maSv,
    required this.ngaySinh,
    required this.gioiTinh,
    required this.lop,
    required this.khoa,
    required this.heDaoTao,
    required this.nganh,
    required this.nienKhoa,
    required this.trangThai,
  });

  factory InforStudentFillData.fromJson(Map<String, dynamic> json) {
    return InforStudentFillData(
      name: json['name'],
      maSv: json['ma_sv'],
      ngaySinh: json['ngay_sinh'],
      gioiTinh: json['gioi_tinh'],
      lop: json['lop'],
      khoa: json['khoa'],
      heDaoTao: json['he_dao_tao'],
      nganh: json['nganh'],
      nienKhoa: json['nien_khoa'],
      trangThai: json['trang_thai'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ma_sv': maSv,
      'ngay_sinh': ngaySinh,
      'gioi_tinh': gioiTinh,
      'lop': lop,
      'khoa': khoa,
      'he_dao_tao': heDaoTao,
      'nganh': nganh,
      'nien_khoa': nienKhoa,
      'trang_thai': trangThai,
    };
  }
}