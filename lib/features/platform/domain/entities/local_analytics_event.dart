class LocalAnalyticsEvent {
  const LocalAnalyticsEvent({
    required this.id,
    required this.eventName,
    required this.featureName,
    this.role = 'anonymous',
    this.metadata = const {},
    required this.createdAt,
  });

  final String id;
  final String eventName;
  final String featureName;
  final String role;
  final Map<String, String> metadata;
  final DateTime createdAt;
}
