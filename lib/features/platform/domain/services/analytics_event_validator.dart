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
