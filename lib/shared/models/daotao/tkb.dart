class ThoiKhoaBieu {
  int? thuKieuSo;
  int? tietBatDau;
  int? soTiet;
  String? maMon;
  String? tenMon;
  String? tenGiangVien;
  String? maPhong;
  String? ngayHoc;

  ThoiKhoaBieu({
    this.thuKieuSo,
    this.tietBatDau,
    this.soTiet,
    this.maMon,
    this.tenMon,
    this.tenGiangVien,
    this.maPhong,
    this.ngayHoc,
  });

  ThoiKhoaBieu.fromJson(Map<String, dynamic> json) {
    thuKieuSo = json['thu_kieu_so'];
    tietBatDau = json['tiet_bat_dau'];
    soTiet = json['so_tiet'];
    maMon = json['ma_mon'];
    tenMon = json['ten_mon'];
    tenGiangVien = json['ten_giang_vien'];
    maPhong = json['ma_phong'];
    ngayHoc = json['ngay_hoc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['thu_kieu_so'] = thuKieuSo;
    data['tiet_bat_dau'] = tietBatDau;
    data['so_tiet'] = soTiet;
    data['ma_mon'] = maMon;
    data['ten_mon'] = tenMon;
    data['ten_giang_vien'] = tenGiangVien;
    data['ma_phong'] = maPhong;
    data['ngay_hoc'] = ngayHoc;

    return data;
  }

  @override
  String toString() {
    return '''
Thu: $thuKieuSo
Tiet bat dau: $tietBatDau
So tiet: $soTiet
Ma mon: $maMon
Ten mon: $tenMon
Giang vien: $tenGiangVien
Phong: $maPhong
Ngay hoc: $ngayHoc
''';
  }
}