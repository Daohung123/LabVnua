import 'dart:convert';

import 'package:aqedu/config/config_DB.dart';
import 'package:aqedu/features/semester_timetable/models/model_semester_timetable.dart';
import 'package:sqflite/sqflite.dart';

class SemesterTimetableSqliteRoot {
  final DataBaseConfig _dbConfig = DataBaseConfig();

  /// =====================================================
  /// INSERT 1 TIMETABLE
  /// =====================================================
  Future<int> insertSemesterTimetable(SemesterTimetableItem item) async {
    final db = await _dbConfig.database;

    return await db.insert(
      'semester_timetable',
      _timetableToMap(item),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// =====================================================
  /// INSERT LIST
  /// =====================================================
  Future<void> insertListSemesterTimetable(
    List<SemesterTimetableItem> items,
  ) async {
    final db = await _dbConfig.database;

    final batch = db.batch();

    for (final item in items) {
      batch.insert(
        'semester_timetable',
        _timetableToMap(item),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  /// =====================================================
  /// GET ALL
  /// =====================================================
  Future<List<SemesterTimetableItem>> getAllSemesterTimetable() async {
    final db = await _dbConfig.database;

    final result = await db.query(
      'semester_timetable',
      orderBy: 'thu ASC, tbd ASC',
    );

    return result
        .map((e) => SemesterTimetableItem.fromJson(_mapToSemesterTimetable(e)))
        .toList();
  }

  /// =====================================================
  /// DELETE ALL
  /// =====================================================
  Future<int> deleteAllSemesterTimetable() async {
    final db = await _dbConfig.database;

    return await db.delete('semester_timetable');
  }

  /// =====================================================
  /// SYNC API RESPONSE
  /// =====================================================
  Future<void> syncFromApi(SemesterTimetableResponse response) async {
    final items = response.data?.dsNhomTo ?? [];

    await insertListSemesterTimetable(items);
  }

  /// =====================================================
  /// MODEL -> SQLITE MAP
  /// =====================================================
  Map<String, dynamic> _timetableToMap(SemesterTimetableItem item) {
    return {
      'id_to_hoc': item.idToHoc,
      'ma_mon': item.maMon,
      'ten_mon': item.tenMon,
      'nhom_to': item.nhomTo,
      'thu': item.thu,
      'tbd': item.tietBatDau,
      'so_tiet': item.soTiet,
      'tu_gio': item.tuGio,
      'den_gio': item.denGio,
      'phong': item.phong,
      'lop': item.lop,
      'gv': item.gv,
      'tooltip': item.tooltip,
    };
  }

  /// =====================================================
  /// SQLITE MAP -> JSON MODEL
  /// =====================================================
  Map<String, dynamic> _mapToSemesterTimetable(Map<String, dynamic> map) {
    return {
      'id_to_hoc': map['id_to_hoc'],
      'ma_mon': map['ma_mon'],
      'ten_mon': map['ten_mon'],
      'nhom_to': map['nhom_to'],
      'thu': map['thu'],
      'tbd': map['tbd'],
      'so_tiet': map['so_tiet'],
      'tu_gio': map['tu_gio'],
      'den_gio': map['den_gio'],
      'phong': map['phong'],
      'lop': map['lop'],
      'gv': map['gv'],
      'tooltip': map['tooltip'],
    };
  }

  /// =====================================================
  /// CONVERT 1 ITEM -> STRING JSON
  /// =====================================================
  String semesterTimetableToString(SemesterTimetableItem item) {
    return jsonEncode(_timetableToMap(item));
  }

  /// =====================================================
  /// CONVERT LIST -> STRING JSON
  /// =====================================================
  String semesterTimetableListToString(List<SemesterTimetableItem> items) {
    final data = items.map((e) => _timetableToMap(e)).toList();

    return jsonEncode(data);
  }

  /// =====================================================
  /// EXPORT ALL SQLITE -> STRING JSON
  /// =====================================================
  Future<String> exportAllSemesterTimetableToString() async {
    final list = await getAllSemesterTimetable();

    return semesterTimetableListToString(list);
  }
}
