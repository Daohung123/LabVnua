import 'package:aqedu/core/models/sqlite/Session.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../config/config_DB.dart';

class SqliteServices extends DataBaseConfig {
  /// Lưu session
  Future<void> saveSession(SessionModel session) async {
    final db = await database;
    await db.insert(
      'session',
      {...session.toMap(), 'id': 1},
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
    try {
      final db = await database;
      final result = await db.rawQuery("Select count(*) as count From session");
      int? count = Sqflite.firstIntValue(result);
      return (count ?? 0) > 0;
    } catch (e) {
      return false;
    }
  }

  /// Xóa session - Cải tiến: Không gây crash nếu thiếu bảng
  Future<void> deleteSession() async {
    final db = await database;
    try {
      await db.delete('session');
      // Thử xóa các bảng khác, nếu chưa có bảng thì bỏ qua (không báo lỗi)
      await db.rawDelete("DELETE FROM student_data").catchError((e) => 0);
      await db.rawDelete("DELETE FROM notifications").catchError((e) => 0);
      await db.rawDelete("DELETE FROM lich_thi").catchError((e) => 0);
    } catch (e) {
      print("Lỗi khi dọn dẹp database: $e");
    }
  }
}
