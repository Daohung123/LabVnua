import 'package:supabase_flutter/supabase_flutter.dart';

import '../../constants/api/supabase_key.dart';

class SupabaseConfig {
  static Future<bool>? _initialization;
  static bool _isInitialized = false;

  static bool get isConfigured => SupabaseKey.isConfigured;

  static bool get isInitialized => _isInitialized;

  /// Initializes Supabase only when the optional chat configuration exists.
  ///
  /// Returning `false` means that chat is unavailable because the required
  /// Dart defines were not supplied. Other app features can still run.
  static Future<bool> init() {
    if (_isInitialized) {
      return Future<bool>.value(true);
    }

    if (!isConfigured) {
      return Future<bool>.value(false);
    }

    return _initialization ??= _initialize();
  }

  static Future<bool> _initialize() async {
    try {
      await Supabase.initialize(
        url: SupabaseKey.url,
        publishableKey: SupabaseKey.anonKey,
      );
      _isInitialized = true;
      return true;
    } catch (_) {
      _initialization = null;
      rethrow;
    }
  }

  static SupabaseClient get client {
    if (!_isInitialized) {
      throw StateError(
        'Supabase chat is unavailable. Configure SUPABASE_URL and '
        'SUPABASE_ANON_KEY before using chat.',
      );
    }

    return Supabase.instance.client;
  }
}
