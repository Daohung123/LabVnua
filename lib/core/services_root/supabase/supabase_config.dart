import 'package:supabase_flutter/supabase_flutter.dart';

import '../../constants/api/supabase_key.dart';

class SupabaseConfig {

  static Future<void> init() async {

    await Supabase.initialize(
      url: SupabaseKey.url,
      anonKey: SupabaseKey.anonKey,
    );
  }

  static SupabaseClient get client =>
      Supabase.instance.client;
}