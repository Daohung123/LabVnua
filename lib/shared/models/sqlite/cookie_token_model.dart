import 'dart:convert';
import 'package:http/http.dart' as http;

class SessionModel {
  final String cookie;
  final String token;

  SessionModel({required this.cookie, required this.token});

  /// convert object -> Map để lưu SQLite
  Map<String, dynamic> toMap() {
    return {'cookie': cookie, 'token': token};
  }

  /// convert Map -> object khi đọc từ SQLite
  factory SessionModel.fromMap(Map<String, dynamic> map) {
    return SessionModel(cookie: map['cookie'], token: map['token']);
  }
}