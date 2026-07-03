import 'package:aqedu/config/config_DB.dart';
import 'package:aqedu/features/platform/models/analytics_event.dart';
import 'package:sqflite/sqflite.dart';

class LocalAnalyticsService {
  LocalAnalyticsService({
    DataBaseConfig? dbConfig,
    AnalyticsEventValidator? validator,
  }) : _dbConfig = dbConfig ?? DataBaseConfig(),
       _validator = validator ?? AnalyticsEventValidator();

  final DataBaseConfig _dbConfig;
  final AnalyticsEventValidator _validator;

  Future<void> recordEvent({
    required String eventName,
    required String featureName,
    String role = 'anonymous',
    Map<String, String> metadata = const {},
  }) async {
    if (!_validator.isAllowedMetadata(metadata)) return;
    final now = DateTime.now();
    final event = LocalAnalyticsEvent(
      id: 'event_${now.microsecondsSinceEpoch}',
      eventName: eventName.trim(),
      featureName: featureName.trim(),
      role: role.trim().isEmpty ? 'anonymous' : role.trim(),
      metadata: metadata,
      createdAt: now,
    );
    if (event.eventName.isEmpty || event.featureName.isEmpty) return;

    final db = await _dbConfig.database;
    await db.insert(
      'analytics_events',
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }
}
