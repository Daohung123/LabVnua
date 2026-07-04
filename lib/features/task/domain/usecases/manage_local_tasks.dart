import 'package:aqedu/features/task/domain/entities/local_task.dart';
import 'package:aqedu/features/task/domain/repositories/local_task_repository.dart';

class ManageLocalTasks {
  ManageLocalTasks(this._repository);

  final LocalTaskRepository _repository;

  Future<List<LocalTask>> loadTasks() => _repository.loadTasks();

  Future<List<LocalTask>> loadUpcomingTasks({int limit = 3}) {
    return _repository.loadUpcomingTasks(limit: limit);
  }

  Future<LocalTask> createTask({
    required String title,
    String description = '',
    String type = 'todo',
    String? courseOrSessionLink,
    DateTime? dueAt,
  }) async {
    final normalizedTitle = title.trim();
    if (normalizedTitle.isEmpty) {
      throw ArgumentError('Task title is required');
    }

    final now = DateTime.now();
    final task = LocalTask(
      id: 'task_${now.microsecondsSinceEpoch}',
      title: normalizedTitle,
      description: description.trim(),
      type: type.trim().isEmpty ? 'todo' : type.trim(),
      courseOrSessionLink: _cleanOptional(courseOrSessionLink),
      dueAt: dueAt,
      createdAt: now,
      updatedAt: now,
    );
    await _repository.saveTask(task);
    return task;
  }

  Future<LocalTask> toggleTask(LocalTask task) async {
    final updated = task.copyWith(
      status: task.isCompleted
          ? LocalTaskStatus.open
          : LocalTaskStatus.completed,
      syncStatus: LocalTaskSyncStatus.pending,
      updatedAt: DateTime.now(),
    );
    await _repository.saveTask(updated);
    return updated;
  }

  Future<void> deleteTask(String id) => _repository.deleteTask(id);

  String? _cleanOptional(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? null : text;
  }
}
