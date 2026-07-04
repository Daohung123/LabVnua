import 'package:aqedu/core/database/app_database.dart';
import 'package:aqedu/features/platform/data/models/local_analytics_event_model.dart';
import 'package:aqedu/features/platform/domain/entities/local_analytics_event.dart';
import 'package:sqflite/sqflite.dart';

class LocalAnalyticsDataSource {
  LocalAnalyticsDataSource({AppDatabase? database})
    : _database = database ?? AppDatabase();

  final AppDatabase _database;

  Future<void> insert(LocalAnalyticsEvent event) async {
    final db = await _database.instance;
    await db.insert(
      'analytics_events',
      LocalAnalyticsEventModel.toMap(event),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }
}
