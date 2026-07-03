import 'dart:convert';

import 'package:aqedu/config/config_DB.dart';
import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';

class ApiResponseCacheService {
  ApiResponseCacheService({DataBaseConfig? dbConfig})
    : _dbConfig = dbConfig ?? DataBaseConfig();

  static const String tableName = 'api_response_cache';

  final DataBaseConfig _dbConfig;

  Future<void> saveResponse({
    required String method,
    required String path,
    required Object? requestBody,
    required String responseBody,
    required int responseStatus,
    required String sourceUrl,
  }) async {
    final db = await _dbConfig.database;
    final normalizedMethod = method.toUpperCase();
    final normalizedRequest = encodeRequestBody(requestBody);
    final requestHash = hashRequestBody(requestBody);
    final now = DateTime.now().toIso8601String();

    await db.insert(tableName, {
      'id': cacheId(
        method: normalizedMethod,
        path: path,
        requestBody: requestBody,
      ),
      'method': normalizedMethod,
      'path': path,
      'request_hash': requestHash,
      'request_body': normalizedRequest,
      'response_body': responseBody,
      'response_status': responseStatus,
      'source_url': sourceUrl,
      'cached_at': now,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> getResponseBody({
    required String method,
    required String path,
    Object? requestBody,
  }) async {
    final db = await _dbConfig.database;
    final result = await db.query(
      tableName,
      columns: const ['response_body'],
      where: 'method = ? AND path = ? AND request_hash = ?',
      whereArgs: [method.toUpperCase(), path, hashRequestBody(requestBody)],
      orderBy: 'cached_at DESC',
      limit: 1,
    );

    if (result.isEmpty) return null;
    return result.first['response_body'] as String?;
  }

  static String cacheId({
    required String method,
    required String path,
    Object? requestBody,
  }) {
    final key = '${method.toUpperCase()}|$path|${hashRequestBody(requestBody)}';
    return sha256.convert(utf8.encode(key)).toString();
  }

  static String hashRequestBody(Object? requestBody) {
    return sha256
        .convert(utf8.encode(encodeRequestBody(requestBody)))
        .toString();
  }

  static String encodeRequestBody(Object? requestBody) {
    return jsonEncode(_normalizeJson(requestBody ?? const {}));
  }

  static Object? _normalizeJson(Object? value) {
    if (value is Map) {
      final entries = value.entries.toList()
        ..sort((a, b) => a.key.toString().compareTo(b.key.toString()));
      return {
        for (final entry in entries)
          entry.key.toString(): _normalizeJson(entry.value),
      };
    }
    if (value is Iterable) {
      return value.map(_normalizeJson).toList();
    }
    return value;
  }
}
