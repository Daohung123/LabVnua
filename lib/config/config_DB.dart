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
      version: 6,
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

        await _createChangeNotificationTables(db);
        await _createHomeShortcutTable(db);
        await _createTaskPlatformTables(db);
        await _createClassSessionTables(db);
        await _createApiResponseCacheTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await _createChangeNotificationTables(db);
        }
        if (oldVersion < 4) {
          await _createHomeShortcutTable(db);
        }
        if (oldVersion < 5) {
          await _createTaskPlatformTables(db);
          await _createClassSessionTables(db);
        }
        if (oldVersion < 6) {
          await _createApiResponseCacheTable(db);
        }
      },
    );
  }

  Future<void> _createChangeNotificationTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS notification_history(
        id TEXT PRIMARY KEY,
        change_id TEXT NOT NULL UNIQUE,
        data_type TEXT NOT NULL,
        change_type TEXT NOT NULL,
        entity_id TEXT NOT NULL,
        title TEXT NOT NULL,
        message TEXT NOT NULL,
        old_hash TEXT,
        new_hash TEXT,
        old_payload TEXT,
        new_payload TEXT,
        is_read INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        notified_at TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS chat_notifications(
        id TEXT PRIMARY KEY,
        conversation_id TEXT NOT NULL,
        sender_student_id TEXT NOT NULL,
        sender_name TEXT NOT NULL,
        sender_avatar_url TEXT,
        message TEXT NOT NULL,
        created_at TEXT NOT NULL,
        is_read INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_notification_history_data_type
      ON notification_history(data_type, created_at DESC)
    ''');
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_notification_history_unread
      ON notification_history(is_read, created_at DESC)
    ''');
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_chat_notifications_unread
      ON chat_notifications(is_read, created_at DESC)
    ''');
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_chat_notifications_sender
      ON chat_notifications(sender_student_id, created_at DESC)
    ''');

    await _createCachedDataTable(db, 'cached_scores');
    await _createCachedDataTable(db, 'cached_schedule');
    await _createCachedDataTable(db, 'cached_exam_schedule');
    await _createCachedDataTable(db, 'cached_tuition');
    await _createCachedDataTable(db, 'cached_course_register');
    await _createCachedDataTable(db, 'cached_training_notifications');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS thoi_khoa_bieu(
        id TEXT PRIMARY KEY,
        thu_kieu_so INTEGER,
        tiet_bat_dau INTEGER,
        so_tiet INTEGER,
        ten_mon TEXT,
        ten_giang_vien TEXT,
        ma_phong TEXT,
        ngay_hoc TEXT
      )
    ''');
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_thoi_khoa_bieu_ngay_hoc
      ON thoi_khoa_bieu(ngay_hoc, tiet_bat_dau)
    ''');
  }

  Future<void> _createHomeShortcutTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS home_shortcuts(
        profile_id TEXT NOT NULL,
        shortcut_key TEXT NOT NULL,
        sort_order INTEGER NOT NULL,
        enabled INTEGER NOT NULL DEFAULT 0,
        updated_at TEXT NOT NULL,
        PRIMARY KEY(profile_id, shortcut_key)
      )
    ''');
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_home_shortcuts_profile_order
      ON home_shortcuts(profile_id, sort_order)
    ''');
  }

  Future<void> _createTaskPlatformTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS tasks(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL DEFAULT '',
        type TEXT NOT NULL DEFAULT 'todo',
        course_or_session_link TEXT,
        due_at TEXT,
        status TEXT NOT NULL DEFAULT 'open',
        sync_status TEXT NOT NULL DEFAULT 'pending',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_tasks_status_due
      ON tasks(status, due_at)
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS analytics_events(
        id TEXT PRIMARY KEY,
        event_name TEXT NOT NULL,
        feature_name TEXT NOT NULL,
        role TEXT NOT NULL DEFAULT 'anonymous',
        metadata TEXT NOT NULL DEFAULT '{}',
        created_at TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_analytics_events_feature_time
      ON analytics_events(feature_name, created_at DESC)
    ''');
  }

  Future<void> _createClassSessionTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS class_session_notes(
        id TEXT PRIMARY KEY,
        session_key TEXT NOT NULL,
        owner_hash TEXT NOT NULL,
        content TEXT NOT NULL,
        sync_status TEXT NOT NULL DEFAULT 'pending',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_class_session_notes_session
      ON class_session_notes(session_key, updated_at DESC)
    ''');
  }

  Future<void> _createApiResponseCacheTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS api_response_cache(
        id TEXT PRIMARY KEY,
        method TEXT NOT NULL,
        path TEXT NOT NULL,
        request_hash TEXT NOT NULL,
        request_body TEXT NOT NULL,
        response_body TEXT NOT NULL,
        response_status INTEGER NOT NULL,
        source_url TEXT NOT NULL,
        cached_at TEXT NOT NULL,
        UNIQUE(method, path, request_hash)
      )
    ''');
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_api_response_cache_path
      ON api_response_cache(path, cached_at DESC)
    ''');
  }

  Future<void> _createCachedDataTable(Database db, String tableName) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName(
        id TEXT PRIMARY KEY,
        data_type TEXT NOT NULL,
        entity_id TEXT NOT NULL,
        title TEXT NOT NULL,
        payload TEXT NOT NULL,
        payload_hash TEXT NOT NULL,
        source_updated_at TEXT,
        cached_at TEXT NOT NULL,
        UNIQUE(data_type, entity_id)
      )
    ''');
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_${tableName}_hash
      ON $tableName(payload_hash)
    ''');
  }
}
