import 'dart:convert';

import 'package:aqedu/config/config_db.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/core_service_session.dart';
import 'package:aqedu/features/home/home_view/components/home_models.dart';
import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';

class HomeShortcutService {
  HomeShortcutService({
    DataBaseConfig? dbConfig,
    SqliteServices? sessionService,
  }) : _dbConfig = dbConfig ?? DataBaseConfig(),
       _sessionService = sessionService ?? SqliteServices();

  static const String tableName = 'home_shortcuts';

  final DataBaseConfig _dbConfig;
  final SqliteServices _sessionService;

  Future<String> resolveProfileId() async {
    final session = await _sessionService.getSession();
    final rawUser = session?.user.trim();
    final source = rawUser == null || rawUser.isEmpty
        ? 'anonymous-home-profile'
        : rawUser;
    return sha256.convert(utf8.encode(source)).toString();
  }

  Future<List<HomeShortcutPreference>> loadPreferences(String profileId) async {
    final db = await _dbConfig.database;
    final rows = await db.query(
      tableName,
      where: 'profile_id = ?',
      whereArgs: [profileId],
      orderBy: 'sort_order ASC',
    );
    return rows.map(_preferenceFromMap).toList();
  }

  Future<void> savePreferences(
    String profileId,
    List<HomeShortcutPreference> preferences,
  ) async {
    final db = await _dbConfig.database;
    final batch = db.batch();
    final updatedAt = DateTime.now().toIso8601String();

    for (final preference in preferences) {
      batch.insert(tableName, {
        'profile_id': profileId,
        'shortcut_key': preference.key,
        'sort_order': preference.sortOrder,
        'enabled': preference.enabled ? 1 : 0,
        'updated_at': updatedAt,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit(noResult: true);
  }

  HomeShortcutPreference _preferenceFromMap(Map<String, Object?> row) {
    return HomeShortcutPreference(
      key: row['shortcut_key'] as String,
      sortOrder: row['sort_order'] as int? ?? 0,
      enabled: row['enabled'] == 1,
    );
  }
}
