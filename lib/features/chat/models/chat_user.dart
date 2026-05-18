class ChatUser {
  const ChatUser({required this.id, required this.studentId, this.createdAt});

  final Object id;
  final String studentId;
  final DateTime? createdAt;

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final studentId = json['student_id'];

    if (id == null) {
      throw const FormatException('Missing users.id');
    }
    if (studentId == null || studentId.toString().trim().isEmpty) {
      throw const FormatException('Missing users.student_id');
    }

    return ChatUser(
      id: id,
      studentId: studentId.toString(),
      createdAt: _parseDate(json['created_at']),
    );
  }

  Map<String, dynamic> toInsertJson() {
    return {'student_id': studentId};
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}
