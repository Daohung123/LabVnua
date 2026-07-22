import 'package:aqedu/core/logging/app_log.dart';
import 'package:aqedu/core/models/sqlite/session.dart';
import '../../../../config/config_db.dart';
import '../../../security/secure_session_store.dart';

class SqliteServices {
  SqliteServices({SecureSessionStore? secureSessionStore})
    : _secureSessionStore = secureSessionStore ?? SecureSessionStore();

  final SecureSessionStore _secureSessionStore;

  /// Lưu session
  Future<void> saveSession(SessionModel session) async {
    AppLog.coSoDuLieu(
      'Lưu session vào secure storage',
      khuVuc: 'Session bảo mật',
      duLieu: {
        'co_cookie': session.cookie.isNotEmpty,
        'co_token': session.token.isNotEmpty,
      },
    );

    await _secureSessionStore.write(session);
  }

  /// Lấy session
  Future<SessionModel?> getSession() async {
    AppLog.coSoDuLieu('Đọc session từ secure storage', khuVuc: 'Session bảo mật');
    final session = await _secureSessionStore.read();
    if (session == null) {
      AppLog.coSoDuLieu(
        'Không tìm thấy session bảo mật',
        khuVuc: 'Session bảo mật',
      );
      return null;
    }
    AppLog.coSoDuLieu(
      'Tìm thấy session bảo mật',
      khuVuc: 'Session bảo mật',
    );
    return session;
  }

  /// checkLogin
  Future<bool> checkLogin() async {
    final hasSession = await _secureSessionStore.read() != null;
    AppLog.coSoDuLieu(
      'Kiểm tra session bảo mật',
      khuVuc: 'Session bảo mật',
      duLieu: {'co_session': hasSession},
    );
    return hasSession;
  }

  /// Xóa session
  Future<void> deleteSession() async {
    AppLog.coSoDuLieu('Xóa session và cache bảo mật', khuVuc: 'Session bảo mật');
    await DataBaseConfig.clearCurrentUserData(sessionStore: _secureSessionStore);
    await _secureSessionStore.clear();
  }
}
