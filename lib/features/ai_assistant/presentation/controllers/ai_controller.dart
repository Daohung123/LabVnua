import 'package:aqedu/features/ai_assistant/domain/usecases/ask_ai_assistant.dart';

class AiController {
  AiController({required AskAiAssistant askAiAssistant})
    : _askAiAssistant = askAiAssistant;

  final AskAiAssistant _askAiAssistant;

  Future<String> ask(String prompt) {
    return _askAiAssistant(prompt);
  }
}
