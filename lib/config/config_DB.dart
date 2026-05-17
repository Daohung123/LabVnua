import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseConfig {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'auth.db');

    return openDatabase(
      path,
      version: 3, // Tăng version lên 3 để trigger onUpgrade
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          // Xóa bảng cũ để tạo lại với cấu trúc mới nếu cần thiết khi phát triển
          await db.execute("DROP TABLE IF EXISTS lich_thi");
          await _createTables(db);
        }
      },
    );
  }

  Future<void> _createTables(Database db) async {
    // bảng session
    await db.execute('''
      CREATE TABLE IF NOT EXISTS session(
        id INTEGER PRIMARY KEY,
        user TEXT,
        pass TEXT,
        cookie TEXT,
        token TEXT,
        active INTEGER
      )
    ''');

    // bảng notifications
    await db.execute('''
      CREATE TABLE IF NOT EXISTS notifications(
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

    // bảng student_data
    await db.execute('''
      CREATE TABLE IF NOT EXISTS student_data(
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

    // Bảng lịch thi
    await db.execute('''
      CREATE TABLE IF NOT EXISTS lich_thi(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_nhom_thi TEXT,
        hoc_ky_id INTEGER,
        ma_mon TEXT,
        ten_mon TEXT,
        ma_phong TEXT,
        ngay_thi TEXT,
        gio_bat_dau TEXT,
        so_phut TEXT,
        hinh_thuc_thi TEXT,
        si_so INTEGER,
        so_tiet TEXT,
        to_thi TEXT,
        ghi_chu TEXT
      )
    ''');
  }
}
