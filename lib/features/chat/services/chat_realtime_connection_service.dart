import 'dart:async';

import 'package:aqedu/core/logging/app_log.dart';
import 'package:aqedu/features/chat/models/chat_thread.dart';
import 'package:aqedu/features/chat/models/chat_user.dart';
import 'package:aqedu/features/chat/services/chat_service.dart';

class ChatRealtimeConnectionService {
  ChatRealtimeConnectionService._();

  static final ChatRealtimeConnectionService instance =
      ChatRealtimeConnectionService._();

  final ChatService _chatService = ChatService();

  StreamSubscription<List<ChatThread>>? _threadsSubscription;
  String? _activeStudentId;

  bool get isConnected => _threadsSubscription != null;

  Future<void> connect(ChatUser user) async {
    final studentId = user.studentId;
    if (_activeStudentId == studentId && _threadsSubscription != null) {
      AppLog.chat(
        'Bỏ qua kết nối realtime vì người dùng đã được kết nối',
        khuVuc: 'Chat realtime',
        duLieu: {'ma_sinh_vien': studentId},
      );
      return;
    }

    await disconnect();
    _activeStudentId = studentId;
    AppLog.chat(
      'Bắt đầu kết nối realtime danh sách chat',
      khuVuc: 'Chat realtime',
      duLieu: {'ma_sinh_vien': studentId},
    );
    _threadsSubscription = _chatService
        .streamChatThreads(currentStudentId: studentId)
        .listen(
          (_) {},
          onError: (Object error) {
            AppLog.loi(
              'Kết nối realtime danh sách chat gặp lỗi',
              khuVuc: 'Chat realtime',
              duLieu: {'ma_sinh_vien': studentId},
              loi: error,
            );
          },
        );
  }

  Future<void> disconnect() async {
    if (_threadsSubscription != null) {
      AppLog.chat(
        'Ngắt kết nối realtime danh sách chat',
        khuVuc: 'Chat realtime',
        duLieu: {'ma_sinh_vien': _activeStudentId},
      );
    }
    await _threadsSubscription?.cancel();
    _threadsSubscription = null;
    _activeStudentId = null;
  }
}
