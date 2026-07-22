import 'package:aqedu/features/ai_assistant/domain/entities/ai_turn.dart';
import 'package:aqedu/features/ai_assistant/domain/services/ai_intent_classifier.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const classifier = AiIntentClassifier();

  test('keeps only allowlisted context keys', () {
    final intent = classifier.parseOrFallback(
      '{"task":"sqlite","context_keys":["schedule","chat_messages","tokens"]}',
      'Lịch học',
    );
    expect(intent.taskKind, AiTaskKind.sqlite);
    expect(intent.contextKeys, ['schedule']);
  });

  test('rejects unknown navigation targets', () {
    final intent = classifier.parseOrFallback(
      '{"task":"navigate","target":"https://unsafe.example"}',
      'Giải thích thuật toán',
    );
    expect(intent.taskKind, AiTaskKind.noSqlite);
    expect(intent.navigationAction, isNull);
  });

  test('only parses typed navigation actions', () {
    expect(classifier.parseAction({'type': 'sql', 'target': 'scores'}), isNull);
    expect(
      classifier.parseAction({'type': 'navigate', 'target': 'scores'})?.target,
      AiNavigationTarget.scores,
    );
  });
}
