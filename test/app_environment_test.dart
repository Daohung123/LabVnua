import 'package:aqedu/core/config/app_environment.dart';
import 'package:aqedu/features/ai_assistant/data/datasources/gemini_ai_data_source.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(dotenv.clean);
  tearDown(dotenv.clean);

  test('runtime dotenv Gemini configuration flows into its datasource', () {
    dotenv.loadFromString(
      envString: [
        'GEMINI_API_KEY=test-key',
        'GEMINI_MODEL=test-model',
        'GEMINI_FALLBACK_MODEL=test-fallback-model',
        'SUPABASE_URL=https://example.supabase.co',
        'SUPABASE_ANON_KEY=test-anon-key',
      ].join('\n'),
    );

    const environment = AppEnvironment();
    final gateway = GeminiAiDataSource(
      apiKey: environment.geminiApiKey,
      modelName: environment.geminiModel,
    );

    expect(environment.geminiApiKey, 'test-key');
    expect(gateway.modelName, 'test-model');
    expect(environment.geminiFallbackModel, 'test-fallback-model');
    expect(environment.supabaseUrl, 'https://example.supabase.co');
    expect(environment.supabaseAnonKey, 'test-anon-key');
    expect(environment.isSupabaseConfigured, isTrue);
    expect(gateway.isConfigured, isTrue);
  });

  test(
    'Gemini model falls back to compile-time value or documented default',
    () {
      const environment = AppEnvironment();

      expect(
        environment.geminiModel,
        const String.fromEnvironment(
          'GEMINI_MODEL',
          defaultValue: 'gemini-3.5-flash',
        ),
      );
    },
  );

  test(
    'can safely verify a local .env or dart define configures Gemini',
    () async {
      const requireGeminiConfiguration = bool.fromEnvironment(
        'ASSERT_GEMINI_CONFIGURED',
      );
      if (!requireGeminiConfiguration) return;

      await dotenv.load(fileName: '.env', isOptional: true);
      const environment = AppEnvironment();
      expect(environment.geminiApiKey, isNotEmpty);
      expect(environment.geminiModel, isNotEmpty);
    },
  );
}
