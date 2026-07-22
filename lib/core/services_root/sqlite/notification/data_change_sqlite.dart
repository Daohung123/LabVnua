import 'package:aqedu/config/config_db.dart';
import 'package:aqedu/features/notification/models/data_change_models.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class DataChangeSqliteService {
  final DataBaseConfig _dbConfig = DataBaseConfig();

  Future<List<WatchedDataItem>> getCachedItems(WatchedDataType dataType) async {
    final db = await _dbConfig.database;
    final rows = await db.query(dataType.cacheTable);

    return rows
        .map((row) => WatchedDataItem.fromCacheMap(dataType, row))
        .toList();
  }

  Future<void> replaceCachedItems(
    WatchedDataType dataType,
    List<WatchedDataItem> items,
  ) async {
    final db = await _dbConfig.database;
    final now = DateTime.now();

    await db.transaction((txn) async {
      await txn.delete(dataType.cacheTable);

      final batch = txn.batch();
      for (final item in items) {
        batch.insert(
          dataType.cacheTable,
          item.toCacheMap(now),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  Future<bool> hasChange(String changeId) async {
    final db = await _dbConfig.database;
    final rows = await db.query(
      'notification_history',
      columns: ['change_id'],
      where: 'change_id = ?',
      whereArgs: [changeId],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

  Future<List<DataChange>> insertChanges(List<DataChange> changes) async {
    if (changes.isEmpty) return [];

    final db = await _dbConfig.database;
    final inserted = <DataChange>[];

    await db.transaction((txn) async {
      for (final change in changes) {
        final id = await txn.insert(
          'notification_history',
          change.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
        if (id > 0) inserted.add(change);
      }
    });

    return inserted;
  }

  Future<void> markNotified(String changeId) async {
    final db = await _dbConfig.database;
    await db.update(
      'notification_history',
      {'notified_at': DateTime.now().toIso8601String()},
      where: 'change_id = ?',
      whereArgs: [changeId],
    );
  }

  Future<void> markAsRead(String id) async {
    final db = await _dbConfig.database;
    await db.update(
      'notification_history',
      {'is_read': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> countUnread() async {
    final db = await _dbConfig.database;
    final result = await db.rawQuery('''
      SELECT COUNT(*) AS count
      FROM notification_history
      WHERE is_read = 0
    ''');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<DataChange>> getHistory({int limit = 100}) async {
    final db = await _dbConfig.database;
    final rows = await db.query(
      'notification_history',
      orderBy: 'created_at DESC',
      limit: limit,
    );

    return rows.map(DataChange.fromMap).toList();
  }
}
