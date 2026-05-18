import 'chat_user.dart';

class ChatThread {
  const ChatThread({
    required this.conversationId,
    required this.peer,
    required this.lastMessage,
    required this.lastSenderStudentId,
    required this.updatedAt,
  });

  final String conversationId;
  final ChatUser peer;
  final String lastMessage;
  final String lastSenderStudentId;
  final DateTime updatedAt;
}
