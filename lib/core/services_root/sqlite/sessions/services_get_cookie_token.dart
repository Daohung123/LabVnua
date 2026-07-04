import 'core_service_session.dart';
import '../../../models/sqlite/session.dart';

class GETDB {
  static Future<String> getCookie() async {
    final sqlite = SqliteServices();
    SessionModel? sqliteResult = await sqlite.getSession();
    String cookie = sqliteResult!.cookie;
    return cookie;
  }

  static Future<String> getToken() async {
    final sqlite = SqliteServices();
    SessionModel? sqliteResult = await sqlite.getSession();
    String token = sqliteResult!.token;
    return token;
  }
}
