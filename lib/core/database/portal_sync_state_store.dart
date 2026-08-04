import 'package:aqedu/config/config_db.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class PortalSyncState {
  const PortalSyncState({
    required this.manifestVersion,
    this.lastAttemptedAt,
    this.lastCompletedAt,
    this.lastFailedResource,
  });

  final int manifestVersion;
  final DateTime? lastAttemptedAt;
  final DateTime? lastCompletedAt;
  final String? lastFailedResource;

  bool isCompleteFor(int requiredManifestVersion) {
    return manifestVersion == requiredManifestVersion && lastCompletedAt != null;
  }
}

class PortalSyncStateStore {
  PortalSyncStateStore({DataBaseConfig? databaseConfig})
    : _databaseConfig = databaseConfig ?? DataBaseConfig();

  final DataBaseConfig _databaseConfig;

  Future<PortalSyncState> read() async {
    final db = await _databaseConfig.database;
    final ownerHash = await _databaseConfig.ownerHash;
    final rows = await db.query(
      'portal_sync_state',
      where: 'owner_hash = ?',
      whereArgs: [ownerHash],
      limit: 1,
    );
    if (rows.isEmpty) {
      return const PortalSyncState(manifestVersion: 0);
    }
    final row = rows.single;
    return PortalSyncState(
      manifestVersion: row['manifest_version'] as int? ?? 0,
      lastAttemptedAt: _readDate(row['last_attempted_at']),
      lastCompletedAt: _readDate(row['last_completed_at']),
      lastFailedResource: row['last_failed_resource'] as String?,
    );
  }

  Future<void> markAttempt() async {
    final now = DateTime.now().toIso8601String();
    await _upsertState({'last_attempted_at': now});
  }

  Future<void> markResourceResult({
    required String resourceKey,
    required bool success,
  }) async {
    final db = await _databaseConfig.database;
    final ownerHash = await _databaseConfig.ownerHash;
    final now = DateTime.now().toIso8601String();
    await db.insert('portal_resource_sync_state', {
      'owner_hash': ownerHash,
      'resource_key': resourceKey,
      'last_attempted_at': now,
      'last_completed_at': success ? now : null,
      'last_status': success ? 'success' : 'failed',
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> markComplete({required int manifestVersion}) async {
    final now = DateTime.now().toIso8601String();
    await _upsertState({
      'manifest_version': manifestVersion,
      'last_attempted_at': now,
      'last_completed_at': now,
      'last_failed_resource': null,
    });
  }

  Future<void> markIncomplete({
    required int manifestVersion,
    required String failedResource,
  }) async {
    final now = DateTime.now().toIso8601String();
    await _upsertState({
      'manifest_version': manifestVersion,
      'last_attempted_at': now,
      'last_failed_resource': failedResource,
    });
  }

  Future<void> _upsertState(Map<String, Object?> changes) async {
    final db = await _databaseConfig.database;
    final ownerHash = await _databaseConfig.ownerHash;
    final current = await db.query(
      'portal_sync_state',
      where: 'owner_hash = ?',
      whereArgs: [ownerHash],
      limit: 1,
    );
    if (current.isEmpty) {
      await db.insert('portal_sync_state', {
        'owner_hash': ownerHash,
        'manifest_version': 0,
        ...changes,
      });
      return;
    }
    await db.update(
      'portal_sync_state',
      changes,
      where: 'owner_hash = ?',
      whereArgs: [ownerHash],
    );
  }

  DateTime? _readDate(Object? value) {
    if (value is! String || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }
}
