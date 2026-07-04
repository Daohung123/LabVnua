import 'package:aqedu/core/database/app_database.dart';
import 'package:aqedu/features/task/data/models/local_task_model.dart';
import 'package:aqedu/features/task/domain/entities/local_task.dart';
import 'package:sqflite/sqflite.dart';

class LocalTaskLocalDataSource {
  LocalTaskLocalDataSource({AppDatabase? database})
    : _database = database ?? AppDatabase();

  final AppDatabase _database;

  Future<List<LocalTask>> loadTasks() async {
    final db = await _database.instance;
    final rows = await db.query(
      'tasks',
      orderBy: 'status ASC, due_at IS NULL, due_at ASC, updated_at DESC',
    );
    return rows.map(LocalTaskModel.fromMap).toList();
  }

  Future<List<LocalTask>> loadUpcomingTasks({int limit = 3}) async {
    final db = await _database.instance;
    final rows = await db.query(
      'tasks',
      where: 'status = ? AND due_at IS NOT NULL',
      whereArgs: [LocalTaskStatus.open.name],
      orderBy: 'due_at ASC',
      limit: limit,
    );
    return rows.map(LocalTaskModel.fromMap).toList();
  }

  Future<void> saveTask(LocalTask task) async {
    final db = await _database.instance;
    await db.insert(
      'tasks',
      LocalTaskModel.toMap(task),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteTask(String id) async {
    final db = await _database.instance;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
