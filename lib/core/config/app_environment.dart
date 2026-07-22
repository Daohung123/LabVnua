import 'package:aqedu/core/constants/api/api_daotao.dart' as daotao_config;
import 'package:aqedu/core/constants/api/supabase_key.dart';

class AppEnvironment {
  const AppEnvironment();

  String get geminiApiKey => daotao_config.geminiApiKey;

  String get geminiModel => daotao_config.geminiModel;

  String get geminiFallbackModel => daotao_config.geminiFallbackModel;

  String get supabaseUrl => SupabaseKey.url;

  String get supabaseAnonKey => SupabaseKey.anonKey;

  bool get isSupabaseConfigured => SupabaseKey.isConfigured;
}
