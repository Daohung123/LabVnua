import 'package:aqedu/features/ai_assistant/domain/services/speech_output.dart';
import 'package:flutter_tts/flutter_tts.dart';

class FlutterTtsGateway implements SpeechOutput {
  FlutterTtsGateway({FlutterTts? flutterTts})
    : _flutterTts = flutterTts ?? FlutterTts();

  final FlutterTts _flutterTts;
  bool _configured = false;

  @override
  Future<void> speak(String text) async {
    final normalized = text.trim();
    if (normalized.isEmpty) return;
    await _configureVietnameseVoice();
    await _flutterTts.awaitSpeakCompletion(true);
    final result = await _flutterTts.speak(normalized);
    if (result != 1) {
      throw StateError('Thiết bị không thể đọc phản hồi tiếng Việt.');
    }
  }

  @override
  Future<void> stop() => _flutterTts.stop();

  Future<void> _configureVietnameseVoice() async {
    if (_configured) return;
    final available = await _flutterTts.isLanguageAvailable('vi-VN');
    if (available != true) {
      throw StateError('Thiết bị chưa cài giọng đọc tiếng Việt.');
    }
    await _flutterTts.setLanguage('vi-VN');
    await _flutterTts.setSpeechRate(0.48);
    _configured = true;
  }
}
