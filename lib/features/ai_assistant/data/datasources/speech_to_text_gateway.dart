import 'package:aqedu/core/logging/app_log.dart';
import 'package:aqedu/features/ai_assistant/domain/services/speech_input.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextGateway implements SpeechInput {
  SpeechToTextGateway({SpeechToText? speechToText})
    : _speechToText = speechToText ?? SpeechToText();

  final SpeechToText _speechToText;
  bool _initialized = false;
  bool _available = false;
  void Function(SpeechInputStatus status)? _onStatus;
  void Function(SpeechInputFailure failure)? _onError;

  @override
  Future<void> start({
    required void Function(SpeechTranscript) onTranscript,
    void Function(SpeechInputStatus status)? onStatus,
    void Function(SpeechInputFailure failure)? onError,
  }) async {
    _onStatus = onStatus;
    _onError = onError;
    await _initialize();
    if (!_available) {
      throw StateError(
        'Không thể sử dụng nhận diện giọng nói trên thiết bị này.',
      );
    }

    final locale = await _vietnameseLocale();
    if (locale == null) {
      throw StateError('Thiết bị chưa cài nhận diện giọng nói tiếng Việt.');
    }

    AppLog.ungDung(
      'Bắt đầu nhận diện giọng nói tiếng Việt',
      khuVuc: 'Trợ lý AI',
      duLieu: {'locale': locale},
    );
    await _speechToText.listen(
      onResult: (result) => onTranscript(
        SpeechTranscript(
          text: result.recognizedWords,
          isFinal: result.finalResult,
        ),
      ),
      listenOptions: SpeechListenOptions(
        localeId: locale,
        cancelOnError: true,
        listenMode: ListenMode.confirmation,
      ),
    );
  }

  @override
  Future<void> stop() => _speechToText.stop();

  @override
  Future<void> cancel() => _speechToText.cancel();

  Future<void> _initialize() async {
    if (_initialized) return;
    _available = await _speechToText.initialize(
      onError: (error) {
        AppLog.loi(
          'Nhận diện giọng nói gặp lỗi',
          khuVuc: 'Trợ lý AI',
          duLieu: {'code': error.errorMsg, 'permanent': error.permanent},
          loi: SpeechInputFailure(
            code: error.errorMsg,
            message: _friendlyError(error.errorMsg),
          ),
        );
        _onError?.call(
          SpeechInputFailure(
            code: error.errorMsg,
            message: _friendlyError(error.errorMsg),
          ),
        );
      },
      onStatus: (status) {
        final isListening = status.toLowerCase() == 'listening';
        _onStatus?.call(
          isListening ? SpeechInputStatus.listening : SpeechInputStatus.done,
        );
      },
    );
    _initialized = true;
  }

  Future<String?> _vietnameseLocale() async {
    final locales = await _speechToText.locales();
    for (final locale in locales) {
      if (locale.localeId.toLowerCase().startsWith('vi')) {
        return locale.localeId;
      }
    }
    return null;
  }

  String _friendlyError(String code) {
    if (code.contains('permission')) {
      return 'Bạn chưa cấp quyền microphone hoặc nhận diện giọng nói.';
    }
    if (code.contains('network')) {
      return 'Không thể nhận diện giọng nói do lỗi mạng.';
    }
    if (code.contains('no_match') || code.contains('speech_timeout')) {
      return 'Chưa nghe rõ giọng nói. Vui lòng thử lại.';
    }
    return 'Không thể nhận diện giọng nói tiếng Việt. Vui lòng thử lại.';
  }
}
