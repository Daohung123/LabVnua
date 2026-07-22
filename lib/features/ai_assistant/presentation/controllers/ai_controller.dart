import 'package:aqedu/features/ai_assistant/domain/entities/ai_turn.dart';
import 'package:aqedu/features/ai_assistant/domain/usecases/ask_ai_assistant.dart';

class AiController {
  AiController({required AskAiAssistant askAiAssistant})
    : _askAiAssistant = askAiAssistant;

  final AskAiAssistant _askAiAssistant;

  Future<AiTurnResult> ask(String prompt, {required String sessionId}) {
    return _askAiAssistant(prompt, sessionId: sessionId);
  }
}
