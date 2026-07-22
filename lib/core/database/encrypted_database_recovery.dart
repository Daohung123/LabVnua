import 'dart:io';

/// Preserves an encrypted database that cannot be opened instead of deleting it.
///
/// A database without its matching secure-storage key cannot be read safely. The
/// caller can create a fresh cache after this method succeeds; the original and
/// its SQLite sidecars remain in the application's private database directory.
class EncryptedDatabaseRecovery {
  EncryptedDatabaseRecovery({DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final DateTime Function() _now;

  Future<bool> quarantineUnreadableDatabase(String databasePath) async {
    final databaseFile = File(databasePath);
    if (!await databaseFile.exists()) return false;

    final suffix = _now().toUtc().microsecondsSinceEpoch;
    final quarantinePath = '$databasePath.unavailable-$suffix';

    // Move sidecars first. The main file is moved last so a failed move never
    // leaves the application treating the original database as absent.
    for (final sidecar in const ['-wal', '-shm', '-journal']) {
      final source = File('$databasePath$sidecar');
      if (await source.exists()) {
        await source.rename('$quarantinePath$sidecar');
      }
    }
    await databaseFile.rename(quarantinePath);
    return true;
  }
}
