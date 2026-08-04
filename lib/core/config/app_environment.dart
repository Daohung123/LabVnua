import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnvironment {
  const AppEnvironment();

  static const _geminiApiKeyDefine = String.fromEnvironment('GEMINI_API_KEY');
  static const _geminiModelDefine = String.fromEnvironment(
    'GEMINI_MODEL',
    defaultValue: 'gemini-3.5-flash',
  );
  static const _geminiFallbackModelDefine = String.fromEnvironment(
    'GEMINI_FALLBACK_MODEL',
    defaultValue: 'gemini-2.5-flash',
  );
  static const _supabaseUrlDefine = String.fromEnvironment('SUPABASE_URL');
  static const _supabaseAnonKeyDefine = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
  );

  String get geminiApiKey => _value('GEMINI_API_KEY', _geminiApiKeyDefine);

  String get geminiModel => _value('GEMINI_MODEL', _geminiModelDefine);

  String get geminiFallbackModel =>
      _value('GEMINI_FALLBACK_MODEL', _geminiFallbackModelDefine);

  String get supabaseUrl => _value('SUPABASE_URL', _supabaseUrlDefine);

  String get supabaseAnonKey =>
      _value('SUPABASE_ANON_KEY', _supabaseAnonKeyDefine);

  bool get isSupabaseConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  String _value(String key, String fallback) {
    if (!dotenv.isInitialized) return fallback;
    final runtimeValue = dotenv.maybeGet(key)?.trim();
    if (runtimeValue != null && runtimeValue.isNotEmpty) {
      return runtimeValue;
    }
    return fallback;
  }
}
