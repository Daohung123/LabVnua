import 'dart:developer';

import 'package:aqedu/core/database/portal_local_read_store.dart';
import 'package:aqedu/core/services_root/sqlite/schedure/schedure_sqlite.dart';

import '../models/schedure_student.dart';
import '../services/api_daotao/date_time_helper.dart';
import '../services/api_daotao/schedure_constants.dart';

class CtrlSchedure {
  CtrlSchedure._();

  final ServiceSqlTkb _scheduleStore = ServiceSqlTkb();
  final PortalLocalReadStore _localStore = PortalLocalReadStore();

  static Future<CtrlSchedure> create() async {
    return CtrlSchedure._();
  }

  Future<TkbResponse?> getFullTkbResponse({int? semesterId}) async {
    try {
      return _localStore.schedule();
    } catch (e) {
      log("Lỗi lấy TkbResponse từ SQLite: $e");
      return null;
    }
  }

  Future<List<ThoiKhoaBieu>> getTkbToday() async {
    try {
      final schedules = await _scheduleStore.getAllSchedules();
      final today = DateTimeHelper.getTodayAtMidnight();
      return schedules.where((schedule) {
        final scheduleDate = DateTimeHelper.tryParseDateFlexible(
          schedule.ngayhoc,
        );
        return scheduleDate != null &&
            DateTimeHelper.isSameDay(scheduleDate, today);
      }).toList();
    } catch (e) {
      log("Lỗi lấy TKB hôm nay từ SQLite: $e");
      return [];
    }
  }

  Future<ThoiKhoaBieu> getTkbTodayItem() async {
    try {
      final schedules = await getTkbToday();
      if (schedules.isEmpty) return _createEmptySchedule();
      schedules.sort((a, b) => a.tietBatDau.compareTo(b.tietBatDau));
      return schedules.first;
    } catch (e) {
      log("Lỗi lấy TKB hôm nay từ SQLite: $e");
      return _createEmptySchedule();
    }
  }

  Future<List<ThoiKhoaBieu>> getTkbInSemester() async {
    try {
      return await _scheduleStore.getAllSchedules();
    } catch (e) {
      log("Lỗi lấy lịch học trong kỳ từ SQLite: $e");
      return [];
    }
  }

  ThoiKhoaBieu _createEmptySchedule() {
    return ThoiKhoaBieu(
      thu: 0,
      tietBatDau: 0,
      soTiet: 0,
      tenMon: ScheduleConstants.noScheduleTodayMessage,
      giangVien: '',
      phong: '',
      ngayhoc: '',
    );
  }
}
