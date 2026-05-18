import 'package:aqedu/features/chat/models/chat_message.dart';
import 'package:aqedu/features/chat/models/chat_thread.dart';
import 'package:aqedu/features/chat/models/chat_user.dart';
import 'package:aqedu/features/chat/services/chat_service.dart';
import 'package:aqedu/features/chat/services/chat_student_info_service.dart';
import 'package:aqedu/features/chat/services/chat_user_sync_service.dart';

class ChatRepository {
  ChatRepository({
    ChatService? chatService,
    ChatUserSyncService? userSyncService,
    ChatStudentInfoService? studentInfoService,
  })  : _chatService = chatService ?? ChatService(),
        _userSyncService = userSyncService ?? ChatUserSyncService(),
        _studentInfoService = studentInfoService ?? ChatStudentInfoService();

  final ChatService _chatService;
  final ChatUserSyncService _userSyncService;
  final ChatStudentInfoService _studentInfoService;

  Future<ChatUser> syncCurrentSessionUser() async {
    final studentData = await _studentInfoService.getCurrentStudentData();
    if (studentData == null) {
      return _userSyncService.syncCurrentSessionUser();
    }

    return _userSyncService.syncStudentIdWithStudentData(studentData);
  }

  Future<ChatUser?> getUserByStudentId(String studentId) async {
    return _chatService.getUserByStudentId(studentId);
  }

  Future<ChatUser> ensureUserByStudentId(String studentId) {
    return _chatService.ensureUserByStudentId(studentId);
  }

  Future<List<ChatUser>> searchUsers({
    required String keyword,
    required String excludeStudentId,
    int limit = 20,
  }) {
    return _chatService.searchUsers(
      keyword: keyword,
      excludeStudentId: excludeStudentId,
      limit: limit,
    );
  }

  Stream<List<ChatThread>> streamChatThreads({
    required String currentStudentId,
    int limit = 200,
  }) {
    return _chatService.streamChatThreads(
      currentStudentId: currentStudentId,
      limit: limit,
    );
  }

  Future<List<ChatMessage>> loadConversationMessages({
    required String conversationId,
    int limit = 80,
  }) {
    return _chatService.loadConversation(
      conversationId: conversationId,
      limit: limit,
    );
  }

  Stream<List<ChatMessage>> streamConversationMessages({
    required String conversationId,
    int limit = 80,
  }) {
    return _chatService.streamConversation(
      conversationId: conversationId,
      limit: limit,
    );
  }

  Future<ChatMessage> sendMessage({
    required String conversationId,
    required String senderStudentId,
    required String receiverStudentId,
    required String message,
  }) {
    return _chatService.sendMessage(
      conversationId: conversationId,
      senderStudentId: senderStudentId,
      receiverStudentId: receiverStudentId,
      message: message,
    );
  }

  Future<String?> getConversationId({
    required String currentStudentId,
    required String otherStudentId,
  }) {
    return _chatService.getConversationId(
      currentStudentId: currentStudentId,
      otherStudentId: otherStudentId,
    );
  }

  Future<String> ensureConversationId({
    required String currentStudentId,
    required String otherStudentId,
    required String lastMessage,
    required String lastSenderId,
  }) {
    return _chatService.ensureConversation(
      currentStudentId: currentStudentId,
      otherStudentId: otherStudentId,
      lastMessage: lastMessage,
      lastSenderId: lastSenderId,
    );
  }
}
