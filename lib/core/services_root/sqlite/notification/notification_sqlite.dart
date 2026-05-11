import 'package:aqedu/config/config_DB.dart';
import 'package:sqflite/sqflite.dart';



class ServiceSqlNotification {
  final DataBaseConfig db = DataBaseConfig();

  /// thêm notification
  Future<int> insertNotification(Map<String, dynamic> data) async {
    final db = await this.db.database;

    return await db.insert(
      'notifications',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// lấy toàn bộ notifications
  Future<List<Map<String, dynamic>>> getAllNotifications() async {
    final db = await this.db.database;

    return await db.query(
      'notifications',
      orderBy: 'ngay_gui DESC',
    );
  }

  /// lấy notification theo id
  Future<Map<String, dynamic>?> getNotificationById(String id) async {
    final db = await this.db.database;

    final result = await db.query(
      'notifications',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  /// update notification
  Future<int> updateNotification(
    String id,
    Map<String, dynamic> data,
  ) async {
    final db = await this.db.database;

    return await db.update(
      'notifications',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// đánh dấu đã đọc
  Future<int> markAsRead(String id) async {
    final db = await this.db.database;

    return await db.update(
      'notifications',
      {
        'is_da_doc': 1,
        'ngay_xem': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// xóa notification theo id
  Future<int> deleteNotification(String id) async {
    final db = await this.db.database;

    return await db.delete(
      'notifications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// xóa toàn bộ notifications
  Future<int> deleteAllNotifications() async {
    final db = await this.db.database;

    return await db.delete('notifications');
  }

  /// đếm số notification chưa đọc
  Future<int> countUnreadNotifications() async {
    final db = await this.db.database;

    final result = await db.rawQuery('''
      SELECT COUNT(*) as count
      FROM notifications
      WHERE is_da_doc = 0
    ''');

    return Sqflite.firstIntValue(result) ?? 0;
  }
}