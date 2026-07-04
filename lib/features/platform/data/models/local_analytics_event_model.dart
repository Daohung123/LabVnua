import 'dart:convert';

import 'package:aqedu/features/platform/domain/entities/local_analytics_event.dart';

class LocalAnalyticsEventModel {
  const LocalAnalyticsEventModel._();

  static LocalAnalyticsEvent fromMap(Map<String, Object?> map) {
    return LocalAnalyticsEvent(
      id: _asString(map['id']),
      eventName: _asString(map['event_name']),
      featureName: _asString(map['feature_name']),
      role: _asString(map['role'], fallback: 'anonymous'),
      metadata: _parseMetadata(map['metadata']),
      createdAt:
          DateTime.tryParse(_asString(map['created_at'])) ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  static Map<String, Object?> toMap(LocalAnalyticsEvent event) {
    return {
      'id': event.id,
      'event_name': event.eventName,
      'feature_name': event.featureName,
      'role': event.role,
      'metadata': jsonEncode(event.metadata),
      'created_at': event.createdAt.toIso8601String(),
    };
  }

  static String _asString(Object? value, {String fallback = ''}) {
    if (value == null) return fallback;
    return value.toString();
  }

  static Map<String, String> _parseMetadata(Object? value) {
    if (value == null) return const {};
    try {
      final decoded = jsonDecode(value.toString());
      if (decoded is! Map) return const {};
      return decoded.map(
        (key, value) => MapEntry(key.toString(), value?.toString() ?? ''),
      );
    } catch (_) {
      return const {};
    }
  }
}
