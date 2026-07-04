import 'dart:async';
import 'dart:collection';

import 'package:aqedu/core/logging/app_log.dart';
import 'package:aqedu/core/services_root/notification/notification_manager.dart';
import 'package:aqedu/features/chat/models/chat_message.dart';
import 'package:aqedu/features/chat/models/chat_user.dart';
import 'package:aqedu/features/chat/services/chat_service.dart';

class ChatNotificationService {
  ChatNotificationService._();

  static final ChatNotificationService instance = ChatNotificationService._();

  final ChatService _chatService = ChatService();
  StreamSubscription<ChatMessage>? _subscription;
  String? _currentStudentId;
  ChatUser? _currentUser;
  final LinkedHashSet<String> _seenMessageIds = LinkedHashSet<String>();

  Future<void> startForUser(ChatUser currentUser) async {
    final studentId = currentUser.studentId.trim();
    if (studentId.isEmpty) {
      AppLog.chat(
        'Bỏ qua đăng ký thông báo chat vì mã sinh viên trống',
        khuVuc: 'Thông báo chat',
      );
      return;
    }
    if (_currentStudentId == studentId && _subscription != null) {
      AppLog.chat(
        'Bỏ qua đăng ký thông báo chat vì người dùng đang được theo dõi',
        khuVuc: 'Thông báo chat',
        duLieu: {'ma_sinh_vien': studentId},
      );
      return;
    }

    await stop();
    _currentStudentId = studentId;
    _currentUser = currentUser;
    AppLog.chat(
      'Bắt đầu theo dõi tin nhắn chat đến',
      khuVuc: 'Thông báo chat',
      duLieu: {'ma_sinh_vien': studentId},
    );

    _subscription = _chatService
        .streamIncomingMessages(currentStudentId: studentId)
        .listen(
          (message) async {
            if (message.senderStudentId.trim() == studentId) return;
            final messageId = message.id.toString();
            if (_seenMessageIds.contains(messageId)) return;
            _seenMessageIds.add(messageId);
            if (_seenMessageIds.length > 500) {
              _seenMessageIds.remove(_seenMessageIds.first);
            }

            try {
              final sender =
                  await _chatService.getUserByStudentId(
                    message.senderStudentId,
                  ) ??
                  ChatUser(
                    id: message.senderStudentId,
                    studentId: message.senderStudentId,
                    fullName: message.senderStudentId,
                    avatarUrl: '',
                    faculty: '',
                    className: '',
                  );

              await NotificationManager.instance.handleIncomingChatMessage(
                message: message,
                sender: sender,
                receiver: currentUser,
              );
              AppLog.thongBao(
                'Đã xử lý thông báo tin nhắn chat đến',
                khuVuc: 'Thông báo chat',
                duLieu: {
                  'ma_nguoi_gui': message.senderStudentId,
                  'ma_nguoi_nhan': studentId,
                },
              );
            } catch (error) {
              AppLog.loi(
                'Xử lý thông báo tin nhắn chat gặp lỗi',
                khuVuc: 'Thông báo chat',
                duLieu: {'ma_nguoi_gui': message.senderStudentId},
                loi: error,
              );
            }
          },
          onError: (error) {
            AppLog.loi(
              'Luồng thông báo chat gặp lỗi',
              khuVuc: 'Thông báo chat',
              duLieu: {'ma_sinh_vien': studentId},
              loi: error,
            );
          },
          cancelOnError: false,
        );
  }

  Future<void> stop() async {
    if (_subscription != null) {
      AppLog.chat(
        'Dừng theo dõi thông báo chat',
        khuVuc: 'Thông báo chat',
        duLieu: {'ma_sinh_vien': _currentStudentId},
      );
    }
    await _subscription?.cancel();
    _subscription = null;
    _currentStudentId = null;
    _currentUser = null;
    _seenMessageIds.clear();
  }
}
