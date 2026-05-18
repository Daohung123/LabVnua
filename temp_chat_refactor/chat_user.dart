class ChatUser {
  const ChatUser({
    required this.id,
    required this.studentId,
    required this.fullName,
    required this.avatarUrl,
    required this.faculty,
    required this.className,
    this.lastOnline,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String studentId;
  final String fullName;
  final String avatarUrl;
  final String faculty;
  final String className;
  final DateTime? lastOnline;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    final id = json['id'] ?? json['student_id'];
    final studentId = json['student_id'];
    if (id == null || id.toString().trim().isEmpty) {
      throw const FormatException('Missing users.id or users.student_id');
    }
    if (studentId == null || studentId.toString().trim().isEmpty) {
      throw const FormatException('Missing users.student_id');
    }

    return ChatUser(
      id: id.toString(),
      studentId: studentId.toString().trim(),
      fullName: json['full_name']?.toString().trim() ?? '',
      avatarUrl: json['avatar_url']?.toString().trim() ?? '',
      faculty: json['faculty']?.toString().trim() ?? '',
      className: json['class_name']?.toString().trim() ?? '',
      lastOnline: _parseDateTime(json['last_online']),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toUpsertJson() {
    return {
      'student_id': studentId,
      'full_name': fullName,
      'avatar_url': avatarUrl.isEmpty ? null : avatarUrl,
      'faculty': faculty.isEmpty ? null : faculty,
      'class_name': className.isEmpty ? null : className,
      'last_online': lastOnline?.toIso8601String(),
    };
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}
