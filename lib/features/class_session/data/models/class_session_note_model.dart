import 'package:aqedu/features/class_session/domain/entities/class_session_note.dart';

class ClassSessionNoteModel {
  const ClassSessionNoteModel._();

  static ClassSessionNote fromMap(Map<String, Object?> map) {
    return ClassSessionNote(
      id: _asString(map['id']),
      sessionKey: _asString(map['session_key']),
      ownerHash: _asString(map['owner_hash']),
      content: _asString(map['content']),
      syncStatus: ClassSessionNoteSyncStatus.values.firstWhere(
        (status) => status.name == map['sync_status'],
        orElse: () => ClassSessionNoteSyncStatus.pending,
      ),
      createdAt:
          DateTime.tryParse(_asString(map['created_at'])) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt:
          DateTime.tryParse(_asString(map['updated_at'])) ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  static Map<String, Object?> toMap(ClassSessionNote note) {
    return {
      'id': note.id,
      'session_key': note.sessionKey,
      'owner_hash': note.ownerHash,
      'content': note.content,
      'sync_status': note.syncStatus.name,
      'created_at': note.createdAt.toIso8601String(),
      'updated_at': note.updatedAt.toIso8601String(),
    };
  }

  static String _asString(Object? value) {
    if (value == null) return '';
    return value.toString();
  }
}
