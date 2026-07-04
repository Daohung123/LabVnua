import 'package:aqedu/core/logging/app_log.dart';
import 'package:aqedu/core/models/sqlite/session.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../config/config_db.dart';

class SqliteServices extends DataBaseConfig {
  /// Lưu session
  Future<void> saveSession(SessionModel session) async {
    final db = await database;
    AppLog.coSoDuLieu(
      'Lưu session vào SQLite',
      khuVuc: 'Session SQLite',
      duLieu: {
        'co_cookie': session.cookie.isNotEmpty,
        'co_token': session.token.isNotEmpty,
      },
    );

    await db.insert(
      'session',
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Lấy session
  Future<SessionModel?> getSession() async {
    final db = await database;
    AppLog.coSoDuLieu('Đọc session từ SQLite', khuVuc: 'Session SQLite');

    final result = await db.query('session', where: 'id = ?', whereArgs: [1]);

    if (result.isEmpty) {
      AppLog.coSoDuLieu(
        'Không tìm thấy session trong SQLite',
        khuVuc: 'Session SQLite',
      );
      return null;
    }
    AppLog.coSoDuLieu(
      'Tìm thấy session trong SQLite',
      khuVuc: 'Session SQLite',
      duLieu: {'so_luong_ban_ghi': result.length},
    );

    return SessionModel.fromMap(result.first);
  }

  /// checkLogin
  Future<bool> checkLogin() async {
    final db = await database;
    final result = await db.rawQuery("Select count(*) as count From session");
    final count = Sqflite.firstIntValue(result) ?? 0;
    AppLog.coSoDuLieu(
      'Kiểm tra số lượng session trong SQLite',
      khuVuc: 'Session SQLite',
      duLieu: {'so_luong_session': count},
    );
    return count > 0;
  }

  /// Xóa session
  Future<void> deleteSession() async {
    final db = await database;
    AppLog.coSoDuLieu('Xóa session khỏi SQLite', khuVuc: 'Session SQLite');

    await db.delete('session');
  }
}
