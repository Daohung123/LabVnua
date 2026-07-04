enum LocalTaskStatus { open, completed }

enum LocalTaskSyncStatus { pending, synced, failed }

class LocalTask {
  const LocalTask({
    required this.id,
    required this.title,
    this.description = '',
    this.type = 'todo',
    this.courseOrSessionLink,
    this.dueAt,
    this.status = LocalTaskStatus.open,
    this.syncStatus = LocalTaskSyncStatus.pending,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String description;
  final String type;
  final String? courseOrSessionLink;
  final DateTime? dueAt;
  final LocalTaskStatus status;
  final LocalTaskSyncStatus syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isCompleted => status == LocalTaskStatus.completed;

  LocalTask copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    String? courseOrSessionLink,
    DateTime? dueAt,
    bool clearDueAt = false,
    LocalTaskStatus? status,
    LocalTaskSyncStatus? syncStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LocalTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      courseOrSessionLink: courseOrSessionLink ?? this.courseOrSessionLink,
      dueAt: clearDueAt ? null : dueAt ?? this.dueAt,
      status: status ?? this.status,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
