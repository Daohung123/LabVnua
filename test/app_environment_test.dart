import 'package:aqedu/core/config/app_environment.dart';
import 'package:aqedu/features/ai_assistant/data/datasources/gemini_ai_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('compile-time Gemini configuration flows into its datasource', () {
    const environment = AppEnvironment();
    final gateway = GeminiAiDataSource(
      apiKey: environment.geminiApiKey,
      modelName: environment.geminiModel,
    );

    expect(gateway.modelName, environment.geminiModel);
    expect(
      gateway.isConfigured,
      environment.geminiApiKey.isNotEmpty && environment.geminiModel.isNotEmpty,
    );
  });

  test('Gemini model honors the compile-time value or documented default', () {
    const environment = AppEnvironment();

    expect(
      environment.geminiModel,
      const String.fromEnvironment(
        'GEMINI_MODEL',
        defaultValue: 'gemini-3.5-flash',
      ),
    );
  });

  test('can safely verify a local .env was compiled into a run', () {
    const requireGeminiConfiguration = bool.fromEnvironment(
      'ASSERT_GEMINI_CONFIGURED',
    );
    if (!requireGeminiConfiguration) return;

    const environment = AppEnvironment();
    expect(environment.geminiApiKey, isNotEmpty);
    expect(environment.geminiModel, isNotEmpty);
  });
}
