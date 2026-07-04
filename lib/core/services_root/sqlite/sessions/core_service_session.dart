import 'package:aqedu/core/models/sqlite/session.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../config/config_db.dart';

class SqliteServices extends DataBaseConfig {
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
    final count = Sqflite.firstIntValue(result) ?? 0;
    return count > 0;
  }

  /// Xóa session
  Future<void> deleteSession() async {
    final db = await database;

    await db.delete('session');
  }
}
