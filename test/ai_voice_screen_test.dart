import 'dart:async';

import 'package:aqedu/features/ai_assistant/domain/entities/ai_turn.dart';
import 'package:aqedu/features/ai_assistant/domain/services/speech_input.dart';
import 'package:aqedu/features/ai_assistant/domain/services/speech_output.dart';
import 'package:aqedu/features/ai_assistant/presentation/screens/ai_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('voice action waits for TTS completion', (tester) async {
    final speechOutput = _ControlledSpeechOutput();
    final actions = <AiNavigationAction>[];
    await tester.pumpWidget(
      MaterialApp(
        home: AIChatScreen(
          speechInput: _FinalTranscriptInput('Mở lịch'),
          speechOutput: speechOutput,
          onNavigate: actions.add,
          askHandler: _navigationAnswer,
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('ai-page-mic')));
    await tester.pump();
    expect(find.text('Mở lịch'), findsOneWidget);
    expect(actions, isEmpty);
    expect(find.byKey(const Key('ai-safe-navigation')), findsNothing);

    speechOutput.complete();
    await tester.pump();
    expect(actions.single.target, AiNavigationTarget.schedule);
  });

  testWidgets('TTS failure exposes a safe manual navigation action', (
    tester,
  ) async {
    final actions = <AiNavigationAction>[];
    await tester.pumpWidget(
      MaterialApp(
        home: AIChatScreen(
          speechInput: _FinalTranscriptInput('Mở lịch'),
          speechOutput: _FailingSpeechOutput(),
          onNavigate: actions.add,
          askHandler: _navigationAnswer,
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('ai-page-mic')));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(actions, isEmpty);
    await tester.tap(find.byKey(const Key('ai-safe-navigation')));
    expect(actions.single.target, AiNavigationTarget.schedule);
  });

  testWidgets('STT error is visible and does not leave the UI listening', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AIChatScreen(
          speechInput: _FailingSpeechInput(),
          speechOutput: _FailingSpeechOutput(),
          askHandler: _navigationAnswer,
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('ai-page-mic')));
    await tester.pumpAndSettle();

    expect(find.text('Bạn chưa cấp quyền microphone.'), findsOneWidget);
    expect(find.byIcon(Icons.mic_none_rounded), findsOneWidget);
  });

  testWidgets('manual stop submits the latest partial transcript once', (
    tester,
  ) async {
    var requestCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: AIChatScreen(
          speechInput: _PartialTranscriptInput('Xem điểm'),
          speechOutput: _NoopSpeechOutput(),
          askHandler: (prompt, {required sessionId}) async {
            requestCount++;
            return const AiTurnResult(
              intent: AiIntent(taskKind: AiTaskKind.noSqlite),
              answerText: 'Đã nhận yêu cầu.',
              spokenText: 'Đã nhận yêu cầu.',
            );
          },
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('ai-page-mic')));
    await tester.pump();
    expect(
      tester
          .widget<TextField>(find.byKey(const Key('ai-page-input')))
          .controller!
          .text,
      'Xem điểm',
    );
    await tester.tap(find.byKey(const Key('ai-page-mic')));
    await tester.pumpAndSettle();

    expect(requestCount, 1);
    expect(find.text('Xem điểm'), findsOneWidget);
    expect(find.text('Đã nhận yêu cầu.'), findsOneWidget);
  });

  testWidgets('manual stop without a transcript shows a retry state', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AIChatScreen(
          speechInput: _NoTranscriptInput(),
          speechOutput: _NoopSpeechOutput(),
          askHandler: _navigationAnswer,
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('ai-page-mic')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('ai-page-mic')));
    await tester.pumpAndSettle();

    expect(
      find.text('Chưa nhận được văn bản. Vui lòng thử lại.'),
      findsOneWidget,
    );
  });

  testWidgets('AI failure renders an error bubble and clears loading', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AIChatScreen(
          speechInput: _NoTranscriptInput(),
          speechOutput: _NoopSpeechOutput(),
          askHandler: (_, {required sessionId}) =>
              Future<AiTurnResult>.error(StateError('network failure')),
        ),
      ),
    );

    await tester.enterText(find.byKey(const Key('ai-page-input')), 'Xin chào');
    await tester.tap(find.byKey(const Key('ai-page-send')));
    await tester.pumpAndSettle();

    expect(
      find.text('Không thể nhận phản hồi từ AI. Vui lòng thử lại.'),
      findsNWidgets(2),
    );
    expect(find.byKey(const Key('ai-voice-status')), findsOneWidget);
    expect(find.text('AI đang trả lời...'), findsNothing);
    expect(
      tester.widget<TextField>(find.byKey(const Key('ai-page-input'))).enabled,
      isTrue,
    );
  });

  testWidgets('disposing the AI screen cancels input and stops output', (
    tester,
  ) async {
    final speechInput = _TrackingSpeechInput();
    final speechOutput = _TrackingSpeechOutput();
    await tester.pumpWidget(
      MaterialApp(
        home: AIChatScreen(
          speechInput: speechInput,
          speechOutput: speechOutput,
          askHandler: _navigationAnswer,
        ),
      ),
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();

    expect(speechInput.cancelled, isTrue);
    expect(speechOutput.stopped, isTrue);
  });
}

Future<AiTurnResult> _navigationAnswer(
  String _, {
  required String sessionId,
}) async => const AiTurnResult(
  intent: AiIntent(
    taskKind: AiTaskKind.navigate,
    navigationAction: AiNavigationAction(target: AiNavigationTarget.schedule),
  ),
  answerText: 'Tôi sẽ mở lịch.',
  spokenText: 'Tôi sẽ mở lịch.',
  action: AiNavigationAction(target: AiNavigationTarget.schedule),
);

class _FinalTranscriptInput implements SpeechInput {
  _FinalTranscriptInput(this.text);
  final String text;
  @override
  Future<void> cancel() async {}
  @override
  Future<void> start({
    required void Function(SpeechTranscript) onTranscript,
    void Function(SpeechInputStatus status)? onStatus,
    void Function(SpeechInputFailure failure)? onError,
  }) async {
    onTranscript(SpeechTranscript(text: text, isFinal: true));
  }

  @override
  Future<void> stop() async {}
}

class _FailingSpeechInput implements SpeechInput {
  @override
  Future<void> cancel() async {}

  @override
  Future<void> start({
    required void Function(SpeechTranscript) onTranscript,
    void Function(SpeechInputStatus status)? onStatus,
    void Function(SpeechInputFailure failure)? onError,
  }) async {
    onError?.call(
      const SpeechInputFailure(
        code: 'error_permission',
        message: 'Bạn chưa cấp quyền microphone.',
      ),
    );
  }

  @override
  Future<void> stop() async {}
}

class _PartialTranscriptInput implements SpeechInput {
  _PartialTranscriptInput(this.text);
  final String text;

  @override
  Future<void> cancel() async {}

  @override
  Future<void> start({
    required void Function(SpeechTranscript) onTranscript,
    void Function(SpeechInputStatus status)? onStatus,
    void Function(SpeechInputFailure failure)? onError,
  }) async {
    onTranscript(SpeechTranscript(text: text, isFinal: false));
  }

  @override
  Future<void> stop() async {}
}

class _NoTranscriptInput implements SpeechInput {
  @override
  Future<void> cancel() async {}

  @override
  Future<void> start({
    required void Function(SpeechTranscript) onTranscript,
    void Function(SpeechInputStatus status)? onStatus,
    void Function(SpeechInputFailure failure)? onError,
  }) async {
    onStatus?.call(SpeechInputStatus.listening);
  }

  @override
  Future<void> stop() async {}
}

class _TrackingSpeechInput extends _NoTranscriptInput {
  bool cancelled = false;

  @override
  Future<void> cancel() async {
    cancelled = true;
  }
}

class _ControlledSpeechOutput implements SpeechOutput {
  final _completer = Completer<void>();
  @override
  Future<void> speak(String text) => _completer.future;
  @override
  Future<void> stop() async {}
  void complete() => _completer.complete();
}

class _FailingSpeechOutput implements SpeechOutput {
  @override
  Future<void> speak(String text) =>
      Future<void>.error(StateError('tts unavailable'));
  @override
  Future<void> stop() async {}
}

class _NoopSpeechOutput implements SpeechOutput {
  @override
  Future<void> speak(String text) async {}

  @override
  Future<void> stop() async {}
}

class _TrackingSpeechOutput extends _NoopSpeechOutput {
  bool stopped = false;

  @override
  Future<void> stop() async {
    stopped = true;
  }
}
