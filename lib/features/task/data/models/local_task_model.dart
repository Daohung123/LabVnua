import 'package:aqedu/features/task/domain/entities/local_task.dart';

class LocalTaskModel {
  const LocalTaskModel._();

  static LocalTask fromMap(Map<String, Object?> map) {
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

  static Map<String, Object?> toMap(LocalTask task) {
    return {
      'id': task.id,
      'title': task.title,
      'description': task.description,
      'type': task.type,
      'course_or_session_link': task.courseOrSessionLink,
      'due_at': task.dueAt?.toIso8601String(),
      'status': task.status.name,
      'sync_status': task.syncStatus.name,
      'created_at': task.createdAt.toIso8601String(),
      'updated_at': task.updatedAt.toIso8601String(),
    };
  }

  static String _asString(Object? value, {String fallback = ''}) {
    if (value == null) return fallback;
    return value.toString();
  }

  static String? _asNullableString(Object? value) {
    final text = _asString(value).trim();
    return text.isEmpty ? null : text;
  }

  static DateTime? _parseDate(Object? value) {
    final text = _asNullableString(value);
    if (text == null) return null;
    return DateTime.tryParse(text);
  }

  static LocalTaskStatus _parseStatus(Object? value) {
    return LocalTaskStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => LocalTaskStatus.open,
    );
  }

  static LocalTaskSyncStatus _parseSyncStatus(Object? value) {
    return LocalTaskSyncStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => LocalTaskSyncStatus.pending,
    );
  }
}
