import 'package:aqedu/config/config_DB.dart';
import 'package:aqedu/features/task/models/task_models.dart';
import 'package:sqflite/sqflite.dart';

class LocalTaskService {
  LocalTaskService({DataBaseConfig? dbConfig})
    : _dbConfig = dbConfig ?? DataBaseConfig();

  final DataBaseConfig _dbConfig;

  Future<List<LocalTask>> loadTasks() async {
    final db = await _dbConfig.database;
    final rows = await db.query(
      'tasks',
      orderBy: 'status ASC, due_at IS NULL, due_at ASC, updated_at DESC',
    );
    return rows.map(LocalTask.fromMap).toList();
  }

  Future<List<LocalTask>> loadUpcomingTasks({int limit = 3}) async {
    final db = await _dbConfig.database;
    final rows = await db.query(
      'tasks',
      where: 'status = ? AND due_at IS NOT NULL',
      whereArgs: [LocalTaskStatus.open.name],
      orderBy: 'due_at ASC',
      limit: limit,
    );
    return rows.map(LocalTask.fromMap).toList();
  }

  Future<void> saveTask(LocalTask task) async {
    final db = await _dbConfig.database;
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteTask(String id) async {
    final db = await _dbConfig.database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
