import 'dart:convert';

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

  factory LocalAnalyticsEvent.fromMap(Map<String, Object?> map) {
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

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'event_name': eventName,
      'feature_name': featureName,
      'role': role,
      'metadata': jsonEncode(metadata),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class AnalyticsEventValidator {
  static const _blockedKeys = {
    'token',
    'cookie',
    'password',
    'pass',
    'authorization',
    'email',
    'phone',
    'student_id',
    'ma_sv',
    'user',
  };

  bool isAllowedMetadata(Map<String, String> metadata) {
    for (final entry in metadata.entries) {
      final key = entry.key.toLowerCase();
      if (_blockedKeys.any(key.contains)) return false;
      if (_looksSensitive(entry.value)) return false;
    }
    return true;
  }

  bool _looksSensitive(String value) {
    final lower = value.toLowerCase();
    if (lower.contains('bearer ') || lower.contains('xsrf-')) return true;
    if (RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    ).hasMatch(value)) {
      return true;
    }
    return false;
  }
}

String _asString(Object? value, {String fallback = ''}) {
  if (value == null) return fallback;
  return value.toString();
}

Map<String, String> _parseMetadata(Object? value) {
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
