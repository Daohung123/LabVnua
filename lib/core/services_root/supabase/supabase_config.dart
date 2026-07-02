import 'package:supabase_flutter/supabase_flutter.dart';

import '../../constants/api/supabase_key.dart';

class SupabaseConfig {
  static Future<void> init() async {
    if (!SupabaseKey.isConfigured) {
      throw StateError(
        'Supabase is not configured. Start the app with '
        '--dart-define=SUPABASE_URL=... and '
        '--dart-define=SUPABASE_ANON_KEY=...',
      );
    }

    await Supabase.initialize(
      url: SupabaseKey.url,
      anonKey: SupabaseKey.anonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
