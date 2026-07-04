abstract class AnalyticsRepository {
  Future<void> recordEvent({
    required String eventName,
    required String featureName,
    String role = 'anonymous',
    Map<String, String> metadata = const {},
  });
}
