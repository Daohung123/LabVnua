import 'package:aqedu/core/models/sqlite/Session.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../config/config_DB.dart';

class SqliteServices extends DBHelper {
  @override
  bool operator ==(Object other) {
    // TODO: implement ==
    return super == other;
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
    if (result != 0) return true;
    return false;
  }

  /// Xóa session
  Future<void> deleteSession() async {
    final db = await database;

    await db.delete('session');
  }
}
