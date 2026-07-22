import 'package:aqedu/features/ai_assistant/domain/entities/ai_turn.dart';

abstract class AiAssistantRepository {
  Future<AiTurnResult> ask(String prompt, {required String sessionId});
}
