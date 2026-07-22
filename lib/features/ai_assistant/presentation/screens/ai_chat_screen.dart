import 'dart:async';

import 'package:aqedu/core/di/app_dependencies.dart';
import 'package:aqedu/core/logging/app_log.dart';
import 'package:aqedu/features/ai_assistant/domain/entities/ai_turn.dart';
import 'package:aqedu/features/ai_assistant/domain/services/speech_input.dart';
import 'package:aqedu/features/ai_assistant/domain/services/speech_output.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef AiAskHandler =
    Future<AiTurnResult> Function(String prompt, {required String sessionId});

enum _AiVoiceState {
  idle,
  listening,
  transcribing,
  processing,
  speaking,
  executing,
  error,
}

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({
    super.key,
    this.askHandler,
    this.speechInput,
    this.speechOutput,
    this.voiceStartRequests,
    this.onNavigate,
  });

  final AiAskHandler? askHandler;
  final SpeechInput? speechInput;
  final SpeechOutput? speechOutput;
  final ValueListenable<int>? voiceStartRequests;
  final ValueChanged<AiNavigationAction>? onNavigate;

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  late final String _sessionId;
  late final SpeechInput _speechInput;
  late final SpeechOutput _speechOutput;
  final _messages = <_AiMessage>[
    _AiMessage(
      text:
          'Xin chào! Tôi có thể hỗ trợ lịch học, điểm số, học phí, thông báo và dữ liệu đã đồng bộ trên thiết bị.',
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ];
  bool _isLoading = false;
  bool _isListening = false;
  bool _voiceSendStarted = false;
  String _latestTranscript = '';
  _AiVoiceState _voiceState = _AiVoiceState.idle;
  String? _status;

  @override
  void initState() {
    super.initState();
    _sessionId = 'ai-${DateTime.now().microsecondsSinceEpoch}';
    _speechInput = widget.speechInput ?? AppDependencies.instance.speechInput;
    _speechOutput =
        widget.speechOutput ?? AppDependencies.instance.speechOutput;
    widget.voiceStartRequests?.addListener(_startListeningFromFab);
    AppLog.vongDoi('Màn hình trợ lý AI được mở', khuVuc: 'Trợ lý AI');
  }

  @override
  void dispose() {
    widget.voiceStartRequests?.removeListener(_startListeningFromFab);
    unawaited(_disposeVoiceServices());
    AppLog.vongDoi('Màn hình trợ lý AI được đóng', khuVuc: 'Trợ lý AI');
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _startListeningFromFab() {
    if (mounted) unawaited(_startListening());
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _stopAndSubmitVoice();
      return;
    }
    await _startListening();
  }

  Future<void> _startListening() async {
    if (_isLoading || _isListening || _voiceState == _AiVoiceState.speaking) {
      return;
    }
    try {
      await _speechOutput.stop();
      if (!mounted) return;
      setState(() {
        _isListening = true;
        _voiceSendStarted = false;
        _latestTranscript = '';
        _voiceState = _AiVoiceState.listening;
        _status = 'Đang nghe tiếng Việt...';
      });
      await _speechInput.start(
        onTranscript: _handleTranscript,
        onStatus: _handleSpeechStatus,
        onError: _handleSpeechError,
      );
    } catch (error, stackTrace) {
      AppLog.loi(
        'Không thể bắt đầu nhận diện giọng nói',
        khuVuc: 'Trợ lý AI',
        loi: error,
        stackTrace: stackTrace,
      );
      _showSpeechError(
        const SpeechInputFailure(
          code: 'start_failed',
          message: 'Không thể bắt đầu nhận diện giọng nói tiếng Việt.',
        ),
        stackTrace,
      );
    }
  }

  void _handleTranscript(SpeechTranscript transcript) {
    if (!mounted) return;
    final text = transcript.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _latestTranscript = text;
      _messageController.text = text;
      _messageController.selection = TextSelection.collapsed(
        offset: text.length,
      );
      _isListening = !transcript.isFinal;
      _voiceState = transcript.isFinal
          ? _AiVoiceState.transcribing
          : _AiVoiceState.listening;
      _status = transcript.isFinal
          ? 'Đã nhận văn bản: “$text”. Đang gửi tới AI...'
          : 'Đang nhận diện: $text';
    });
    if (transcript.isFinal) {
      unawaited(_submitVoiceTranscript());
    }
  }

  void _handleSpeechStatus(SpeechInputStatus status) {
    if (!mounted) return;
    if (status == SpeechInputStatus.listening) {
      setState(() {
        _isListening = true;
        _voiceState = _AiVoiceState.listening;
        _status = 'Đang nghe tiếng Việt...';
      });
      return;
    }

    setState(() => _isListening = false);
    if (_latestTranscript.isNotEmpty && !_voiceSendStarted) {
      unawaited(_submitVoiceTranscript());
    } else if (!_isLoading && !_voiceSendStarted) {
      setState(() {
        _voiceState = _AiVoiceState.idle;
        _status = 'Chưa nhận được văn bản. Vui lòng thử lại.';
      });
    }
  }

  void _handleSpeechError(SpeechInputFailure failure) {
    _showSpeechError(failure, StackTrace.current);
  }

  void _showSpeechError(SpeechInputFailure failure, StackTrace stackTrace) {
    AppLog.loi(
      'Nhận diện giọng nói thất bại',
      khuVuc: 'Trợ lý AI',
      duLieu: {'code': failure.code},
      loi: failure.code,
      stackTrace: stackTrace,
    );
    if (!mounted) return;
    setState(() {
      _isListening = false;
      _voiceState = _AiVoiceState.error;
      _status = failure.message;
    });
  }

  Future<void> _stopAndSubmitVoice() async {
    await _stopSpeechInputSafely();
    if (_latestTranscript.isEmpty) {
      if (mounted) {
        setState(() {
          _isListening = false;
          _voiceState = _AiVoiceState.idle;
          _status = 'Chưa nhận được văn bản. Vui lòng thử lại.';
        });
      }
      return;
    }
    await _submitVoiceTranscript();
  }

  Future<void> _submitVoiceTranscript() async {
    final transcript = _latestTranscript.trim();
    if (transcript.isEmpty || _voiceSendStarted || _isLoading) return;
    _voiceSendStarted = true;
    await _send(text: transcript, isVoiceTurn: true);
  }

  Future<void> _send({String? text, bool isVoiceTurn = false}) async {
    final prompt = (text ?? _messageController.text).trim();
    if (prompt.isEmpty || _isLoading) return;
    if (isVoiceTurn) _voiceSendStarted = true;
    try {
      await _stopSpeechInputSafely();
      if (!mounted) return;
      AppLog.thaoTacNguoiDung(
        'Người dùng gửi câu hỏi cho trợ lý AI',
        khuVuc: 'Trợ lý AI',
        duLieu: {'do_dai_cau_hoi': prompt.length, 'la_giong_noi': isVoiceTurn},
      );
      setState(() {
        _messages.add(
          _AiMessage(text: prompt, isUser: true, timestamp: DateTime.now()),
        );
        _messageController.clear();
        _isLoading = true;
        _isListening = false;
        _voiceState = _AiVoiceState.processing;
        _status = isVoiceTurn
            ? 'Đã nhận văn bản. Đang xử lý...'
            : 'Đang xử lý...';
      });
      _scrollToBottom();

      final ask =
          widget.askHandler ?? AppDependencies.instance.aiController().ask;
      final response = await ask(prompt, sessionId: _sessionId);
      if (!mounted) return;
      AppLog.ungDung(
        'Trợ lý AI đã trả lời câu hỏi',
        khuVuc: 'Trợ lý AI',
        duLieu: {'do_dai_cau_tra_loi': response.answerText.length},
      );
      setState(() {
        _messages.add(
          _AiMessage(
            text: response.answerText,
            isUser: false,
            timestamp: DateTime.now(),
            action: response.action,
            allowManualNavigation: !isVoiceTurn,
          ),
        );
        _isLoading = false;
        _voiceState = isVoiceTurn ? _AiVoiceState.speaking : _AiVoiceState.idle;
        _status = isVoiceTurn ? 'Đang đọc phản hồi...' : null;
      });
      _scrollToBottom();

      if (isVoiceTurn) await _speakThenNavigate(response);
    } catch (error, stackTrace) {
      AppLog.loi(
        'Không thể hoàn tất yêu cầu trợ lý AI',
        khuVuc: 'Trợ lý AI',
        loi: error,
        stackTrace: stackTrace,
      );
      if (!mounted) return;
      setState(() {
        _messages.add(
          _AiMessage(
            text: 'Không thể nhận phản hồi từ AI. Vui lòng thử lại.',
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
        _voiceState = _AiVoiceState.error;
        _status = 'Không thể nhận phản hồi từ AI. Vui lòng thử lại.';
      });
      _scrollToBottom();
    } finally {
      if (mounted && _isLoading) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _speakThenNavigate(AiTurnResult result) async {
    if (!mounted) return;
    try {
      await _speechOutput.speak(result.spokenText);
      if (!mounted) return;
      setState(() {
        _voiceState = _AiVoiceState.executing;
        _status = result.action == null ? null : 'Đang mở màn hình...';
      });
      if (result.action != null) widget.onNavigate?.call(result.action!);
      if (mounted && result.action == null) {
        setState(() => _voiceState = _AiVoiceState.idle);
      }
    } catch (error, stackTrace) {
      AppLog.loi(
        'Không thể đọc phản hồi AI bằng tiếng Việt',
        khuVuc: 'Trợ lý AI',
        loi: error,
        stackTrace: stackTrace,
      );
      if (!mounted) return;
      setState(() {
        final actionIndex = _messages.lastIndexWhere(
          (message) => !message.isUser && message.action != null,
        );
        if (actionIndex >= 0) {
          _messages[actionIndex] = _messages[actionIndex].copyWith(
            allowManualNavigation: true,
          );
        }
        _voiceState = _AiVoiceState.error;
        _status = result.action == null
            ? 'Không thể đọc phản hồi tiếng Việt.'
            : 'Không thể đọc phản hồi. Bạn có thể dùng nút điều hướng an toàn.';
      });
    }
  }

  Future<void> _stopSpeechInputSafely() async {
    try {
      await _speechInput.stop();
    } catch (error, stackTrace) {
      AppLog.loi(
        'Không thể dừng nhận diện giọng nói',
        khuVuc: 'Trợ lý AI',
        loi: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _disposeVoiceServices() async {
    try {
      await _speechInput.cancel();
    } catch (error, stackTrace) {
      AppLog.loi(
        'Không thể hủy nhận diện giọng nói khi đóng màn hình',
        khuVuc: 'Trợ lý AI',
        loi: error,
        stackTrace: stackTrace,
      );
    }
    try {
      await _speechOutput.stop();
    } catch (error, stackTrace) {
      AppLog.loi(
        'Không thể dừng đọc phản hồi khi đóng màn hình',
        khuVuc: 'Trợ lý AI',
        loi: error,
        stackTrace: stackTrace,
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSpeaking = _voiceState == _AiVoiceState.speaking;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        title: const Text('Trợ lý AI'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.auto_awesome_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_status != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Semantics(
                liveRegion: true,
                child: Text(
                  _status!,
                  key: const Key('ai-voice-status'),
                  style: const TextStyle(color: Color(0xFF33517E)),
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              key: const Key('ai-message-list'),
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) return const _AiTypingBubble();
                return _AiMessageBubble(
                  message: _messages[index],
                  onNavigate: widget.onNavigate,
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: Row(
                children: [
                  IconButton.filledTonal(
                    key: const Key('ai-page-mic'),
                    tooltip: _isListening ? 'Dừng và gửi' : 'Nói tiếng Việt',
                    onPressed: _isLoading || isSpeaking
                        ? null
                        : _toggleListening,
                    icon: Icon(
                      _isListening
                          ? Icons.stop_rounded
                          : Icons.mic_none_rounded,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      key: const Key('ai-page-input'),
                      controller: _messageController,
                      enabled: !_isLoading,
                      minLines: 1,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Nhắn tin cho AI hoặc dùng mic...',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton.filled(
                    key: const Key('ai-page-send'),
                    onPressed: _isLoading ? null : _send,
                    icon: const Icon(Icons.arrow_upward_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AiMessage {
  const _AiMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.action,
    this.allowManualNavigation = false,
  });

  final String text;
  final bool isUser;
  final DateTime timestamp;
  final AiNavigationAction? action;
  final bool allowManualNavigation;

  _AiMessage copyWith({bool? allowManualNavigation}) => _AiMessage(
    text: text,
    isUser: isUser,
    timestamp: timestamp,
    action: action,
    allowManualNavigation: allowManualNavigation ?? this.allowManualNavigation,
  );
}

class _AiMessageBubble extends StatelessWidget {
  const _AiMessageBubble({required this.message, this.onNavigate});

  final _AiMessage message;
  final ValueChanged<AiNavigationAction>? onNavigate;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.76,
        ),
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: message.isUser ? const Color(0xFF0047A8) : Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.white : const Color(0xFF0D1B3E),
                height: 1.45,
              ),
            ),
            if (!message.isUser &&
                message.action != null &&
                message.allowManualNavigation &&
                onNavigate != null) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                key: const Key('ai-safe-navigation'),
                onPressed: () => onNavigate!(message.action!),
                icon: const Icon(Icons.open_in_new_rounded),
                label: const Text('Mở màn hình'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AiTypingBubble extends StatelessWidget {
  const _AiTypingBubble();

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Text('AI đang trả lời...'),
      ),
    );
  }
}
