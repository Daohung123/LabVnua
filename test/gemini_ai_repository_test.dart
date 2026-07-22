import 'dart:async';
import 'dart:convert';

import 'package:aqedu/features/ai_assistant/data/datasources/ai_context_local_data_source.dart';
import 'package:aqedu/features/ai_assistant/data/datasources/ai_session_turn_local_data_source.dart';
import 'package:aqedu/features/ai_assistant/data/datasources/gemini_ai_data_source.dart';
import 'package:aqedu/features/ai_assistant/data/repositories/gemini_ai_assistant_repository.dart';
import 'package:aqedu/features/ai_assistant/domain/entities/ai_turn.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test(
    'missing Gemini configuration returns an actionable Vietnamese reply',
    () async {
      final repository = GeminiAiAssistantRepository(
        geminiDataSource: _FakeGateway(configured: false),
        contextDataSource: _FakeContext(),
        sessionTurnDataSource: _FakeTurnStore(),
      );

      final result = await repository.ask('Xin chào', sessionId: 's1');

      expect(result.answerText, contains('GEMINI_API_KEY'));
    },
  );

  test(
    'classification failure falls back locally and still generates an answer',
    () async {
      final repository = GeminiAiAssistantRepository(
        geminiDataSource: _FakeGateway(
          outcomes: [
            const AiGatewayException(AiGatewayFailureKind.timeout),
            '{"answer_text":"Bạn có thể học theo từng phần nhỏ.","spoken_text":"Bạn có thể học theo từng phần nhỏ.","action":null}',
          ],
        ),
        contextDataSource: _FakeContext(),
        sessionTurnDataSource: _FakeTurnStore(),
      );

      final result = await repository.ask('Gợi ý cách học', sessionId: 's1');

      expect(result.intent.taskKind, AiTaskKind.noSqlite);
      expect(result.answerText, 'Bạn có thể học theo từng phần nhỏ.');
    },
  );

  test(
    'gateway reports missing key or model as configuration failure',
    () async {
      final gateway = GeminiAiDataSource(apiKey: '', modelName: '');

      await expectLater(
        gateway.generateText('ignored'),
        throwsA(
          isA<AiGatewayException>().having(
            (error) => error.kind,
            'kind',
            AiGatewayFailureKind.configuration,
          ),
        ),
      );
    },
  );

  test('Gemini REST gateway extracts only generated text', () async {
    final gateway = GeminiAiDataSource(
      apiKey: 'test-key',
      modelName: 'gemini-3.5-flash',
      httpClient: MockClient((_) async {
        return http.Response.bytes(
          utf8.encode(
            '{"candidates":[{"content":{"parts":[{"text":"Xin chào"},{"text":"bạn nhé."}]}}]}',
          ),
          200,
          headers: const {'content-type': 'application/json; charset=utf-8'},
        );
      }),
    );

    expect(await gateway.generateText('prompt'), 'Xin chào\nbạn nhé.');
  });

  test('Gemini REST gateway reports an unavailable model safely', () async {
    final gateway = GeminiAiDataSource(
      apiKey: 'test-key',
      modelName: 'unavailable-model',
      httpClient: MockClient(
        (_) async =>
            http.Response('{"error":{"message":"Model unavailable"}}', 404),
      ),
    );

    await expectLater(
      gateway.generateText('prompt'),
      throwsA(
        isA<AiGatewayException>().having(
          (error) => error.kind,
          'kind',
          AiGatewayFailureKind.modelUnavailable,
        ),
      ),
    );
  });

  test(
    'Gemini retries a temporary primary-model outage with its fallback',
    () async {
      final requestedModels = <String>[];
      final gateway = GeminiAiDataSource(
        apiKey: 'test-key',
        modelName: 'gemini-3.5-flash',
        fallbackModelName: 'gemini-2.5-flash',
        httpClient: MockClient((request) async {
          requestedModels.add(request.url.path);
          if (request.url.path.contains('gemini-3.5-flash')) {
            return http.Response(
              '{"error":{"message":"Temporarily unavailable"}}',
              503,
            );
          }
          return http.Response(
            '{"candidates":[{"content":{"parts":[{"text":"Xin chao"}]}}]}',
            200,
          );
        }),
      );

      expect(await gateway.generateText('prompt'), 'Xin chao');
      expect(requestedModels, [
        contains('gemini-3.5-flash'),
        contains('gemini-2.5-flash'),
      ]);
    },
  );

  test(
    'response timeout returns a Vietnamese error instead of loading forever',
    () async {
      final repository = GeminiAiAssistantRepository(
        geminiDataSource: _HangingGateway(),
        contextDataSource: _FakeContext(),
        sessionTurnDataSource: _FakeTurnStore(),
        requestTimeout: const Duration(milliseconds: 1),
      );

      final result = await repository.ask('Xin chào', sessionId: 's1');

      expect(result.answerText, contains('phản hồi quá lâu'));
    },
  );

  test('generation service error returns a safe Vietnamese reply', () async {
    final repository = GeminiAiAssistantRepository(
      geminiDataSource: _FakeGateway(
        outcomes: [
          '{"task":"noSqlite","context_keys":[],"target":null}',
          const AiGatewayException(AiGatewayFailureKind.service),
        ],
      ),
      contextDataSource: _FakeContext(),
      sessionTurnDataSource: _FakeTurnStore(),
    );

    final result = await repository.ask('Xin chào', sessionId: 's1');

    expect(result.answerText, contains('Không thể kết nối'));
    expect(result.answerText, isNot(contains('AiGatewayException')));
  });
}

class _FakeGateway implements AiTextGateway {
  _FakeGateway({this.configured = true, List<Object>? outcomes})
    : _outcomes = outcomes ?? const [];

  final bool configured;
  final List<Object> _outcomes;
  int _index = 0;

  @override
  bool get isConfigured => configured;

  @override
  String get modelName => 'test-model';

  @override
  Future<String?> generateText(String prompt) async {
    final outcome = _outcomes[_index++];
    if (outcome is Exception) throw outcome;
    return outcome as String;
  }
}

class _FakeContext extends AiContextLocalDataSource {
  @override
  Future<String> buildContext(AiContextRequest request) async => 'context test';
}

class _HangingGateway implements AiTextGateway {
  @override
  bool get isConfigured => true;

  @override
  String get modelName => 'test-model';

  @override
  Future<String?> generateText(String prompt) => Completer<String?>().future;
}

class _FakeTurnStore extends AiSessionTurnLocalDataSource {
  @override
  Future<void> save({
    required String sessionId,
    required String userText,
    required AiTurnResult turn,
  }) async {}
}
