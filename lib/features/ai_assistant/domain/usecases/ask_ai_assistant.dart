import 'package:aqedu/features/ai_assistant/domain/repositories/ai_assistant_repository.dart';

class AskAiAssistant {
  AskAiAssistant(this._repository);

  final AiAssistantRepository _repository;

  Future<String> call(String prompt) {
    return _repository.ask(prompt);
  }
}
