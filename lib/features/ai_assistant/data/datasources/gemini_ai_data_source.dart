import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiAiDataSource {
  GeminiAiDataSource({
    required String apiKey,
    String modelName = 'gemini-3-flash-preview',
  }) : _apiKey = apiKey,
       _modelName = modelName;

  final String _apiKey;
  final String _modelName;
  GenerativeModel? _model;

  bool get isConfigured => _apiKey.isNotEmpty;

  Future<String?> generateText(String prompt) async {
    final response = await _configuredModel.generateContent([
      Content.text(prompt),
    ]);
    return response.text?.trim();
  }

  GenerativeModel get _configuredModel {
    return _model ??= GenerativeModel(model: _modelName, apiKey: _apiKey);
  }
}
