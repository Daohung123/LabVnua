import 'dart:convert';

import 'package:aqedu/config/config_db.dart';
import 'package:crypto/crypto.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

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
    final requestHash = _hash(_canonicalJson(requestBody ?? const {}));
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
    final Database db = await _databaseConfig.database;
    final ownerHash = await _databaseConfig.ownerHash;
    final requestHash = _hash(_canonicalJson(requestBody ?? const {}));
    final rows = await db.query(
      'api_read_snapshots',
      columns: const ['payload_json'],
      where: 'owner_hash = ? AND resource_key = ? AND request_hash = ?',
      whereArgs: [ownerHash, resourceKey, requestHash],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first['payload_json'] as String?;
  }

  static String _hash(String input) =>
      sha256.convert(utf8.encode(input)).toString();

  static String _canonicalJson(Object value) {
    Object normalize(Object value) {
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
