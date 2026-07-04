import 'package:aqedu/features/platform/data/datasources/local_analytics_data_source.dart';
import 'package:aqedu/features/platform/domain/entities/local_analytics_event.dart';
import 'package:aqedu/features/platform/domain/repositories/analytics_repository.dart';
import 'package:aqedu/features/platform/domain/services/analytics_event_validator.dart';

class LocalAnalyticsRepository implements AnalyticsRepository {
  LocalAnalyticsRepository({
    LocalAnalyticsDataSource? localDataSource,
    AnalyticsEventValidator? validator,
  }) : _localDataSource = localDataSource ?? LocalAnalyticsDataSource(),
       _validator = validator ?? AnalyticsEventValidator();

  final LocalAnalyticsDataSource _localDataSource;
  final AnalyticsEventValidator _validator;

  @override
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

    await _localDataSource.insert(event);
  }
}
