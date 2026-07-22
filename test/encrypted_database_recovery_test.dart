import 'dart:io';

import 'package:aqedu/core/database/encrypted_database_recovery.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('quarantines an unreadable database and its SQLite sidecars', () async {
    final directory = await Directory.systemTemp.createTemp(
      'aqedu-encrypted-db-recovery-',
    );
    addTearDown(() => directory.delete(recursive: true));

    final databasePath = '${directory.path}${Platform.pathSeparator}cache.db';
    await File(databasePath).writeAsString('encrypted-content');
    await File('$databasePath-wal').writeAsString('wal-content');
    await File('$databasePath-shm').writeAsString('shm-content');

    final recovery = EncryptedDatabaseRecovery(
      now: () => DateTime.utc(2026, 7, 22, 22),
    );

    expect(await recovery.quarantineUnreadableDatabase(databasePath), isTrue);

    const suffix = '.unavailable-1784757600000000';
    expect(await File(databasePath).exists(), isFalse);
    expect(
      await File('$databasePath$suffix').readAsString(),
      'encrypted-content',
    );
    expect(
      await File('$databasePath$suffix-wal').readAsString(),
      'wal-content',
    );
    expect(
      await File('$databasePath$suffix-shm').readAsString(),
      'shm-content',
    );
  });

  test('does nothing when the database file does not exist', () async {
    final directory = await Directory.systemTemp.createTemp(
      'aqedu-encrypted-db-recovery-',
    );
    addTearDown(() => directory.delete(recursive: true));

    final databasePath = '${directory.path}${Platform.pathSeparator}missing.db';

    expect(
      await EncryptedDatabaseRecovery().quarantineUnreadableDatabase(
        databasePath,
      ),
      isFalse,
    );
  });
}
