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
      },
    );
  }
}
