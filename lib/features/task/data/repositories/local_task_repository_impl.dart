import 'package:aqedu/features/task/data/datasources/local_task_local_data_source.dart';
import 'package:aqedu/features/task/domain/entities/local_task.dart';
import 'package:aqedu/features/task/domain/repositories/local_task_repository.dart';

class LocalTaskRepositoryImpl implements LocalTaskRepository {
  LocalTaskRepositoryImpl({LocalTaskLocalDataSource? localDataSource})
    : _localDataSource = localDataSource ?? LocalTaskLocalDataSource();

  final LocalTaskLocalDataSource _localDataSource;

  @override
  Future<void> deleteTask(String id) => _localDataSource.deleteTask(id);

  @override
  Future<List<LocalTask>> loadTasks() => _localDataSource.loadTasks();

  @override
  Future<List<LocalTask>> loadUpcomingTasks({int limit = 3}) {
    return _localDataSource.loadUpcomingTasks(limit: limit);
  }

  @override
  Future<void> saveTask(LocalTask task) => _localDataSource.saveTask(task);
}
