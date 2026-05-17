import 'package:aqedu/config/config_DB.dart';
import 'package:aqedu/features/exam_schedule/models/model_main_object.dart';
import 'package:sqflite/sqflite.dart';

class ServiceSqlExamScheduleRoot {
  final DataBaseConfig _dbConfig = DataBaseConfig();

  static const String tableName = 'lich_thi';

  /// =====================================================
  /// INSERT OR REPLACE EXAMS
  /// =====================================================
  Future<void> insertExams(List<LichThi> exams, int hocKyId) async {
    final Database db = await _dbConfig.database;

    // Xóa lịch thi cũ của học kỳ này trước khi chèn mới để đồng bộ
    await db.delete(
      tableName,
      where: 'hoc_ky_id = ?',
      whereArgs: [hocKyId],
    );

    final batch = db.batch();
    for (var exam in exams) {
      batch.insert(
        tableName,
        exam.toMap(hocKyId),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  /// =====================================================
  /// GET EXAMS BY SEMESTER
  /// =====================================================
  Future<List<LichThi>> getExamsBySemester(int hocKyId) async {
    final Database db = await _dbConfig.database;

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'hoc_ky_id = ?',
      whereArgs: [hocKyId],
    );

    if (maps.isEmpty) return [];

    return List.generate(maps.length, (i) {
      return LichThi.fromMap(maps[i]);
    });
  }

  /// =====================================================
  /// DELETE ALL EXAMS
  /// =====================================================
  Future<int> deleteAllExams() async {
    final Database db = await _dbConfig.database;
    return await db.delete(tableName);
  }
}
