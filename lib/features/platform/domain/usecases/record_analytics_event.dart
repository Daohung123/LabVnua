import 'package:aqedu/features/platform/domain/repositories/analytics_repository.dart';

class RecordAnalyticsEvent {
  RecordAnalyticsEvent(this._repository);

  final AnalyticsRepository _repository;

  Future<void> call({
    required String eventName,
    required String featureName,
    String role = 'anonymous',
    Map<String, String> metadata = const {},
  }) {
    return _repository.recordEvent(
      eventName: eventName,
      featureName: featureName,
      role: role,
      metadata: metadata,
    );
  }
}
