import 'dart:async';
import 'dart:io';

import 'package:aqedu/core/logging/app_log.dart';
import 'package:aqedu/core/services_root/notification/notification_manager.dart';
import 'package:aqedu/core/services_root/notification/notification_router.dart';
import 'package:aqedu/core/services_root/supabase/supabase_config.dart';
import 'package:aqedu/core/theme/app_theme.dart';
import 'package:aqedu/features/notification/services/background_sync_service.dart';
import 'package:aqedu/features/notification/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './config/http_override.dart';
import 'app.dart';

/// Starts the UI before optional native and remote services.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await _loadRuntimeEnvironment();
  AppLog.ungDung(
    'Ứng dụng bắt đầu khởi tạo',
    khuVuc: 'Khởi động ứng dụng',
    ketQua: 'Đã chuẩn bị Flutter binding và HTTP override.',
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.surface,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    MaterialApp(
      title: 'EduAI - Cổng thông tin đào tạo',
      debugShowCheckedModeBanner: false,
      color: AppColors.primary,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      navigatorKey: NotificationRouter.navigatorKey,
      home: const MyWidget(),
    ),
  );
  AppLog.ungDung(
    'Ứng dụng đã dựng giao diện gốc',
    khuVuc: 'Khởi động ứng dụng',
    ketQua:
        'Màn hình đầu tiên có thể hiển thị trước khi dịch vụ tùy chọn chạy xong.',
  );

  unawaited(_initializeOptionalServices());
}

Future<void> _loadRuntimeEnvironment() async {
  try {
    await dotenv.load(fileName: '.env', isOptional: true);
    AppLog.ungDung(
      'Da tai cau hinh runtime tu .env',
      khuVuc: 'Khoi dong ung dung',
      duLieu: {
        'co_gemini_api_key': dotenv.maybeGet('GEMINI_API_KEY')?.isNotEmpty,
        'co_gemini_model': dotenv.maybeGet('GEMINI_MODEL')?.isNotEmpty,
        'co_supabase_url': dotenv.maybeGet('SUPABASE_URL')?.isNotEmpty,
        'co_supabase_anon_key': dotenv
            .maybeGet('SUPABASE_ANON_KEY')
            ?.isNotEmpty,
      },
    );
  } catch (error, stackTrace) {
    AppLog.loi(
      'Khong the tai cau hinh runtime tu .env',
      khuVuc: 'Khoi dong ung dung',
      loi: error,
      stackTrace: stackTrace,
      ketQua:
          'Ung dung tiep tuc chay va dung dart-define neu da duoc cung cap.',
    );
  }
}

/// A failure in an optional startup service must not prevent Flutter from
/// rendering the login or offline UI.
Future<void> _initializeOptionalServices() async {
  AppLog.ungDung(
    'Bắt đầu khởi tạo các dịch vụ tùy chọn',
    khuVuc: 'Khởi động ứng dụng',
  );

  await _runStartupStep('local notifications', () async {
    await NotificationService().init();
    await NotificationManager.instance.init(
      navigatorKey: NotificationRouter.navigatorKey,
      onNotificationTap: NotificationRouter.handleNotificationTap,
    );
  });

  await _runStartupStep('background sync registration', () async {
    await BackgroundSyncService.initializeWorkManager();
    await BackgroundSyncService.registerPeriodicSync();
  });

  if (SupabaseConfig.isConfigured) {
    await _runStartupStep('Supabase', () async {
      await SupabaseConfig.init();
    });
  } else {
    AppLog.chat(
      'Bỏ qua khởi tạo Supabase vì chưa có cấu hình',
      khuVuc: 'Khởi động ứng dụng',
      ketQua:
          'Ứng dụng vẫn tiếp tục chạy, tính năng chat chưa khả dụng ở phiên này.',
    );
  }
}

Future<void> _runStartupStep(
  String name,
  Future<void> Function() action,
) async {
  AppLog.ungDung(
    'Bắt đầu bước khởi tạo',
    khuVuc: 'Khởi động ứng dụng',
    duLieu: {'buoc': name},
  );

  try {
    await action();
    AppLog.ungDung(
      'Hoàn tất bước khởi tạo',
      khuVuc: 'Khởi động ứng dụng',
      duLieu: {'buoc': name},
      ketQua: 'Bước khởi tạo đã chạy xong.',
    );
  } catch (error, stackTrace) {
    AppLog.loi(
      'Bước khởi tạo ứng dụng gặp lỗi',
      khuVuc: 'Khởi động ứng dụng',
      duLieu: {'buoc': name},
      loi: error,
      stackTrace: stackTrace,
      ketQua: 'Đã bỏ qua lỗi để giao diện chính tiếp tục hoạt động.',
    );
  }
}
