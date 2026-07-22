import 'package:aqedu/core/config/app_environment.dart';
import 'package:aqedu/features/ai_assistant/data/datasources/gemini_ai_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'optionally verifies configured Gemini can answer a harmless prompt',
    () async {
      const runLiveSmoke = bool.fromEnvironment('RUN_LIVE_GEMINI_SMOKE');
      if (!runLiveSmoke) return;

      const environment = AppEnvironment();
      const smokeTestModelDefine = String.fromEnvironment(
        'GEMINI_LIVE_TEST_MODEL',
      );
      final smokeTestModel = smokeTestModelDefine.isEmpty
          ? environment.geminiModel
          : smokeTestModelDefine;
      final gateway = GeminiAiDataSource(
        apiKey: environment.geminiApiKey,
        modelName: smokeTestModel,
      );

      expect(gateway.isConfigured, isTrue);
      final response = await gateway.generateText(
        'Hãy trả lời chào trong một câu tiếng Việt.',
      );
      expect(response, isNotEmpty);
    },
  );
}
