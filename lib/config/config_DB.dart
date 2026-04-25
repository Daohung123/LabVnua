import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
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

        // bảng tiết trong ngày
        await db.execute('''
        CREATE TABLE tiet_trong_ngay(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          tiet INTEGER,
          gio_bat_dau TEXT,
          gio_ket_thuc TEXT
        )
      ''');

        // bảng tuần TKB
        await db.execute('''
        CREATE TABLE tuan_tkb(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          tuan_hoc_ky INTEGER,
          thong_tin_tuan TEXT,
          ngay_bat_dau TEXT,
          ngay_ket_thuc TEXT
        )
      ''');

        // bảng thời khóa biểu (liên kết với tuần)
        await db.execute('''
        CREATE TABLE thoi_khoa_bieu(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          thu INTEGER,
          tiet_bat_dau INTEGER,
          so_tiet INTEGER,
          ten_mon TEXT,
          giang_vien TEXT,
          phong TEXT,
          ngay_hoc TEXT,
          tuan_id INTEGER,
          FOREIGN KEY (tuan_id) REFERENCES tuan_tkb(id)
        )
      ''');
      },
    );
  }
}
