import 'package:aqedu/features/chat/models/chat_user.dart';
import 'package:aqedu/features/chat/services/chat_service.dart';
import 'package:aqedu/features/chat/services/chat_session_service.dart';

class ChatUserSyncService {
  ChatUserSyncService({
    ChatService? chatService,
    ChatSessionService? sessionService,
  }) : _chatService = chatService ?? ChatService(),
       _sessionService = sessionService ?? ChatSessionService();

  final ChatService _chatService;
  final ChatSessionService _sessionService;

  Future<ChatUser> syncCurrentSessionUser() async {
    final studentId = await _sessionService.getCurrentStudentId();
    return syncStudentId(studentId);
  }

  Future<ChatUser> syncStudentId(String studentId) {
    return _chatService.ensureUserByStudentId(studentId);
  }

  static Future<void> syncUser(String studentId) async {
    await ChatUserSyncService().syncStudentId(studentId);
  }
}
