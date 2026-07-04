import 'package:aqedu/core/logging/app_log.dart';

import 'core_service_session.dart';
import '../../../models/sqlite/session.dart';

class GETDB {
  static Future<String> getCookie() async {
    final sqlite = SqliteServices();
    SessionModel? sqliteResult = await sqlite.getSession();
    String cookie = sqliteResult!.cookie;
    AppLog.coSoDuLieu(
      'Lấy cookie từ session SQLite',
      khuVuc: 'Session SQLite',
      duLieu: {'co_cookie': cookie.isNotEmpty},
    );
    return cookie;
  }

  static Future<String> getToken() async {
    final sqlite = SqliteServices();
    SessionModel? sqliteResult = await sqlite.getSession();
    String token = sqliteResult!.token;
    AppLog.coSoDuLieu(
      'Lấy token từ session SQLite',
      khuVuc: 'Session SQLite',
      duLieu: {'co_token': token.isNotEmpty},
    );
    return token;
  }
}
