import 'package:aqedu/core/screens/screen_loading.dart';
import 'package:aqedu/core/services_root/api_daotao/auth/checkLogin.dart';
import 'package:aqedu/features/auth/student/screens/student_login_view.dart';
import 'package:aqedu/features/chat/services/chat_notification_service.dart';
import 'package:aqedu/features/chat/services/chat_realtime_connection_service.dart';
import 'package:aqedu/features/chat/services/chat_user_sync_service.dart';
import 'package:aqedu/features/home/home_screen/screens/student_home_screen_view.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:aqedu/core/screens/no_wifi_screen.dart';

// Đây là gốc của toàn bộ UI
class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  bool? checkResult;
  bool? hasWifi;

  @override
  void initState() {
    super.initState();
    initApp();
  }

  Future<void> initApp() async {
    // Kiểm tra wifi
    final connectivityResult = await Connectivity().checkConnectivity();

    final bool wifiConnected = connectivityResult.contains(
      ConnectivityResult.wifi,
    );

    setState(() {
      hasWifi = wifiConnected;
    });

    // Không có wifi -> dừng
    if (!wifiConnected) {
      return;
    }

    // Có wifi -> check login
    final bool result = await checkLogin();
    setState(() {
      checkResult = result;
    });

    if (result) {
      _initializeChatForCurrentUser();
    }
  }

  Future<void> _initializeChatForCurrentUser() async {
    try {
      final chatUser = await ChatUserSyncService().syncCurrentSessionUser();
      await ChatRealtimeConnectionService.instance.connect(chatUser);
      await ChatNotificationService.instance.startForUser(chatUser);
    } catch (error) {
      debugPrint('Startup chat notification init failed: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Đang loading wifi
    if (hasWifi == null) {
      return const ScreenLoading();
    }

    // Không có wifi
    if (hasWifi == false) {
      return const NoWifiScreen();
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
