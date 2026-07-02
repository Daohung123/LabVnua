import 'package:aqedu/features/chat/services/chat_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('generateConversationId', () {
    test('sorts student identifiers for stable conversation ids', () {
      expect(generateConversationId('SV002', 'SV001'), 'SV001_SV002');
    });

    test('rejects empty participants', () {
      expect(
        () => generateConversationId('', 'SV001'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
