import 'dart:convert';

import 'package:aqedu/config/config_db.dart';
import 'package:aqedu/features/notification/models/notification_student.dart';
import 'package:sqflite/sqflite.dart';

class ServiceSqlNotificationStudentRoot {
  final DataBaseConfig _dbConfig = DataBaseConfig();

  /// =====================================================
  /// INSERT 1 NOTIFICATION
  /// =====================================================
  Future<int> insertNotification(NotificationItem item) async {
    final db = await _dbConfig.database;

    return await db.insert(
      'notifications',
      _notificationToMap(item),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// =====================================================
  /// INSERT LIST NOTIFICATIONS
  /// =====================================================
  Future<void> insertListNotification(List<NotificationItem> items) async {
    final db = await _dbConfig.database;

    final batch = db.batch();

    for (final item in items) {
      batch.insert(
        'notifications',
        _notificationToMap(item),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  /// =====================================================
  /// GET ALL
  /// =====================================================
  Future<List<NotificationItem>> getAllNotifications() async {
    final db = await _dbConfig.database;

    final result = await db.query('notifications', orderBy: 'ngay_gui DESC');

    return result
        .map((e) => NotificationItem.fromJson(_mapToNotification(e)))
        .toList();
  }

  /// =====================================================
  /// GET BY ID
  /// =====================================================
  Future<NotificationItem?> getNotificationById(String id) async {
    final db = await _dbConfig.database;

    final result = await db.query(
      'notifications',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return NotificationItem.fromJson(_mapToNotification(result.first));
    }

    return null;
  }

  /// =====================================================
  /// UPDATE
  /// =====================================================
  Future<int> updateNotification(NotificationItem item) async {
    final db = await _dbConfig.database;

    return await db.update(
      'notifications',
      _notificationToMap(item),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  /// =====================================================
  /// MARK AS READ
  /// =====================================================
  Future<int> markAsRead(String id) async {
    final db = await _dbConfig.database;

    return await db.update(
      'notifications',
      {'is_da_doc': 1, 'ngay_xem': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// =====================================================
  /// DELETE BY ID
  /// =====================================================
  Future<int> deleteNotification(String id) async {
    final db = await _dbConfig.database;

    return await db.delete('notifications', where: 'id = ?', whereArgs: [id]);
  }

  /// =====================================================
  /// DELETE ALL
  /// =====================================================
  Future<int> deleteAllNotifications() async {
    final db = await _dbConfig.database;

    return await db.delete('notifications');
  }

  /// =====================================================
  /// COUNT UNREAD
  /// =====================================================
  Future<int> countUnreadNotifications() async {
    final db = await _dbConfig.database;

    final result = await db.rawQuery('''
      SELECT COUNT(*) as count
      FROM notifications
      WHERE is_da_doc = 0
    ''');

    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// =====================================================
  /// SYNC API RESPONSE
  /// =====================================================
  Future<void> syncFromApi(NotificationResponse response) async {
    final items = response.data?.dsThongBao ?? [];

    await insertListNotification(items);
  }

  /// =====================================================
  /// CONVERT MODEL -> SQLITE MAP
  /// =====================================================
  Map<String, dynamic> _notificationToMap(NotificationItem item) {
    return {
      'id': item.id,
      'doi_tuong_search': item.doiTuongSearch,
      'doi_tuong': item.doiTuong,
      'phan_cap_search': item.phanCapSearch,
      'phan_cap_sinh_vien': item.phanCapSinhVien,
      'tieu_de': item.tieuDe,
      'noi_dung': item.noiDung,
      'is_phai_xem': item.isPhaiXem == true ? 1 : 0,
      'ngay_gui': item.ngayGui?.toIso8601String(),
      'nguoi_gui': item.nguoiGui,
      'is_da_doc': item.isDaDoc == true ? 1 : 0,
      'ds_doi_tuong': jsonEncode(item.dsDoiTuong ?? []),
      'is_xem_phan_hoi': item.isXemPhanHoi == true ? 1 : 0,
      'ngay_xem': item.ngayXem?.toIso8601String(),
    };
  }

  /// =====================================================
  /// CONVERT SQLITE MAP -> JSON MODEL
  /// =====================================================
  Map<String, dynamic> _mapToNotification(Map<String, dynamic> map) {
    return {
      'id': map['id'],
      'doi_tuong_search': map['doi_tuong_search'],
      'doi_tuong': map['doi_tuong'],
      'phan_cap_search': map['phan_cap_search'],
      'phan_cap_sinh_vien': map['phan_cap_sinh_vien'],
      'tieu_de': map['tieu_de'],
      'noi_dung': map['noi_dung'],
      'is_phai_xem': map['is_phai_xem'] == 1,
      'ngay_gui': map['ngay_gui'],
      'nguoi_gui': map['nguoi_gui'],
      'is_da_doc': map['is_da_doc'] == 1,
      'ds_doi_tuong': map['ds_doi_tuong'] != null
          ? jsonDecode(map['ds_doi_tuong'])
          : [],
      'is_xem_phan_hoi': map['is_xem_phan_hoi'] == 1,
      'ngay_xem': map['ngay_xem'],
    };
  }

  /// =====================================================
  /// CONVERT 1 NOTIFICATION -> STRING JSON
  /// =====================================================
  String notificationToString(NotificationItem item) {
    return jsonEncode(_notificationToMap(item));
  }

  /// =====================================================
  /// CONVERT LIST NOTIFICATIONS -> STRING JSON
  /// =====================================================
  String notificationListToString(List<NotificationItem> items) {
    final data = items.map((e) => _notificationToMap(e)).toList();

    return jsonEncode(data);
  }

  /// =====================================================
  /// EXPORT ALL SQLITE DATA -> STRING JSON
  /// =====================================================
  Future<String> exportAllNotificationsToString() async {
    final list = await getAllNotifications();

    return notificationListToString(list);
  }
}
