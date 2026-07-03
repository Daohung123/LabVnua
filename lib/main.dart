import 'dart:async';
import 'dart:io';

import 'package:aqedu/core/services_root/notification/notification_manager.dart';
import 'package:aqedu/core/services_root/notification/notification_router.dart';
import 'package:aqedu/core/services_root/supabase/supabase_config.dart';
import 'package:aqedu/features/notification/services/background_sync_service.dart';
import 'package:aqedu/features/notification/services/notification_service.dart';
import 'package:flutter/material.dart';

import './config/http_override.dart';
import 'app.dart';

/// Starts the UI before optional native and remote services.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: NotificationRouter.navigatorKey,
      home: const MyWidget(),
    ),
  );

  unawaited(_initializeOptionalServices());
}

/// A failure in an optional startup service must not prevent Flutter from
/// rendering the login or offline UI.
Future<void> _initializeOptionalServices() async {
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
    debugPrint(
      'Supabase is not configured. Chat is unavailable, but the app can continue.',
    );
  }

  unawaited(
    _runStartupStep('initial background sync', () async {
      await BackgroundSyncService().checkNow();
    }),
  );
}

Future<void> _runStartupStep(
  String name,
  Future<void> Function() action,
) async {
  try {
    await action();
  } catch (error, stackTrace) {
    debugPrint('Startup step "$name" failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }
}
