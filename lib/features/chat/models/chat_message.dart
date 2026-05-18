class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.createdAt,
  });

  final Object id;
  final Object senderId;
  final Object receiverId;
  final String message;
  final DateTime createdAt;

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final senderId = json['sender_id'];
    final receiverId = json['receiver_id'];
    final message = json['message'];

    if (id == null) {
      throw const FormatException('Missing messages.id');
    }
    if (senderId == null) {
      throw const FormatException('Missing messages.sender_id');
    }
    if (receiverId == null) {
      throw const FormatException('Missing messages.receiver_id');
    }
    if (message == null) {
      throw const FormatException('Missing messages.message');
    }

    return ChatMessage(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      message: message.toString(),
      createdAt: _parseCreatedAt(json['created_at']),
    );
  }

  bool isSentBy(Object userId) {
    return senderId.toString() == userId.toString();
  }

  Object peerIdOf(Object currentUserId) {
    return isSentBy(currentUserId) ? receiverId : senderId;
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
    };
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
