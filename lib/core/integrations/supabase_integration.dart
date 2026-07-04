import 'package:aqedu/core/services_root/supabase/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseIntegration {
  const SupabaseIntegration();

  bool get isConfigured => SupabaseConfig.isConfigured;

  Future<bool> init() => SupabaseConfig.init();

  SupabaseClient get client => SupabaseConfig.client;
}
