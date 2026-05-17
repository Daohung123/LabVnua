import 'package:aqedu/core/screens/screen_loading.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/core_service_session.dart';
import 'package:aqedu/features/auth/student/screens/role_view.dart';
import 'package:aqedu/features/home/home_screen/screens/student_home_screen_view.dart';
import 'package:aqedu/features/infor/services/service_sqlite_informationStudent.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:aqedu/core/screens/no_wifi_screen.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  bool? isLogged;
  bool? hasWifi;

  @override
  void initState() {
    super.initState();
    initApp();
  }

  Future<void> initApp() async {
    print("App: Khởi động...");
    
    // 1. Kiểm tra Wifi nhanh
    final connectivityResult = await Connectivity().checkConnectivity();
    bool wifi = connectivityResult.contains(ConnectivityResult.wifi) || 
                connectivityResult.contains(ConnectivityResult.mobile);

    if (mounted) setState(() => hasWifi = wifi);
    if (!wifi) return;

    // 2. Kiểm tra Session trong máy (Chỉ đọc SQLite, không gọi API để tránh treo)
    SqliteServices db = SqliteServices();
    bool sessionExists = await db.checkLogin();
    
    if (sessionExists) {
      // Kiểm tra thêm xem có thông tin sinh viên chưa
      final student = await ServiceSqlInformationStudent.getAllInformation();
      if (student == null) {
        sessionExists = false; // Coi như chưa login để hiện màn hình nhập tài khoản
      }
    }

    if (mounted) {
      setState(() {
        isLogged = sessionExists;
        print("App: Trạng thái login (offline check): $sessionExists");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (hasWifi == null) return const ScreenLoading();
    if (hasWifi == false) return const NoWifiScreen();
    
    // Nếu chưa xác định được trạng thái login
    if (isLogged == null) return const ScreenLoading();

    // Nếu đã có session và thông tin SV trong máy
    if (isLogged == true) {
      return const HomeScreen();
    }

    // Nếu chưa có (hoặc session cũ bị lỗi) -> Hiện màn hình Chọn vai trò để Đăng nhập
    return const RoleView();
  }
}
