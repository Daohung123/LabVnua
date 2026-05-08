String _parseString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return '';
  return value.toString();
}

bool _parseBool(Map<String, dynamic> json, String key, {bool defaultValue = false}) {
  final value = json[key];
  if (value is bool) return value;
  if (value is String) {
    return value.toLowerCase() == 'true';
  }
  if (value is num) return value != 0;
  return defaultValue;
}

int _parseInt(Map<String, dynamic> json, String key, {int defaultValue = 0}) {
  final value = json[key];
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? defaultValue;
  return defaultValue;
}

List<dynamic> _parseList(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is List) return value;
  return [];
}

Map<String, dynamic>? _parseMap(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is Map<String, dynamic>) return value;
  return null;
}

class StudentResponse {
  final StudentData data;
  final bool result;
  final int code;

  StudentResponse({
    required this.data,
    required this.result,
    required this.code,
  });

  factory StudentResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = _parseMap(json, 'data');
    if (dataJson == null) {
      throw FormatException('StudentResponse.data must be a JSON object');
    }

    return StudentResponse(
      data: StudentData.fromJson(dataJson),
      result: json.containsKey('result') ? _parseBool(json, 'result') : true,
      code: json.containsKey('code') ? _parseInt(json, 'code') : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data.toJson(), 'result': result, 'code': code};
  }
}

class StudentData {
  final String thoiGianGetData;
  final String maSv; //enable
  final String tenDayDu; //enable
  final String tenDayDuEg; 
  final String gioiTinh;
  final String gioiTinhEg;
  final String ngaySinh;
  final String noiSinh;
  final String noiSinhEg;
  final String danToc;
  final String danTocEg;
  final String tonGiao;
  final String tonGiaoEg;
  final String quocTich;
  final String quocTichEg;
  final String dienThoai;
  final String email;
  final String dienThoai2;
  final String email2;
  final bool doiMatKhau;
  final String soCmnd;
  final String ngayCapCmnd;
  final String noiCapCmnd;
  final String hoKhauThuongTruGd;
  final String hoKhauThuongTruGdEg;
  final String hoKhauQuanHuyen;
  final String hoKhauTinhThanh;
  final String soTk;
  final String lop;
  final String khuVuc;
  final String doiTuongUuTien;
  final String doiTuongXetTn;
  final String khoi;
  final String idNganh;
  final String nganh;
  final String nganheg;
  final String chuyenNganh;
  final String chuyenNganhEg;
  final String idChuyenNganh;
  final String khoa;
  final String khoaEg;
  final String bacHeDaoTao;
  final String bacHeDaoTaoEg;
  final String nienKhoa;
  final String maCvht;
  final String hoTenCvht;
  final String hoTenCvhtEg;
  final String emailCvht;
  final String dienThoaiCvht;
  final String maCvhtNg2;
  final String hoTenCvhtNg2;
  final String hoTenCvhtNg2Eg;
  final String emailCvhtNg2;
  final String dienThoaiCvhtNg2;
  final String maTruong;
  final String tenTruong;
  final String idDiaPhuong;
  final String idKhoa;
  final String idSinhVien;
  final String idLop;
  final String idKhoi;
  final String idBacHeNganh;
  final String idBacHe;
  final String idHe;
  final String idQuyChe;
  final String idQuyCheP;
  final String idHocChe;
  final String idDonViPhanCap;
  final String idCoSoLop;
  final int nhhkVao;
  final int nhhkRa;
  final String strNhhkVao;
  final String strNhhkRa;
  final String idLop2;
  final String idKhoi2;
  final String idKhoa2;
  final String idBacHeNganh2;
  final String idBacHe2;
  final String idHe2;
  final String idQuyChe2;
  final String idQuyCheP2;
  final String idHocChe2;
  final String chuyenNganh2Eg;
  final String strNhhkVao2;
  final String strNhhkRa2;
  final bool isMasterPass;
  final bool isCvhtDangNhap;
  final bool isPhuHuynhDangNhap;
  final int intHienDienSv;
  final String hienDienSv;
  final String hienDienSvEg;
  final String hienDienSvNg2;
  final int intHienDienDkmh;
  final int soHkMaxSv;
  final List<dynamic> dsMenuCamXem;
  final String strHoanThanhDgrl;
  final String urlNetweb;
  final String canhCaoTool;
  final String strCanhCao;
  final String ghiChu;
  final bool isNhapDiaChiMoi;
  final String loTrinhTiengAnh;
  final String nhhkCuoi;
  final String soQdVaoMoi;
  final String ngayQdVaoMoi;
  final String soQdTotNghiep;
  final String ngayQdTotNghiep;
  final bool isXacNhanEmail;

  StudentData({
    required this.thoiGianGetData,
    required this.maSv,
    required this.tenDayDu,
    required this.tenDayDuEg,
    required this.gioiTinh,
    required this.gioiTinhEg,
    required this.ngaySinh,
    required this.noiSinh,
    required this.noiSinhEg,
    required this.danToc,
    required this.danTocEg,
    required this.tonGiao,
    required this.tonGiaoEg,
    required this.quocTich,
    required this.quocTichEg,
    required this.dienThoai,
    required this.email,
    required this.dienThoai2,
    required this.email2,
    required this.doiMatKhau,
    required this.soCmnd,
    required this.ngayCapCmnd,
    required this.noiCapCmnd,
    required this.hoKhauThuongTruGd,
    required this.hoKhauThuongTruGdEg,
    required this.hoKhauQuanHuyen,
    required this.hoKhauTinhThanh,
    required this.soTk,
    required this.lop,
    required this.khuVuc,
    required this.doiTuongUuTien,
    required this.doiTuongXetTn,
    required this.khoi,
    required this.idNganh,
    required this.nganh,
    required this.nganheg,
    required this.chuyenNganh,
    required this.chuyenNganhEg,
    required this.idChuyenNganh,
    required this.khoa,
    required this.khoaEg,
    required this.bacHeDaoTao,
    required this.bacHeDaoTaoEg,
    required this.nienKhoa,
    required this.maCvht,
    required this.hoTenCvht,
    required this.hoTenCvhtEg,
    required this.emailCvht,
    required this.dienThoaiCvht,
    required this.maCvhtNg2,
    required this.hoTenCvhtNg2,
    required this.hoTenCvhtNg2Eg,
    required this.emailCvhtNg2,
    required this.dienThoaiCvhtNg2,
    required this.maTruong,
    required this.tenTruong,
    required this.idDiaPhuong,
    required this.idKhoa,
    required this.idSinhVien,
    required this.idLop,
    required this.idKhoi,
    required this.idBacHeNganh,
    required this.idBacHe,
    required this.idHe,
    required this.idQuyChe,
    required this.idQuyCheP,
    required this.idHocChe,
    required this.idDonViPhanCap,
    required this.idCoSoLop,
    required this.nhhkVao,
    required this.nhhkRa,
    required this.strNhhkVao,
    required this.strNhhkRa,
    required this.idLop2,
    required this.idKhoi2,
    required this.idKhoa2,
    required this.idBacHeNganh2,
    required this.idBacHe2,
    required this.idHe2,
    required this.idQuyChe2,
    required this.idQuyCheP2,
    required this.idHocChe2,
    required this.chuyenNganh2Eg,
    required this.strNhhkVao2,
    required this.strNhhkRa2,
    required this.isMasterPass,
    required this.isCvhtDangNhap,
    required this.isPhuHuynhDangNhap,
    required this.intHienDienSv,
    required this.hienDienSv,
    required this.hienDienSvEg,
    required this.hienDienSvNg2,
    required this.intHienDienDkmh,
    required this.soHkMaxSv,
    required this.dsMenuCamXem,
    required this.strHoanThanhDgrl,
    required this.urlNetweb,
    required this.canhCaoTool,
    required this.strCanhCao,
    required this.ghiChu,
    required this.isNhapDiaChiMoi,
    required this.loTrinhTiengAnh,
    required this.nhhkCuoi,
    required this.soQdVaoMoi,
    required this.ngayQdVaoMoi,
    required this.soQdTotNghiep,
    required this.ngayQdTotNghiep,
    required this.isXacNhanEmail,
  });

  factory StudentData.fromJson(Map<String, dynamic> json) {
    return StudentData(
      thoiGianGetData: _parseString(json, 'thoi_gian_get_data'),
      maSv: _parseString(json, 'ma_sv'),
      tenDayDu: _parseString(json, 'ten_day_du'),
      tenDayDuEg: _parseString(json, 'ten_day_du_eg'),
      gioiTinh: _parseString(json, 'gioi_tinh'),
      gioiTinhEg: _parseString(json, 'gioi_tinh_eg'),
      ngaySinh: _parseString(json, 'ngay_sinh'),
      noiSinh: _parseString(json, 'noi_sinh'),
      noiSinhEg: _parseString(json, 'noi_sinh_eg'),
      danToc: _parseString(json, 'dan_toc'),
      danTocEg: _parseString(json, 'dan_toc_eg'),
      tonGiao: _parseString(json, 'ton_giao'),
      tonGiaoEg: _parseString(json, 'ton_giao_eg'),
      quocTich: _parseString(json, 'quoc_tich'),
      quocTichEg: _parseString(json, 'quoc_tich_eg'),
      dienThoai: _parseString(json, 'dien_thoai'),
      email: _parseString(json, 'email'),
      dienThoai2: _parseString(json, 'dien_thoai2'),
      email2: _parseString(json, 'email2'),
      doiMatKhau: _parseBool(json, 'doi_mat_khau'),
      soCmnd: _parseString(json, 'so_cmnd'),
      ngayCapCmnd: _parseString(json, 'ngay_cap_cmnd'),
      noiCapCmnd: _parseString(json, 'noi_cap_cmnd'),
      hoKhauThuongTruGd: _parseString(json, 'ho_khau_thuong_tru_gd'),
      hoKhauThuongTruGdEg: _parseString(json, 'ho_khau_thuong_tru_gd_eg'),
      hoKhauQuanHuyen: _parseString(json, 'ho_khau_quan_huyen'),
      hoKhauTinhThanh: _parseString(json, 'ho_khau_tinh_thanh'),
      soTk: _parseString(json, 'so_tk'),
      lop: _parseString(json, 'lop'),
      khuVuc: _parseString(json, 'khu_vuc'),
      doiTuongUuTien: _parseString(json, 'doi_tuong_uu_tien'),
      doiTuongXetTn: _parseString(json, 'doi_tuong_xet_TN'),
      khoi: _parseString(json, 'khoi'),
      idNganh: _parseString(json, 'id_nganh'),
      nganh: _parseString(json, 'nganh'),
      nganheg: _parseString(json, 'nganheg'),
      chuyenNganh: _parseString(json, 'chuyen_nganh'),
      chuyenNganhEg: _parseString(json, 'chuyen_nganh_eg'),
      idChuyenNganh: _parseString(json, 'id_chuyen_nganh'),
      khoa: _parseString(json, 'khoa'),
      khoaEg: _parseString(json, 'khoa_eg'),
      bacHeDaoTao: _parseString(json, 'bac_he_dao_tao'),
      bacHeDaoTaoEg: _parseString(json, 'bac_he_dao_tao_eg'),
      nienKhoa: _parseString(json, 'nien_khoa'),
      maCvht: _parseString(json, 'ma_cvht'),
      hoTenCvht: _parseString(json, 'ho_ten_cvht'),
      hoTenCvhtEg: _parseString(json, 'ho_ten_cvht_eg'),
      emailCvht: _parseString(json, 'email_cvht'),
      dienThoaiCvht: _parseString(json, 'dien_thoai_cvht'),
      maCvhtNg2: _parseString(json, 'ma_cvht_ng2'),
      hoTenCvhtNg2: _parseString(json, 'ho_ten_cvht_ng2'),
      hoTenCvhtNg2Eg: _parseString(json, 'ho_ten_cvht_ng2_eg'),
      emailCvhtNg2: _parseString(json, 'email_cvht_ng2'),
      dienThoaiCvhtNg2: _parseString(json, 'dien_thoai_cvht_ng2'),
      maTruong: _parseString(json, 'ma_truong'),
      tenTruong: _parseString(json, 'ten_truong'),
      idDiaPhuong: _parseString(json, 'id_dia_phuong'),
      idKhoa: _parseString(json, 'id_khoa'),
      idSinhVien: _parseString(json, 'id_sinh_vien'),
      idLop: _parseString(json, 'id_lop'),
      idKhoi: _parseString(json, 'id_khoi'),
      idBacHeNganh: _parseString(json, 'id_bac_he_nganh'),
      idBacHe: _parseString(json, 'id_bac_he'),
      idHe: _parseString(json, 'id_he'),
      idQuyChe: _parseString(json, 'id_quy_che'),
      idQuyCheP: _parseString(json, 'id_quy_che_P'),
      idHocChe: _parseString(json, 'id_hoc_che'),
      idDonViPhanCap: _parseString(json, 'id_don_vi_phan_cap'),
      idCoSoLop: _parseString(json, 'id_co_so_lop'),
      nhhkVao: _parseInt(json, 'nhhk_vao'),
      nhhkRa: _parseInt(json, 'nhhk_ra'),
      strNhhkVao: _parseString(json, 'str_nhhk_vao'),
      strNhhkRa: _parseString(json, 'str_nhhk_ra'),
      idLop2: _parseString(json, 'id_lop2'),
      idKhoi2: _parseString(json, 'id_khoi2'),
      idKhoa2: _parseString(json, 'id_khoa2'),
      idBacHeNganh2: _parseString(json, 'id_bac_he_nganh2'),
      idBacHe2: _parseString(json, 'id_bac_he2'),
      idHe2: _parseString(json, 'id_he2'),
      idQuyChe2: _parseString(json, 'id_quy_che2'),
      idQuyCheP2: _parseString(json, 'id_quy_che_P2'),
      idHocChe2: _parseString(json, 'id_hoc_che2'),
      chuyenNganh2Eg: _parseString(json, 'chuyen_nganh2_eg'),
      strNhhkVao2: _parseString(json, 'str_nhhk_vao2'),
      strNhhkRa2: _parseString(json, 'str_nhhk_ra2'),
      isMasterPass: _parseBool(json, 'is_master_pass'),
      isCvhtDangNhap: _parseBool(json, 'is_cvht_dang_nhap'),
      isPhuHuynhDangNhap: _parseBool(json, 'is_phu_huynh_dang_nhap'),
      intHienDienSv: _parseInt(json, 'int_hien_dien_sv'),
      hienDienSv: _parseString(json, 'hien_dien_sv'),
      hienDienSvEg: _parseString(json, 'hien_dien_sv_eg'),
      hienDienSvNg2: _parseString(json, 'hien_dien_sv_ng2'),
      intHienDienDkmh: _parseInt(json, 'int_hien_dien_dkmh'),
      soHkMaxSv: _parseInt(json, 'so_hk_max_sv'),
      dsMenuCamXem: _parseList(json, 'ds_menu_cam_xem'),
      strHoanThanhDgrl: _parseString(json, 'str_hoan_thanh_dgrl'),
      urlNetweb: _parseString(json, 'url_netweb'),
      canhCaoTool: _parseString(json, 'canh_cao_tool'),
      strCanhCao: _parseString(json, 'str_canh_cao'),
      ghiChu: _parseString(json, 'ghi_chu'),
      isNhapDiaChiMoi: _parseBool(json, 'is_nhap_dia_chi_moi'),
      loTrinhTiengAnh: _parseString(json, 'lo_trinh_tieng_anh'),
      nhhkCuoi: _parseString(json, 'nhhk_cuoi'),
      soQdVaoMoi: _parseString(json, 'so_qd_vao_moi'),
      ngayQdVaoMoi: _parseString(json, 'ngay_qd_vao_moi'),
      soQdTotNghiep: _parseString(json, 'so_qd_tot_nghiep'),
      ngayQdTotNghiep: _parseString(json, 'ngay_qd_tot_nghiep'),
      isXacNhanEmail: _parseBool(json, 'is_xac_nhan_email'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'thoi_gian_get_data': thoiGianGetData,
      'ma_sv': maSv,
      'ten_day_du': tenDayDu,
      'ten_day_du_eg': tenDayDuEg,
      'gioi_tinh': gioiTinh,
      'gioi_tinh_eg': gioiTinhEg,
      'ngay_sinh': ngaySinh,
      'noi_sinh': noiSinh,
      'noi_sinh_eg': noiSinhEg,
      'dan_toc': danToc,
      'dan_toc_eg': danTocEg,
      'ton_giao': tonGiao,
      'ton_giao_eg': tonGiaoEg,
      'quoc_tich': quocTich,
      'quoc_tich_eg': quocTichEg,
      'dien_thoai': dienThoai,
      'email': email,
      'dien_thoai2': dienThoai2,
      'email2': email2,
      'doi_mat_khau': doiMatKhau,
      'so_cmnd': soCmnd,
      'ngay_cap_cmnd': ngayCapCmnd,
      'noi_cap_cmnd': noiCapCmnd,
      'ho_khau_thuong_tru_gd': hoKhauThuongTruGd,
      'ho_khau_thuong_tru_gd_eg': hoKhauThuongTruGdEg,
      'ho_khau_quan_huyen': hoKhauQuanHuyen,
      'ho_khau_tinh_thanh': hoKhauTinhThanh,
      'so_tk': soTk,
      'lop': lop,
      'khu_vuc': khuVuc,
      'doi_tuong_uu_tien': doiTuongUuTien,
      'doi_tuong_xet_TN': doiTuongXetTn,
      'khoi': khoi,
      'id_nganh': idNganh,
      'nganh': nganh,
      'nganheg': nganheg,
      'chuyen_nganh': chuyenNganh,
      'chuyen_nganh_eg': chuyenNganhEg,
      'id_chuyen_nganh': idChuyenNganh,
      'khoa': khoa,
      'khoa_eg': khoaEg,
      'bac_he_dao_tao': bacHeDaoTao,
      'bac_he_dao_tao_eg': bacHeDaoTaoEg,
      'nien_khoa': nienKhoa,
      'ma_cvht': maCvht,
      'ho_ten_cvht': hoTenCvht,
      'ho_ten_cvht_eg': hoTenCvhtEg,
      'email_cvht': emailCvht,
      'dien_thoai_cvht': dienThoaiCvht,
      'ma_cvht_ng2': maCvhtNg2,
      'ho_ten_cvht_ng2': hoTenCvhtNg2,
      'ho_ten_cvht_ng2_eg': hoTenCvhtNg2Eg,
      'email_cvht_ng2': emailCvhtNg2,
      'dien_thoai_cvht_ng2': dienThoaiCvhtNg2,
      'ma_truong': maTruong,
      'ten_truong': tenTruong,
      'id_dia_phuong': idDiaPhuong,
      'id_khoa': idKhoa,
      'id_sinh_vien': idSinhVien,
      'id_lop': idLop,
      'id_khoi': idKhoi,
      'id_bac_he_nganh': idBacHeNganh,
      'id_bac_he': idBacHe,
      'id_he': idHe,
      'id_quy_che': idQuyChe,
      'id_quy_che_P': idQuyCheP,
      'id_hoc_che': idHocChe,
      'id_don_vi_phan_cap': idDonViPhanCap,
      'id_co_so_lop': idCoSoLop,
      'nhhk_vao': nhhkVao,
      'nhhk_ra': nhhkRa,
      'str_nhhk_vao': strNhhkVao,
      'str_nhhk_ra': strNhhkRa,
      'id_lop2': idLop2,
      'id_khoi2': idKhoi2,
      'id_khoa2': idKhoa2,
      'id_bac_he_nganh2': idBacHeNganh2,
      'id_bac_he2': idBacHe2,
      'id_he2': idHe2,
      'id_quy_che2': idQuyChe2,
      'id_quy_che_P2': idQuyCheP2,
      'id_hoc_che2': idHocChe2,
      'chuyen_nganh2_eg': chuyenNganh2Eg,
      'str_nhhk_vao2': strNhhkVao2,
      'str_nhhk_ra2': strNhhkRa2,
      'is_master_pass': isMasterPass,
      'is_cvht_dang_nhap': isCvhtDangNhap,
      'is_phu_huynh_dang_nhap': isPhuHuynhDangNhap,
      'int_hien_dien_sv': intHienDienSv,
      'hien_dien_sv': hienDienSv,
      'hien_dien_sv_eg': hienDienSvEg,
      'hien_dien_sv_ng2': hienDienSvNg2,
      'int_hien_dien_dkmh': intHienDienDkmh,
      'so_hk_max_sv': soHkMaxSv,
      'ds_menu_cam_xem': dsMenuCamXem,
      'str_hoan_thanh_dgrl': strHoanThanhDgrl,
      'url_netweb': urlNetweb,
      'canh_cao_tool': canhCaoTool,
      'str_canh_cao': strCanhCao,
      'ghi_chu': ghiChu,
      'is_nhap_dia_chi_moi': isNhapDiaChiMoi,
      'lo_trinh_tieng_anh': loTrinhTiengAnh,
      'nhhk_cuoi': nhhkCuoi,
      'so_qd_vao_moi': soQdVaoMoi,
      'ngay_qd_vao_moi': ngayQdVaoMoi,
      'so_qd_tot_nghiep': soQdTotNghiep,
      'ngay_qd_tot_nghiep': ngayQdTotNghiep,
      'is_xac_nhan_email': isXacNhanEmail,
    };
  }
}
