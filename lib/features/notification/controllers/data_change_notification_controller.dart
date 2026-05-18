import 'package:aqedu/core/services_root/sqlite/notification/data_change_sqlite.dart';
import 'package:aqedu/features/notification/models/data_change_models.dart';
import 'package:aqedu/features/notification/services/background_sync_service.dart';
import 'package:flutter/foundation.dart';

class DataChangeNotificationController extends ChangeNotifier {
  final DataChangeSqliteService _sqliteService;
  final BackgroundSyncService _backgroundSyncService;

  bool isLoading = false;
  int unreadCount = 0;
  List<DataChange> history = [];

  DataChangeNotificationController({
    DataChangeSqliteService? sqliteService,
    BackgroundSyncService? backgroundSyncService,
  }) : _sqliteService = sqliteService ?? DataChangeSqliteService(),
       _backgroundSyncService =
           backgroundSyncService ?? BackgroundSyncService();

  Future<void> loadHistory() async {
    isLoading = true;
    notifyListeners();

    history = await _sqliteService.getHistory();
    unreadCount = await _sqliteService.countUnread();

    isLoading = false;
    notifyListeners();
  }

  Future<BackgroundSyncResult> refreshNow() async {
    final result = await _backgroundSyncService.checkNow();
    await loadHistory();
    return result;
  }

  Future<void> markAsRead(String id) async {
    await _sqliteService.markAsRead(id);
    await loadHistory();
  }
}
