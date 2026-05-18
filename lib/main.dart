import 'dart:async';
import 'dart:io';
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
  await BackgroundSyncService.initializeWorkManager();
  await BackgroundSyncService.registerPeriodicSync();
  unawaited(BackgroundSyncService().checkNow());

  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyWidget()));
}
