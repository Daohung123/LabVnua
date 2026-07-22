class SpeechTranscript {
  const SpeechTranscript({required this.text, required this.isFinal});

  final String text;
  final bool isFinal;
}

enum SpeechInputStatus { listening, done }

class SpeechInputFailure {
  const SpeechInputFailure({required this.code, required this.message});

  final String code;
  final String message;
}

abstract class SpeechInput {
  Future<void> start({
    required void Function(SpeechTranscript) onTranscript,
    void Function(SpeechInputStatus status)? onStatus,
    void Function(SpeechInputFailure failure)? onError,
  });

  Future<void> stop();

  Future<void> cancel();
}
