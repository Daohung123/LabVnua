import 'dart:async';

import 'package:aqedu/core/logging/app_log.dart';
import 'package:aqedu/core/screens/screen_loading.dart';
import 'package:aqedu/core/services_root/api_daotao/auth/check_login.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/core_service_session.dart';
import 'package:aqedu/core/services_root/supabase/supabase_config.dart';
import 'package:aqedu/features/auth/student/screens/student_login_view.dart';
import 'package:aqedu/features/chat/services/chat_notification_service.dart';
import 'package:aqedu/features/chat/services/chat_realtime_connection_service.dart';
import 'package:aqedu/features/chat/services/chat_user_sync_service.dart';
import 'package:aqedu/features/home/home_screen/screens/student_home_screen_view.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

// Đây là gốc của toàn bộ UI
class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  bool? checkResult;
  bool? hasNetwork;

  @override
  void initState() {
    super.initState();
    AppLog.vongDoi(
      'Màn hình gốc bắt đầu kiểm tra trạng thái ứng dụng',
      khuVuc: 'MyWidget',
    );
    initApp();
  }

  Future<void> initApp() async {
    try {
      AppLog.ungDung(
        'Bắt đầu kiểm tra trạng thái đăng nhập khi mở ứng dụng',
        khuVuc: 'MyWidget',
      );

      // Kiểm tra wifi
      final connectivityResult = await Connectivity().checkConnectivity();
      final bool networkConnected = !connectivityResult.contains(
        ConnectivityResult.none,
      );
      AppLog.ungDung(
        'Đã kiểm tra kết nối mạng',
        khuVuc: 'MyWidget',
        duLieu: {'co_mang': networkConnected},
      );

      if (!mounted) return;
      setState(() {
        hasNetwork = networkConnected;
      });

      // Không có wifi -> dừng
      if (!networkConnected) {
        final localSession = await SqliteServices().getSession();
        AppLog.coSoDuLieu(
          'Đọc session local khi không có mạng',
          khuVuc: 'MyWidget',
          duLieu: {'co_session_local': localSession != null},
          ketQua: localSession != null
              ? 'Cho phép vào ứng dụng bằng dữ liệu local.'
              : 'Không có session local, chuyển về đăng nhập.',
        );
        if (!mounted) return;
        setState(() {
          checkResult = localSession != null;
        });
        return;
      }

      // Có wifi -> check login
      final bool result = await checkLogin();
      AppLog.ungDung(
        'Đã kiểm tra phiên đăng nhập qua hệ thống đào tạo',
        khuVuc: 'MyWidget',
        duLieu: {'dang_nhap_hop_le': result},
      );

      if (!mounted) return;
      setState(() {
        checkResult = result;
      });

      if (result) {
        AppLog.chat(
          'Chuẩn bị khởi tạo chat cho phiên đăng nhập hiện tại',
          khuVuc: 'MyWidget',
        );
        unawaited(_initializeChatForCurrentUser());
      }
    } catch (error, stackTrace) {
      AppLog.loi(
        'Kiểm tra trạng thái ứng dụng khi mở app gặp lỗi',
        khuVuc: 'MyWidget',
        loi: error,
        stackTrace: stackTrace,
        ketQua:
            'Đang thử chuyển sang kiểm tra session local để giữ app dùng được.',
      );

      // Keep the app usable when a startup integration fails.
      if (!mounted) return;
      setState(() {
        hasNetwork ??= false;
      });

      final localSession = await SqliteServices().getSession();
      AppLog.coSoDuLieu(
        'Đọc session local sau lỗi khởi động',
        khuVuc: 'MyWidget',
        duLieu: {'co_session_local': localSession != null},
      );
      if (!mounted) return;
      setState(() {
        checkResult ??= localSession != null;
      });
    }
  }

  Future<void> _initializeChatForCurrentUser() async {
    try {
      AppLog.chat(
        'Bắt đầu khởi tạo chat cho người dùng hiện tại',
        khuVuc: 'MyWidget',
      );
      final isSupabaseReady = await SupabaseConfig.init();
      if (!isSupabaseReady) {
        AppLog.chat(
          'Không thể khởi tạo chat vì Supabase chưa sẵn sàng',
          khuVuc: 'MyWidget',
          ketQua: 'Bỏ qua chat trong phiên hiện tại.',
        );
        return;
      }

      final chatUser = await ChatUserSyncService().syncCurrentSessionUser();
      await ChatRealtimeConnectionService.instance.connect(chatUser);
      await ChatNotificationService.instance.startForUser(chatUser);
      AppLog.chat(
        'Khởi tạo chat cho người dùng hiện tại hoàn tất',
        khuVuc: 'MyWidget',
        duLieu: {'ma_sinh_vien': chatUser.studentId},
      );
    } catch (error, stackTrace) {
      AppLog.loi(
        'Khởi tạo chat khi mở app gặp lỗi',
        khuVuc: 'MyWidget',
        loi: error,
        stackTrace: stackTrace,
        ketQua: 'Ứng dụng vẫn tiếp tục chạy, chỉ bỏ qua chat.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Đang loading wifi
    if (hasNetwork == null) {
      return const ScreenLoading();
    }

    // Đang check login
    if (checkResult == null) {
      return const ScreenLoading();
    }

    // Đã login
    if (checkResult == true) {
      return HomeScreen();
    }

    // Chưa login
    return const LoginScreen();
  }
}
