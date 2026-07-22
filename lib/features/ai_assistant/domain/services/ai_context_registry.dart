import 'package:aqedu/features/ai_assistant/domain/entities/ai_turn.dart';

class AiContextRegistry {
  const AiContextRegistry();

  static const allowedKeys = {
    'schedule',
    'notifications',
    'scores',
    'tuition',
    'tasks',
  };

  List<String> allowedFor(AiContextRequest request) {
    if (request.intent.taskKind != AiTaskKind.sqlite) return const [];
    return request.intent.contextKeys
        .where(allowedKeys.contains)
        .toList(growable: false);
  }
}
