import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseConfig {
  static Database? _database;

  /// mở database
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'auth.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // bảng session
        await db.execute('''
        CREATE TABLE session(
          id INTEGER PRIMARY KEY,
          user TEXT,
          pass TEXT,
          cookie TEXT,
          token TEXT,
          active INTEGER
        )
      ''');

        //bảng semester_timetable
        await db.execute('''
        CREATE TABLE semester_timetable(
          id INTEGER PRIMARY KEY AUTOINCREMENT,  
          id_to_hoc TEXT,
          ma_mon TEXT,
          ten_mon TEXT,
          nhom_to TEXT,
          thu INTEGER,
          tbd INTEGER,
          so_tiet INTEGER, 
          tu_gio TEXT,
          den_gio TEXT,
          phong TEXT,
          lop TEXT,
          gv TEXT,
          tooltip TEXT,
        )
      ''');

        // bảng notifications
        await db.execute('''
        CREATE TABLE notifications(
          id TEXT PRIMARY KEY,
          doi_tuong_search TEXT,
          doi_tuong INTEGER,
          phan_cap_search TEXT,
          phan_cap_sinh_vien INTEGER,
          tieu_de TEXT,
          noi_dung TEXT,
          is_phai_xem INTEGER,
          ngay_gui TEXT,
          nguoi_gui TEXT,
          is_da_doc INTEGER,
          ds_doi_tuong TEXT,
          is_xem_phan_hoi INTEGER,
          ngay_xem TEXT
      )
    ''');

        await db.execute('''
        CREATE TABLE student_data(
          ma_sv TEXT PRIMARY KEY,
          thoi_gian_get_data TEXT,
          ten_day_du TEXT,
          ten_day_du_eg TEXT,
          gioi_tinh TEXT,
          gioi_tinh_eg TEXT,
          ngay_sinh TEXT,
          noi_sinh TEXT,
          noi_sinh_eg TEXT,
          dan_toc TEXT,
          dan_toc_eg TEXT,
          ton_giao TEXT,
          ton_giao_eg TEXT,
          quoc_tich TEXT,
          quoc_tich_eg TEXT,
          dien_thoai TEXT,
          email TEXT,
          dien_thoai2 TEXT,
          email2 TEXT,
          doi_mat_khau INTEGER,
          so_cmnd TEXT,
          ngay_cap_cmnd TEXT,
          noi_cap_cmnd TEXT,
          ho_khau_thuong_tru_gd TEXT,
          ho_khau_thuong_tru_gd_eg TEXT,
          ho_khau_quan_huyen TEXT,
          ho_khau_tinh_thanh TEXT,
          so_tk TEXT,
          lop TEXT,
          khu_vuc TEXT,
          doi_tuong_uu_tien TEXT,
          doi_tuong_xet_tn TEXT,
          khoi TEXT,
          id_nganh TEXT,
          nganh TEXT,
          nganheg TEXT,
          chuyen_nganh TEXT,
          chuyen_nganh_eg TEXT,
          id_chuyen_nganh TEXT,
          khoa TEXT,
          khoa_eg TEXT,
          bac_he_dao_tao TEXT,
          bac_he_dao_tao_eg TEXT,
          nien_khoa TEXT,
          ma_cvht TEXT,
          ho_ten_cvht TEXT,
          ho_ten_cvht_eg TEXT,
          email_cvht TEXT,
          dien_thoai_cvht TEXT,
          ma_cvht_ng2 TEXT,
          ho_ten_cvht_ng2 TEXT,
          ho_ten_cvht_ng2_eg TEXT,
          email_cvht_ng2 TEXT,
          dien_thoai_cvht_ng2 TEXT,
          ma_truong TEXT,
          ten_truong TEXT,
          id_dia_phuong TEXT,
          id_khoa TEXT,
          id_sinh_vien TEXT,
          id_lop TEXT,
          id_khoi TEXT,
          id_bac_he_nganh TEXT,
          id_bac_he TEXT,
          id_he TEXT,
          id_quy_che TEXT,
          id_quy_che_p TEXT,
          id_hoc_che TEXT,
          id_don_vi_phan_cap TEXT,
          id_co_so_lop TEXT,
          nhhk_vao INTEGER,
          nhhk_ra INTEGER,
          str_nhhk_vao TEXT,
          str_nhhk_ra TEXT,
          id_lop2 TEXT,
          id_khoi2 TEXT,
          id_khoa2 TEXT,
          id_bac_he_nganh2 TEXT,
          id_bac_he2 TEXT,
          id_he2 TEXT,
          id_quy_che2 TEXT,
          id_quy_che_p2 TEXT,
          id_hoc_che2 TEXT,
          chuyen_nganh2_eg TEXT,
          str_nhhk_vao2 TEXT,
          str_nhhk_ra2 TEXT,
          is_master_pass INTEGER,
          is_cvht_dang_nhap INTEGER,
          is_phu_huynh_dang_nhap INTEGER,
          int_hien_dien_sv INTEGER,
          hien_dien_sv TEXT,
          hien_dien_sv_eg TEXT,
          hien_dien_sv_ng2 TEXT,
          int_hien_dien_dkmh INTEGER,
          so_hk_max_sv INTEGER,
          ds_menu_cam_xem TEXT,
          str_hoan_thanh_dgrl TEXT,
          url_netweb TEXT,
          canh_cao_tool TEXT,
          str_canh_cao TEXT,
          ghi_chu TEXT,
          is_nhap_dia_chi_moi INTEGER,
          lo_trinh_tieng_anh TEXT,
          nhhk_cuoi TEXT,
          so_qd_vao_moi TEXT,
          ngay_qd_vao_moi TEXT,
          so_qd_tot_nghiep TEXT,
          ngay_qd_tot_nghiep TEXT,
          is_xac_nhan_email INTEGER
        )
      ''');
      },
    );
  }
}
