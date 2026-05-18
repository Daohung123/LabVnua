import 'dart:async';
import 'dart:ui';

import 'package:aqedu/core/services_root/api_daotao/notification/data_polling_service.dart';
import 'package:aqedu/core/services_root/sqlite/notification/data_change_sqlite.dart';
import 'package:aqedu/features/notification/models/data_change_models.dart';
import 'package:aqedu/features/notification/services/data_change_detector_service.dart';
import 'package:aqedu/features/notification/services/notification_service.dart';
import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';

const String backgroundDataSyncTask = 'background_data_change_sync';

@pragma('vm:entry-point')
void dataChangeBackgroundCallbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    if (task != backgroundDataSyncTask) return true;

    final service = BackgroundSyncService();
    final result = await service.checkNow(notifyOnFirstSync: false);
    return result.success;
  });
}

class BackgroundSyncResult {
  final bool success;
  final int changeCount;
  final Object? error;

  const BackgroundSyncResult({
    required this.success,
    required this.changeCount,
    this.error,
  });
}

class BackgroundSyncService {
  final DataPollingService _pollingService;
  final DataChangeSqliteService _sqliteService;
  final DataChangeDetectorService _detectorService;
  final NotificationService _notificationService;

  static bool _running = false;

  BackgroundSyncService({
    DataPollingService? pollingService,
    DataChangeSqliteService? sqliteService,
    DataChangeDetectorService? detectorService,
    NotificationService? notificationService,
  }) : _pollingService = pollingService ?? DataPollingService(),
       _sqliteService = sqliteService ?? DataChangeSqliteService(),
       _detectorService = detectorService ?? DataChangeDetectorService(),
       _notificationService = notificationService ?? NotificationService();

  static Future<void> initializeWorkManager() async {
    await Workmanager().initialize(
      dataChangeBackgroundCallbackDispatcher,
      isInDebugMode: false,
    );
  }

  static Future<void> registerPeriodicSync({
    Duration frequency = const Duration(minutes: 30),
  }) async {
    await Workmanager().registerPeriodicTask(
      backgroundDataSyncTask,
      backgroundDataSyncTask,
      frequency: frequency,
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      backoffPolicy: BackoffPolicy.exponential,
      backoffPolicyDelay: const Duration(minutes: 10),
    );
  }

  static Future<void> runOneOffSync() async {
    await Workmanager().registerOneOffTask(
      '${backgroundDataSyncTask}_${DateTime.now().millisecondsSinceEpoch}',
      backgroundDataSyncTask,
      constraints: Constraints(networkType: NetworkType.connected),
      backoffPolicy: BackoffPolicy.exponential,
      backoffPolicyDelay: const Duration(minutes: 10),
    );
  }

  Future<BackgroundSyncResult> checkNow({
    bool notifyOnFirstSync = false,
  }) async {
    if (_running) {
      return const BackgroundSyncResult(success: true, changeCount: 0);
    }

    _running = true;

    try {
      await _notificationService.init();
      final fetchedData = await _pollingService.fetchAll();
      var totalChanges = 0;

      for (final entry in fetchedData.entries) {
        final changes = await _syncDataType(
          dataType: entry.key,
          newItems: entry.value,
          notifyOnFirstSync: notifyOnFirstSync,
        );
        totalChanges += changes;
      }

      return BackgroundSyncResult(success: true, changeCount: totalChanges);
    } catch (error) {
      return BackgroundSyncResult(success: false, changeCount: 0, error: error);
    } finally {
      _running = false;
    }
  }

  Future<int> _syncDataType({
    required WatchedDataType dataType,
    required List<WatchedDataItem> newItems,
    required bool notifyOnFirstSync,
  }) async {
    final oldItems = await _sqliteService.getCachedItems(dataType);
    final isFirstSync = oldItems.isEmpty;

    final detectedChanges = isFirstSync && !notifyOnFirstSync
        ? <DataChange>[]
        : _detectorService.compare(
            dataType: dataType,
            oldItems: oldItems,
            newItems: newItems,
          );

    final insertedChanges = await _sqliteService.insertChanges(detectedChanges);
    await _sqliteService.replaceCachedItems(dataType, newItems);

    for (final change in insertedChanges) {
      await _notificationService.showDataChange(change);
      await _sqliteService.markNotified(change.changeId);
    }

    return insertedChanges.length;
  }
}
