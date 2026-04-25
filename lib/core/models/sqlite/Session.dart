class SessionModel {
  final String user;
  final String pass;
  final String cookie;
  final String token;

  SessionModel({required this.user,required this.pass,required this.cookie, required this.token});

  /// convert object -> Map để lưu SQLite
  Map<String, dynamic> toMap() {
    return {'user': user,'pass':pass,'cookie': cookie, 'token': token};
  }

  /// convert Map -> object khi đọc từ SQLite
  factory SessionModel.fromMap(Map<String, dynamic> map) {
    return SessionModel(user: map['user'],pass: map['pass'],cookie: map['cookie'], token: map['token']);
  }
}