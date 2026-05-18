class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderStudentId,
    required this.receiverStudentId,
    required this.message,
    required this.messageType,
    required this.isSeen,
    required this.createdAt,
  });

  final Object id;
  final String conversationId;
  final String senderStudentId;
  final String receiverStudentId;
  final String message;
  final String messageType;
  final bool isSeen;
  final DateTime createdAt;

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final conversationId = json['conversation_id'];
    final senderStudentId = json['sender_student_id'];
    final receiverStudentId = json['receiver_student_id'];
    final message = json['message'];
    final messageType = json['message_type'];
    final isSeen = json['is_seen'];

    if (id == null) {
      throw const FormatException('Missing messages.id');
    }
    if (conversationId == null) {
      throw const FormatException('Missing messages.conversation_id');
    }
    if (senderStudentId == null) {
      throw const FormatException('Missing messages.sender_student_id');
    }
    if (receiverStudentId == null) {
      throw const FormatException('Missing messages.receiver_student_id');
    }
    if (message == null) {
      throw const FormatException('Missing messages.message');
    }

    return ChatMessage(
      id: id,
      conversationId: conversationId.toString(),
      senderStudentId: senderStudentId.toString(),
      receiverStudentId: receiverStudentId.toString(),
      message: message.toString(),
      messageType: messageType?.toString() ?? 'text',
      isSeen: _parseBool(isSeen),
      createdAt: _parseCreatedAt(json['created_at']),
    );
  }

  bool isSentBy(String studentId) {
    return senderStudentId.trim() == studentId.trim();
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'conversation_id': conversationId,
      'sender_student_id': senderStudentId,
      'receiver_student_id': receiverStudentId,
      'message': message,
      'message_type': messageType,
      'is_seen': isSeen,
    };
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    return false;
  }

  static DateTime _parseCreatedAt(dynamic value) {
    if (value is DateTime) return value;
    if (value != null) {
      final parsed = DateTime.tryParse(value.toString());
      if (parsed != null) return parsed;
    }
    return DateTime.now().toUtc();
  }
}
