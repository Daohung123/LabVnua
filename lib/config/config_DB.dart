import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:aqedu/shared/models/sqlite/cookie_token_model.dart';

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
        await db.execute('''
          CREATE TABLE session(
            id INTEGER PRIMARY KEY,
            user TEXT,
            pass TEXT,
            cookie TEXT,
            token TEXT
          )
        ''');
      },
    );
  }

  /// Lưu session
  Future<void> saveSession(SessionModel session) async {
    final db = await database;

    await db.insert(
      'session',
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Lấy session
  Future<SessionModel?> getSession() async {
    final db = await database;

    final result = await db.query('session', where: 'id = ?', whereArgs: [1]);

    if (result.isEmpty) return null;

    return SessionModel.fromMap(result.first);
  }

  /// checkLogin
  Future<bool> checkLogin() async {
    final db = await database;
    final result = await db.rawQuery("Select count(*) as count From session");
    if(result != 0 ) return true;
    return false;
  }

  /// Xóa session
  Future<void> deleteSession() async {
    final db = await database;

    await db.delete('session');
  }
}
