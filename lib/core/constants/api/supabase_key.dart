import 'package:aqedu/core/config/app_environment.dart';

class SupabaseKey {
  static const AppEnvironment _environment = AppEnvironment();

  static String get url => _environment.supabaseUrl;

  static String get anonKey => _environment.supabaseAnonKey;

  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;
}
