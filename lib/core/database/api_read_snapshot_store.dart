import 'dart:convert';

import 'package:aqedu/config/config_db.dart';
import 'package:crypto/crypto.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class ApiReadSnapshot {
  const ApiReadSnapshot({
    required this.resourceKey,
    required this.requestHash,
    required this.payloadJson,
    required this.payloadHash,
    required this.fetchedAt,
  });

  final String resourceKey;
  final String requestHash;
  final String payloadJson;
  final String payloadHash;
  final DateTime fetchedAt;
}

class ApiReadSnapshotStore {
  ApiReadSnapshotStore({DataBaseConfig? databaseConfig})
    : _databaseConfig = databaseConfig ?? DataBaseConfig();

  final DataBaseConfig _databaseConfig;

  Future<void> save({
    required String resourceKey,
    required Object? requestBody,
    required String payloadJson,
  }) async {
    final Database db = await _databaseConfig.database;
    final ownerHash = await _databaseConfig.ownerHash;
    final requestHash = requestHashFor(requestBody);
    await db.insert('api_read_snapshots', {
      'owner_hash': ownerHash,
      'resource_key': resourceKey,
      'request_hash': requestHash,
      'payload_json': payloadJson,
      'payload_hash': _hash(payloadJson),
      'fetched_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> read({
    required String resourceKey,
    Object? requestBody,
  }) async {
    return (await readSnapshot(
      resourceKey: resourceKey,
      requestBody: requestBody,
    ))?.payloadJson;
  }

  Future<ApiReadSnapshot?> readSnapshot({
    required String resourceKey,
    Object? requestBody,
  }) async {
    final Database db = await _databaseConfig.database;
    final ownerHash = await _databaseConfig.ownerHash;
    final requestHash = requestHashFor(requestBody);
    final rows = await db.query(
      'api_read_snapshots',
      columns: const [
        'resource_key',
        'request_hash',
        'payload_json',
        'payload_hash',
        'fetched_at',
      ],
      where: 'owner_hash = ? AND resource_key = ? AND request_hash = ?',
      whereArgs: [ownerHash, resourceKey, requestHash],
      limit: 1,
    );
    return rows.isEmpty ? null : _snapshotFromRow(rows.first);
  }

  Future<ApiReadSnapshot?> readLatest({required String resourceKey}) async {
    final Database db = await _databaseConfig.database;
    final ownerHash = await _databaseConfig.ownerHash;
    final rows = await db.query(
      'api_read_snapshots',
      columns: const [
        'resource_key',
        'request_hash',
        'payload_json',
        'payload_hash',
        'fetched_at',
      ],
      where: 'owner_hash = ? AND resource_key = ?',
      whereArgs: [ownerHash, resourceKey],
      orderBy: 'fetched_at DESC',
      limit: 1,
    );
    return rows.isEmpty ? null : _snapshotFromRow(rows.first);
  }

  ApiReadSnapshot _snapshotFromRow(Map<String, Object?> row) {
    return ApiReadSnapshot(
      resourceKey: row['resource_key']! as String,
      requestHash: row['request_hash']! as String,
      payloadJson: row['payload_json']! as String,
      payloadHash: row['payload_hash']! as String,
      fetchedAt: DateTime.parse(row['fetched_at']! as String),
    );
  }

  static String _hash(String input) =>
      sha256.convert(utf8.encode(input)).toString();

  static String requestHashFor(Object? requestBody) {
    return _hash(_canonicalJson(requestBody ?? const {}));
  }

  static String _canonicalJson(Object? value) {
    Object? normalize(Object? value) {
      if (value == null) return null;
      if (value is Map) {
        final entries = value.entries.toList()
          ..sort(
            (left, right) =>
                left.key.toString().compareTo(right.key.toString()),
          );
        return {
          for (final entry in entries)
            entry.key.toString(): normalize(entry.value),
        };
      }
      if (value is Iterable) {
        return value.map((item) => normalize(item)).toList();
      }
      return value;
    }

    return jsonEncode(normalize(value));
  }
}
