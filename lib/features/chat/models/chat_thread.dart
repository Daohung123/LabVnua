import 'chat_message.dart';
import 'chat_user.dart';

class ChatThread {
  const ChatThread({required this.peer, required this.lastMessage});

  final ChatUser peer;
  final ChatMessage lastMessage;

  DateTime get updatedAt => lastMessage.createdAt;
}
