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
}
