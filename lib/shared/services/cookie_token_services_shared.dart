import '../../config/config_DB.dart';
import '../models/sqlite/cookie_token_model.dart';

class GETDB {
  static Future<String> getCookie() async {
    final sqlite = await DBHelper();
    SessionModel? Sqlite_Result = await sqlite.getSession();
    String cookie = Sqlite_Result!.cookie;
    return cookie;
  }

  static Future<String> getToken() async {
    final sqlite = await DBHelper();
    SessionModel? Sqlite_Result = await sqlite.getSession();
    String token = Sqlite_Result!.token;
    return token;
  }
}
