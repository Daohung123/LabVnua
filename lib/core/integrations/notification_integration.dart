import 'package:aqedu/core/services_root/notification/notification_manager.dart';
import 'package:aqedu/core/services_root/notification/notification_router.dart';
import 'package:aqedu/features/notification/services/background_sync_service.dart';
import 'package:aqedu/features/notification/services/notification_service.dart';

class NotificationIntegration {
  const NotificationIntegration();

  Future<void> initLocalNotifications() async {
    await NotificationService().init();
    await NotificationManager.instance.init(
      navigatorKey: NotificationRouter.navigatorKey,
      onNotificationTap: NotificationRouter.handleNotificationTap,
    );
  }

  Future<void> registerBackgroundSync() async {
    await BackgroundSyncService.initializeWorkManager();
    await BackgroundSyncService.registerPeriodicSync();
  }

  Future<void> checkNow() => BackgroundSyncService().checkNow();
}
