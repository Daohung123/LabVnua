import 'package:aqedu/features/task/domain/entities/local_task.dart';
import 'package:aqedu/features/task/domain/usecases/manage_local_tasks.dart';

class LocalTaskController {
  LocalTaskController({required ManageLocalTasks manageLocalTasks})
    : _manageLocalTasks = manageLocalTasks;

  final ManageLocalTasks _manageLocalTasks;

  Future<List<LocalTask>> loadTasks() => _manageLocalTasks.loadTasks();

  Future<List<LocalTask>> loadUpcomingTasks({int limit = 3}) {
    return _manageLocalTasks.loadUpcomingTasks(limit: limit);
  }

  Future<LocalTask> createTask({
    required String title,
    String description = '',
    String type = 'todo',
    String? courseOrSessionLink,
    DateTime? dueAt,
  }) {
    return _manageLocalTasks.createTask(
      title: title,
      description: description,
      type: type,
      courseOrSessionLink: courseOrSessionLink,
      dueAt: dueAt,
    );
  }

  Future<LocalTask> toggleTask(LocalTask task) {
    return _manageLocalTasks.toggleTask(task);
  }

  Future<void> deleteTask(String id) => _manageLocalTasks.deleteTask(id);
}
