import 'dart:convert';

import 'package:aqedu/config/config_db.dart';
import 'package:aqedu/features/schedure/models/schedure_student.dart';
import 'package:sqflite/sqflite.dart';

class ServiceSqlTkb {
  final DataBaseConfig _dbConfig = DataBaseConfig();

  /// =====================================================
  /// INSERT 1 SCHEDULE
  /// =====================================================
  Future<int> insertSchedule(ThoiKhoaBieu item) async {
    final db = await _dbConfig.database;

    return await db.insert(
      'thoi_khoa_bieu',
      _scheduleToMap(item),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// =====================================================
  /// INSERT LIST SCHEDULE
  /// =====================================================
  Future<void> insertListSchedule(List<ThoiKhoaBieu> items) async {
    final db = await _dbConfig.database;

    final batch = db.batch();

    for (final item in items) {
      batch.insert(
        'thoi_khoa_bieu',
        _scheduleToMap(item),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  /// =====================================================
  /// GET ALL SCHEDULE
  /// =====================================================
  Future<List<ThoiKhoaBieu>> getAllSchedules() async {
    final db = await _dbConfig.database;

    final result = await db.query('thoi_khoa_bieu', orderBy: 'ngay_hoc ASC');

    return result.map((e) => ThoiKhoaBieu.fromJson(_mapToSchedule(e))).toList();
  }

  /// =====================================================
  /// GET SCHEDULE BY DATE
  /// =====================================================
  Future<List<ThoiKhoaBieu>> getScheduleByDate(String ngayHoc) async {
    final db = await _dbConfig.database;

    final result = await db.query(
      'thoi_khoa_bieu',
      where: 'ngay_hoc = ?',
      whereArgs: [ngayHoc],
      orderBy: 'tiet_bat_dau ASC',
    );

    return result.map((e) => ThoiKhoaBieu.fromJson(_mapToSchedule(e))).toList();
  }

  /// =====================================================
  /// DELETE ALL
  /// =====================================================
  Future<int> deleteAllSchedules() async {
    final db = await _dbConfig.database;

    return await db.delete('thoi_khoa_bieu');
  }

  /// =====================================================
  /// DELETE BY DATE
  /// =====================================================
  Future<int> deleteScheduleByDate(String ngayHoc) async {
    final db = await _dbConfig.database;

    return await db.delete(
      'thoi_khoa_bieu',
      where: 'ngay_hoc = ?',
      whereArgs: [ngayHoc],
    );
  }

  /// =====================================================
  /// COUNT TOTAL
  /// =====================================================
  Future<int> countSchedules() async {
    final db = await _dbConfig.database;

    final result = await db.rawQuery('''
      SELECT COUNT(*) as count
      FROM thoi_khoa_bieu
    ''');

    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// =====================================================
  /// SYNC API RESPONSE
  /// =====================================================
  Future<void> syncFromApi(TkbResponse response) async {
    final List<ThoiKhoaBieu> allSchedules = [];

    for (final tuan in response.dsTuanTkb) {
      allSchedules.addAll(tuan.dsThoiKhoaBieu);
    }

    await insertListSchedule(allSchedules);
  }

  /// =====================================================
  /// CONVERT MODEL -> SQLITE MAP
  /// =====================================================
  Map<String, dynamic> _scheduleToMap(ThoiKhoaBieu item) {
    return {
      'id': '${item.ngayhoc}_${item.thu}_${item.tietBatDau}_${item.tenMon}',
      'thu_kieu_so': item.thu,
      'tiet_bat_dau': item.tietBatDau,
      'so_tiet': item.soTiet,
      'ten_mon': item.tenMon,
      'ten_giang_vien': item.giangVien,
      'ma_phong': item.phong,
      'ngay_hoc': item.ngayhoc,
    };
  }

  /// =====================================================
  /// CONVERT SQLITE MAP -> JSON MODEL
  /// =====================================================
  Map<String, dynamic> _mapToSchedule(Map<String, dynamic> map) {
    return {
      'thu_kieu_so': map['thu_kieu_so'],
      'tiet_bat_dau': map['tiet_bat_dau'],
      'so_tiet': map['so_tiet'],
      'ten_mon': map['ten_mon'],
      'ten_giang_vien': map['ten_giang_vien'],
      'ma_phong': map['ma_phong'],
      'ngay_hoc': map['ngay_hoc'],
    };
  }
}
