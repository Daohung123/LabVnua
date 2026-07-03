enum ClassSessionNoteSyncStatus { pending, synced, failed }

class ClassSessionNote {
  const ClassSessionNote({
    required this.id,
    required this.sessionKey,
    required this.ownerHash,
    required this.content,
    this.syncStatus = ClassSessionNoteSyncStatus.pending,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String sessionKey;
  final String ownerHash;
  final String content;
  final ClassSessionNoteSyncStatus syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory ClassSessionNote.fromMap(Map<String, Object?> map) {
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

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'session_key': sessionKey,
      'owner_hash': ownerHash,
      'content': content,
      'sync_status': syncStatus.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

String _asString(Object? value) {
  if (value == null) return '';
  return value.toString();
}
