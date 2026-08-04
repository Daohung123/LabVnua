import 'package:aqedu/core/logging/app_log.dart';
import 'package:aqedu/core/models/sqlite/session.dart';
import 'package:aqedu/core/services_root/api_daotao/root_daotao/daotao_post_get.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/core_service_session.dart';
import 'package:aqedu/core/services_root/supabase/supabase_config.dart';
import 'package:aqedu/features/chat/services/chat_notification_service.dart';
import 'package:aqedu/features/chat/services/chat_realtime_connection_service.dart';
import 'package:aqedu/features/chat/services/chat_user_sync_service.dart';

// ignore: non_constant_identifier_names
Future<bool> ctrl_login(String username, String password) async {
  AppLog.thaoTacNguoiDung(
    'Người dùng gửi yêu cầu đăng nhập',
    khuVuc: 'Đăng nhập sinh viên',
    duLieu: {'co_tai_khoan': username.trim().isNotEmpty},
  );

  SqliteServices sqlite = SqliteServices();
  ApiHelper daotao = ApiHelper();
  SessionModel? res = await daotao.login(username, password);
  if (res == null) {
    AppLog.api(
      'Đăng nhập hệ thống đào tạo không thành công',
      khuVuc: 'Đăng nhập sinh viên',
      ketQua: 'API không trả về session hợp lệ.',
    );
    return false;
  }
  final existingSession = await sqlite.getSession();
  if (existingSession != null && existingSession.user != res.user) {
    await sqlite.deleteSession();
  }
  await sqlite.saveSession(res);
  final session = await sqlite.getSession();

  AppLog.coSoDuLieu(
    'Đã lưu session đăng nhập vào SQLite',
    khuVuc: 'Đăng nhập sinh viên',
    duLieu: {
      'co_cookie': session?.cookie != null,
      'co_token': session?.token != null,
    },
  );

  if (session?.cookie == null && session?.token == null) {
    AppLog.coSoDuLieu(
      'Session sau đăng nhập không hợp lệ',
      khuVuc: 'Đăng nhập sinh viên',
      ketQua: 'Thiếu cả cookie và token.',
    );
    return false;
  }

  try {
    final isSupabaseReady = await SupabaseConfig.init();
    if (isSupabaseReady) {
      AppLog.chat(
        'Bắt đầu đồng bộ người dùng chat sau đăng nhập',
        khuVuc: 'Đăng nhập sinh viên',
      );
      final chatUser = await ChatUserSyncService().syncCurrentSessionUser();
      await ChatRealtimeConnectionService.instance.connect(chatUser);
      await ChatNotificationService.instance.startForUser(chatUser);
      AppLog.chat(
        'Đồng bộ chat sau đăng nhập hoàn tất',
        khuVuc: 'Đăng nhập sinh viên',
        duLieu: {'ma_sinh_vien': chatUser.studentId},
      );
    } else {
      AppLog.chat(
        'Bỏ qua đồng bộ chat sau đăng nhập',
        khuVuc: 'Đăng nhập sinh viên',
        ketQua: 'Supabase chưa sẵn sàng.',
      );
    }
  } catch (error, stackTrace) {
    AppLog.loi(
      'Đồng bộ chat sau đăng nhập gặp lỗi',
      khuVuc: 'Đăng nhập sinh viên',
      loi: error,
      stackTrace: stackTrace,
      ketQua: 'Đăng nhập vẫn thành công, chỉ bỏ qua chat.',
    );
  }

  AppLog.thaoTacNguoiDung(
    'Đăng nhập sinh viên hoàn tất',
    khuVuc: 'Đăng nhập sinh viên',
    ketQua: 'Người dùng có thể vào màn hình chính.',
  );
  return true;
}
