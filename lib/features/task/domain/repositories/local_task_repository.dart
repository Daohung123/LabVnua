import 'package:aqedu/features/task/domain/entities/local_task.dart';

abstract class LocalTaskRepository {
  Future<List<LocalTask>> loadTasks();

  Future<List<LocalTask>> loadUpcomingTasks({int limit = 3});

  Future<void> saveTask(LocalTask task);

  Future<void> deleteTask(String id);
}
