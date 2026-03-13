class StudentData {
  final String thoiGianGetData;
  final String maSv;
  final String tenDayDu;
  final String gioiTinh;
  final String ngaySinh;
  final String noiSinh;
  final String danToc;
  final String quocTich;
  final String dienThoai;
  final String email;
  final String soCmnd;
  final String lop;
  final String nganh;
  final String khoa;
  final String nienKhoa;
  final String tenTruong;
  final String hienDienSv;

  StudentData({
    required this.thoiGianGetData,
    required this.maSv,
    required this.tenDayDu,
    required this.gioiTinh,
    required this.ngaySinh,
    required this.noiSinh,
    required this.danToc,
    required this.quocTich,
    required this.dienThoai,
    required this.email,
    required this.soCmnd,
    required this.lop,
    required this.nganh,
    required this.khoa,
    required this.nienKhoa,
    required this.tenTruong,
    required this.hienDienSv,
  });

  factory StudentData.fromJson(Map<String, dynamic> json) {
    return StudentData(
      thoiGianGetData: json['thoi_gian_get_data'] ?? "",
      maSv: json['ma_sv'] ?? "",
      tenDayDu: json['ten_day_du'] ?? "",
      gioiTinh: json['gioi_tinh'] ?? "",
      ngaySinh: json['ngay_sinh'] ?? "",
      noiSinh: json['noi_sinh'] ?? "",
      danToc: json['dan_toc'] ?? "",
      quocTich: json['quoc_tich'] ?? "",
      dienThoai: json['dien_thoai'] ?? "",
      email: json['email'] ?? "",
      soCmnd: json['so_cmnd'] ?? "",
      lop: json['lop'] ?? "",
      nganh: json['nganh'] ?? "",
      khoa: json['khoa'] ?? "",
      nienKhoa: json['nien_khoa'] ?? "",
      tenTruong: json['ten_truong'] ?? "",
      hienDienSv: json['hien_dien_sv'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "thoi_gian_get_data": thoiGianGetData,
      "ma_sv": maSv,
      "ten_day_du": tenDayDu,
      "gioi_tinh": gioiTinh,
      "ngay_sinh": ngaySinh,
      "noi_sinh": noiSinh,
      "dan_toc": danToc,
      "quoc_tich": quocTich,
      "dien_thoai": dienThoai,
      "email": email,
      "so_cmnd": soCmnd,
      "lop": lop,
      "nganh": nganh,
      "khoa": khoa,
      "nien_khoa": nienKhoa,
      "ten_truong": tenTruong,
      "hien_dien_sv": hienDienSv,
    };
  }
}