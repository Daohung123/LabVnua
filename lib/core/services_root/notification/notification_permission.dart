import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationPermission {
  NotificationPermission._();

  static Future<bool> request(FlutterLocalNotificationsPlugin plugin) async {
    final androidImpl =
        plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    final bool androidGranted =
        await androidImpl?.requestNotificationsPermission() ?? true;

    bool iosGranted = true;
    if (Platform.isIOS) {
      final iosImpl =
          plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      final bool? iosPermissionGranted = await iosImpl?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      iosGranted = iosPermissionGranted ?? true;
    } else if (Platform.isMacOS) {
      final macImpl =
          plugin.resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>();
      final bool? macPermissionGranted = await macImpl?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      iosGranted = macPermissionGranted ?? true;
    }

    return androidGranted && iosGranted;
  }
}
