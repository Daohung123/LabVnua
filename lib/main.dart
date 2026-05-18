import 'dart:async';
import 'dart:io';
import 'package:aqedu/core/services_root/notification/notification_manager.dart';
import 'package:aqedu/core/services_root/notification/notification_router.dart';
import 'package:aqedu/core/services_root/supabase/supabase_config.dart';
import 'package:flutter/material.dart';
import 'package:aqedu/features/notification/services/background_sync_service.dart';
import 'package:aqedu/features/notification/services/notification_service.dart';
import './config/http_override.dart';
import 'app.dart';

// Khởi động app
// Init config
// Gọi runApp()

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  await NotificationService().init();
  await NotificationManager.instance.init(
    navigatorKey: NotificationRouter.navigatorKey,
    onNotificationTap: NotificationRouter.handleNotificationTap,
  );
  await BackgroundSyncService.initializeWorkManager();
  await BackgroundSyncService.registerPeriodicSync();

  //config DB
  await SupabaseConfig.init();
  unawaited(BackgroundSyncService().checkNow());

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    navigatorKey: NotificationRouter.navigatorKey,
    home: const MyWidget(),
  ));
}
