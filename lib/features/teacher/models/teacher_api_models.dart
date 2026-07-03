String _parseString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return '';
  return value.toString();
}

bool _parseBool(
  Map<String, dynamic> json,
  String key, {
  bool defaultValue = false,
}) {
  final value = json[key];
  if (value is bool) return value;
  if (value is String) return value.toLowerCase() == 'true';
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

Map<String, dynamic> _parseMapOrEmpty(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}

class TeacherProfileResponse {
  final TeacherProfileData data;
  final bool result;
  final int code;

  const TeacherProfileResponse({
    required this.data,
    required this.result,
    required this.code,
  });

  factory TeacherProfileResponse.fromJson(Map<String, dynamic> json) {
    return TeacherProfileResponse(
      data: TeacherProfileData.fromJson(_parseMapOrEmpty(json, 'data')),
      result: json.containsKey('result') ? _parseBool(json, 'result') : true,
      code: json.containsKey('code') ? _parseInt(json, 'code') : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data.toJson(), 'result': result, 'code': code};
  }
}

class TeacherProfileData {
  final String idGiangVien;
  final String maGiangVien;
  final String tenGiangVien;
  final bool isDanhDau;
  final String ngaySinh;
  final String email1;
  final String email2;
  final String dienThoai1;
  final String dienThoai2;
  final String hocHam;
  final String hocVi;
  final String khoa;
  final String khoaEg;
  final String idKhoa;
  final String boMon;
  final String phanLoai;
  final String phanLoaiEg;
  final String trangThaiLamViec;
  final String soQuyetDinhVao;
  final String ngayQuyetDinhVao;
  final bool isChonCtHoc;
  final bool doiMatKhau;
  final String idFormDanhGia;
  final String idDsDoiTuong;
  final bool isTraLoi;
  final String gioiTinh;
  final String queQuan;
  final String diaChi;
  final String danToc;
  final String tonGiao;
  final String quocTich;
  final String namVaoDoan;
  final String ngayBatDauGiangDay;
  final String trinhDoHocVan;
  final String danhHieuNhaGiao;
  final String bienChe;

  const TeacherProfileData({
    required this.idGiangVien,
    required this.maGiangVien,
    required this.tenGiangVien,
    required this.isDanhDau,
    required this.ngaySinh,
    required this.email1,
    required this.email2,
    required this.dienThoai1,
    required this.dienThoai2,
    required this.hocHam,
    required this.hocVi,
    required this.khoa,
    required this.khoaEg,
    required this.idKhoa,
    required this.boMon,
    required this.phanLoai,
    required this.phanLoaiEg,
    required this.trangThaiLamViec,
    required this.soQuyetDinhVao,
    required this.ngayQuyetDinhVao,
    required this.isChonCtHoc,
    required this.doiMatKhau,
    required this.idFormDanhGia,
    required this.idDsDoiTuong,
    required this.isTraLoi,
    required this.gioiTinh,
    required this.queQuan,
    required this.diaChi,
    required this.danToc,
    required this.tonGiao,
    required this.quocTich,
    required this.namVaoDoan,
    required this.ngayBatDauGiangDay,
    required this.trinhDoHocVan,
    required this.danhHieuNhaGiao,
    required this.bienChe,
  });

  factory TeacherProfileData.fromJson(Map<String, dynamic> json) {
    return TeacherProfileData(
      idGiangVien: _parseString(json, 'id_giang_vien'),
      maGiangVien: _parseString(json, 'ma_giang_vien'),
      tenGiangVien: _parseString(json, 'ten_giang_vien'),
      isDanhDau: _parseBool(json, 'is_danh_dau'),
      ngaySinh: _parseString(json, 'ngay_sinh'),
      email1: _parseString(json, 'email_1'),
      email2: _parseString(json, 'email_2'),
      dienThoai1: _parseString(json, 'dien_thoai_1'),
      dienThoai2: _parseString(json, 'dien_thoai_2'),
      hocHam: _parseString(json, 'hoc_ham'),
      hocVi: _parseString(json, 'hoc_vi'),
      khoa: _parseString(json, 'khoa'),
      khoaEg: _parseString(json, 'khoa_eg'),
      idKhoa: _parseString(json, 'id_khoa'),
      boMon: _parseString(json, 'bo_mon'),
      phanLoai: _parseString(json, 'phan_loai'),
      phanLoaiEg: _parseString(json, 'phan_loai_eg'),
      trangThaiLamViec: _parseString(json, 'trang_thai_lam_viec'),
      soQuyetDinhVao: _parseString(json, 'so_quyet_dinh_vao'),
      ngayQuyetDinhVao: _parseString(json, 'ngay_quyet_dinh_vao'),
      isChonCtHoc: _parseBool(json, 'is_chon_ct_hoc'),
      doiMatKhau: _parseBool(json, 'doi_mat_khau'),
      idFormDanhGia: _parseString(json, 'id_form_danh_gia'),
      idDsDoiTuong: _parseString(json, 'id_ds_doi_tuong'),
      isTraLoi: _parseBool(json, 'is_tra_loi'),
      gioiTinh: _parseString(json, 'gioi_tinh'),
      queQuan: _parseString(json, 'que_quan'),
      diaChi: _parseString(json, 'dia_chi'),
      danToc: _parseString(json, 'dan_toc'),
      tonGiao: _parseString(json, 'ton_giao'),
      quocTich: _parseString(json, 'quoc_tich'),
      namVaoDoan: _parseString(json, 'nam_vao_doan'),
      ngayBatDauGiangDay: _parseString(json, 'ngay_bat_dau_giang_day'),
      trinhDoHocVan: _parseString(json, 'trinh_do_hoc_van'),
      danhHieuNhaGiao: _parseString(json, 'danh_hieu_nha_giao'),
      bienChe: _parseString(json, 'bien_che'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_giang_vien': idGiangVien,
      'ma_giang_vien': maGiangVien,
      'ten_giang_vien': tenGiangVien,
      'is_danh_dau': isDanhDau,
      'ngay_sinh': ngaySinh,
      'email_1': email1,
      'email_2': email2,
      'dien_thoai_1': dienThoai1,
      'dien_thoai_2': dienThoai2,
      'hoc_ham': hocHam,
      'hoc_vi': hocVi,
      'khoa': khoa,
      'khoa_eg': khoaEg,
      'id_khoa': idKhoa,
      'bo_mon': boMon,
      'phan_loai': phanLoai,
      'phan_loai_eg': phanLoaiEg,
      'trang_thai_lam_viec': trangThaiLamViec,
      'so_quyet_dinh_vao': soQuyetDinhVao,
      'ngay_quyet_dinh_vao': ngayQuyetDinhVao,
      'is_chon_ct_hoc': isChonCtHoc,
      'doi_mat_khau': doiMatKhau,
      'id_form_danh_gia': idFormDanhGia,
      'id_ds_doi_tuong': idDsDoiTuong,
      'is_tra_loi': isTraLoi,
      'gioi_tinh': gioiTinh,
      'que_quan': queQuan,
      'dia_chi': diaChi,
      'dan_toc': danToc,
      'ton_giao': tonGiao,
      'quoc_tich': quocTich,
      'nam_vao_doan': namVaoDoan,
      'ngay_bat_dau_giang_day': ngayBatDauGiangDay,
      'trinh_do_hoc_van': trinhDoHocVan,
      'danh_hieu_nha_giao': danhHieuNhaGiao,
      'bien_che': bienChe,
    };
  }
}

class TeacherFunctionResponse {
  final TeacherFunctionData data;
  final bool result;
  final int code;

  const TeacherFunctionResponse({
    required this.data,
    required this.result,
    required this.code,
  });

  factory TeacherFunctionResponse.fromJson(Map<String, dynamic> json) {
    return TeacherFunctionResponse(
      data: TeacherFunctionData.fromJson(_parseMapOrEmpty(json, 'data')),
      result: json.containsKey('result') ? _parseBool(json, 'result') : true,
      code: json.containsKey('code') ? _parseInt(json, 'code') : 0,
    );
  }
}

class TeacherFunctionData {
  final int totalItems;
  final int totalPages;
  final String releaseTime;
  final bool isPhanCapChucNangMobile;
  final List<TeacherFunctionItem> dsChucNang;
  final List<dynamic> dsChucNangHtld;

  const TeacherFunctionData({
    required this.totalItems,
    required this.totalPages,
    required this.releaseTime,
    required this.isPhanCapChucNangMobile,
    required this.dsChucNang,
    required this.dsChucNangHtld,
  });

  factory TeacherFunctionData.fromJson(Map<String, dynamic> json) {
    return TeacherFunctionData(
      totalItems: _parseInt(json, 'total_items'),
      totalPages: _parseInt(json, 'total_pages'),
      releaseTime: _parseString(json, 'release_time'),
      isPhanCapChucNangMobile: _parseBool(json, 'is_phan_cap_chuc_nang_mobile'),
      dsChucNang: _parseList(json, 'ds_chuc_nang')
          .whereType<Map>()
          .map(
            (item) =>
                TeacherFunctionItem.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(),
      dsChucNangHtld: _parseList(json, 'ds_chuc_nang_htld'),
    );
  }
}

class TeacherFunctionItem {
  final String id;
  final bool state;
  final String maChucNang;
  final String maMenu;
  final int thuTu;
  final String tenHienThi;
  final TeacherFunctionMobileTitle tenMobile;
  final String tenHienThiEg;
  final String tenTooltip;
  final String url;
  final String urlDanhMucHocLieu;
  final String urlELearning;
  final String urlCongDgrl;
  final List<dynamic> dsChiTiet;

  const TeacherFunctionItem({
    required this.id,
    required this.state,
    required this.maChucNang,
    required this.maMenu,
    required this.thuTu,
    required this.tenHienThi,
    required this.tenMobile,
    required this.tenHienThiEg,
    required this.tenTooltip,
    required this.url,
    required this.urlDanhMucHocLieu,
    required this.urlELearning,
    required this.urlCongDgrl,
    required this.dsChiTiet,
  });

  factory TeacherFunctionItem.fromJson(Map<String, dynamic> json) {
    return TeacherFunctionItem(
      id: _parseString(json, 'id'),
      state: _parseBool(json, 'state'),
      maChucNang: _parseString(json, 'ma_chuc_nang'),
      maMenu: _parseString(json, 'ma_menu'),
      thuTu: _parseInt(json, 'thu_tu'),
      tenHienThi: _parseString(json, 'ten_hien_thi'),
      tenMobile: TeacherFunctionMobileTitle.fromJson(
        _parseMapOrEmpty(json, 'ten_mobile'),
      ),
      tenHienThiEg: _parseString(json, 'ten_hien_thi_Eg'),
      tenTooltip: _parseString(json, 'ten_tooltip'),
      url: _parseString(json, 'url'),
      urlDanhMucHocLieu: _parseString(json, 'url_danh_muc_hoc_lieu'),
      urlELearning: _parseString(json, 'url_e_learning'),
      urlCongDgrl: _parseString(json, 'url_cong_dgrl'),
      dsChiTiet: _parseList(json, 'ds_chi_tiet'),
    );
  }
}

class TeacherFunctionMobileTitle {
  final String nhom;
  final String tenViet;
  final String tenEng;
  final String maNhomCha;

  const TeacherFunctionMobileTitle({
    required this.nhom,
    required this.tenViet,
    required this.tenEng,
    required this.maNhomCha,
  });

  factory TeacherFunctionMobileTitle.fromJson(Map<String, dynamic> json) {
    return TeacherFunctionMobileTitle(
      nhom: _parseString(json, 'nhom'),
      tenViet: _parseString(json, 'ten_viet'),
      tenEng: _parseString(json, 'ten_eng'),
      maNhomCha: _parseString(json, 'ma_nhom_cha'),
    );
  }
}

class TeacherNotificationResponse {
  final TeacherNotificationData data;
  final bool result;
  final int code;

  const TeacherNotificationResponse({
    required this.data,
    required this.result,
    required this.code,
  });

  factory TeacherNotificationResponse.fromJson(Map<String, dynamic> json) {
    return TeacherNotificationResponse(
      data: TeacherNotificationData.fromJson(_parseMapOrEmpty(json, 'data')),
      result: json.containsKey('result') ? _parseBool(json, 'result') : true,
      code: json.containsKey('code') ? _parseInt(json, 'code') : 0,
    );
  }
}

class TeacherNotificationData {
  final int totalItems;
  final int totalPages;
  final int notification;
  final List<TeacherNotificationItem> dsThongBao;

  const TeacherNotificationData({
    required this.totalItems,
    required this.totalPages,
    required this.notification,
    required this.dsThongBao,
  });

  factory TeacherNotificationData.fromJson(Map<String, dynamic> json) {
    return TeacherNotificationData(
      totalItems: _parseInt(json, 'total_items'),
      totalPages: _parseInt(json, 'total_pages'),
      notification: _parseInt(json, 'notification'),
      dsThongBao: _parseList(json, 'ds_thong_bao')
          .whereType<Map>()
          .map(
            (item) => TeacherNotificationItem.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
    );
  }
}

class TeacherNotificationItem {
  final String id;
  final String doiTuongSearch;
  final int doiTuong;
  final String phanCapSearch;
  final int phanCapGiangVien;
  final String tieuDe;
  final String noiDung;
  final bool isPhaiXem;
  final String ngayGui;
  final String nguoiGui;
  final bool isDaDoc;
  final List<dynamic> dsDoiTuong;
  final String phanHoi;
  final bool isXemPhanHoi;
  final String ngayXem;

  const TeacherNotificationItem({
    required this.id,
    required this.doiTuongSearch,
    required this.doiTuong,
    required this.phanCapSearch,
    required this.phanCapGiangVien,
    required this.tieuDe,
    required this.noiDung,
    required this.isPhaiXem,
    required this.ngayGui,
    required this.nguoiGui,
    required this.isDaDoc,
    required this.dsDoiTuong,
    required this.phanHoi,
    required this.isXemPhanHoi,
    required this.ngayXem,
  });

  factory TeacherNotificationItem.fromJson(Map<String, dynamic> json) {
    return TeacherNotificationItem(
      id: _parseString(json, 'id'),
      doiTuongSearch: _parseString(json, 'doi_tuong_search'),
      doiTuong: _parseInt(json, 'doi_tuong'),
      phanCapSearch: _parseString(json, 'phan_cap_search'),
      phanCapGiangVien: _parseInt(json, 'phan_cap_giang_vien'),
      tieuDe: _parseString(json, 'tieu_de'),
      noiDung: _parseString(json, 'noi_dung'),
      isPhaiXem: _parseBool(json, 'is_phai_xem'),
      ngayGui: _parseString(json, 'ngay_gui'),
      nguoiGui: _parseString(json, 'nguoi_gui'),
      isDaDoc: _parseBool(json, 'is_da_doc'),
      dsDoiTuong: _parseList(json, 'ds_doi_tuong'),
      phanHoi: _parseString(json, 'phan_hoi'),
      isXemPhanHoi: _parseBool(json, 'is_xem_phan_hoi'),
      ngayXem: _parseString(json, 'ngay_xem'),
    );
  }
}
