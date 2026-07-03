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

  factory LocalTask.fromMap(Map<String, Object?> map) {
    return LocalTask(
      id: _asString(map['id']),
      title: _asString(map['title']),
      description: _asString(map['description']),
      type: _asString(map['type'], fallback: 'todo'),
      courseOrSessionLink: _asNullableString(map['course_or_session_link']),
      dueAt: _parseDate(map['due_at']),
      status: _parseStatus(map['status']),
      syncStatus: _parseSyncStatus(map['sync_status']),
      createdAt:
          _parseDate(map['created_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt:
          _parseDate(map['updated_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'course_or_session_link': courseOrSessionLink,
      'due_at': dueAt?.toIso8601String(),
      'status': status.name,
      'sync_status': syncStatus.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

String _asString(Object? value, {String fallback = ''}) {
  if (value == null) return fallback;
  return value.toString();
}

String? _asNullableString(Object? value) {
  final text = _asString(value).trim();
  return text.isEmpty ? null : text;
}

DateTime? _parseDate(Object? value) {
  final text = _asNullableString(value);
  if (text == null) return null;
  return DateTime.tryParse(text);
}

LocalTaskStatus _parseStatus(Object? value) {
  return LocalTaskStatus.values.firstWhere(
    (status) => status.name == value,
    orElse: () => LocalTaskStatus.open,
  );
}

LocalTaskSyncStatus _parseSyncStatus(Object? value) {
  return LocalTaskSyncStatus.values.firstWhere(
    (status) => status.name == value,
    orElse: () => LocalTaskSyncStatus.pending,
  );
}
