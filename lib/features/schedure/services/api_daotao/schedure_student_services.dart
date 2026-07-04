import 'package:aqedu/core/services_root/api_daotao/schedure/get_tkb_response.dart';
import 'package:aqedu/features/schedure/models/schedure_student.dart';
import 'date_time_helper.dart';
import 'schedure_constants.dart';

class TkbService {
  static Future<List<ThoiKhoaBieu>> getScheduleByDayInSemester(
    dynamic cookie,
    String token,
  ) async {
    try {
      final tkb = await core_services_get_TkbResponse(cookie, token);
      if (tkb == null) return [];

      final schedules = <ThoiKhoaBieu>[];
      for (final week in tkb.dsTuanTkb) {
        schedules.addAll(week.dsThoiKhoaBieu);
      }
      return schedules;
    } catch (e) {
      _logError('getScheduleByDayInSemester', e);
      return [];
    }
  }

  static Future<List<ThoiKhoaBieu>> getScheduleInWeek(TkbResponse tkb) async {
    try {
      final today = DateTimeHelper.getTodayAtMidnight();
      return _findScheduleInWeek(tkb.dsTuanTkb, today);
    } catch (e) {
      _logError('getScheduleInWeek', e);
      return [];
    }
  }

  static Future<List<ThoiKhoaBieu>> getScheduleInDay(
    List<ThoiKhoaBieu> scheduleWeek,
  ) async {
    final today = DateTimeHelper.getTodayAtMidnight();
    return _filterScheduleByDate(scheduleWeek, today);
  }

  static Future<ThoiKhoaBieu> getScheduleToday(
    dynamic cookie,
    String token,
  ) async {
    try {
      final tkb = await core_services_get_TkbResponse(cookie, token);
      if (tkb == null) {
        return _createEmptySchedule();
      }

      final scheduleInWeek = await getScheduleInWeek(tkb);
      if (scheduleInWeek.isEmpty) {
        return _createEmptySchedule();
      }

      final today = DateTimeHelper.getTodayAtMidnight();
      return _findTodaySchedule(scheduleInWeek, today);
    } catch (e) {
      _logError('getScheduleToday', e);
      return _createEmptySchedule();
    }
  }

  // ==================== Private Helpers ====================

  static List<ThoiKhoaBieu> _findScheduleInWeek(
    List<TuanTkb> weeks,
    DateTime today,
  ) {
    for (final week in weeks) {
      final startDate = DateTimeHelper.tryParseDate(week.ngayBatDau);
      final endDate = DateTimeHelper.tryParseDate(week.ngayKetThuc);

      if (startDate == null || endDate == null) continue;

      final normalizedStart = DateTimeHelper.normalizeToMidnight(startDate);
      final normalizedEnd = DateTimeHelper.normalizeToMidnight(endDate);

      if (DateTimeHelper.isDateInRange(today, normalizedStart, normalizedEnd)) {
        _logDebug(
          '${ScheduleConstants.foundCurrentWeekSchedule}${week.tuanHocKy}',
        );
        return week.dsThoiKhoaBieu;
      }
    }
    return [];
  }

  static List<ThoiKhoaBieu> _filterScheduleByDate(
    List<ThoiKhoaBieu> schedules,
    DateTime targetDate,
  ) {
    final result = <ThoiKhoaBieu>[];
    for (final schedule in schedules) {
      final scheduleDate = DateTimeHelper.tryParseDateFlexible(
        schedule.ngayhoc,
      );
      if (scheduleDate != null &&
          DateTimeHelper.isSameDay(scheduleDate, targetDate)) {
        result.add(schedule);
      }
    }
    return result;
  }

  static ThoiKhoaBieu _findTodaySchedule(
    List<ThoiKhoaBieu> scheduleInWeek,
    DateTime today,
  ) {
    for (final schedule in scheduleInWeek) {
      final scheduleDate = DateTimeHelper.tryParseDateFlexible(
        schedule.ngayhoc,
      );
      if (scheduleDate != null &&
          DateTimeHelper.isSameDay(scheduleDate, today)) {
        _logDebug('${ScheduleConstants.foundTodaySchedule}${schedule.tenMon}');
        return schedule;
      }
    }
    return _createEmptySchedule();
  }

  static ThoiKhoaBieu _createEmptySchedule() {
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

  static void _logError(String method, dynamic error) {
    // TODO: Replace with proper logging service
    print('$method Error: $error');
  }

  static void _logDebug(String message) {
    // TODO: Replace with proper logging service
    print(message);
  }
}
