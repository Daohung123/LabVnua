import 'package:aqedu/features/ai_assistant/domain/entities/ai_turn.dart';
import 'package:aqedu/features/ai_assistant/domain/repositories/ai_assistant_repository.dart';

class AskAiAssistant {
  AskAiAssistant(this._repository);

  final AiAssistantRepository _repository;

  Future<AiTurnResult> call(String prompt, {required String sessionId}) {
    return _repository.ask(prompt, sessionId: sessionId);
  }
}
