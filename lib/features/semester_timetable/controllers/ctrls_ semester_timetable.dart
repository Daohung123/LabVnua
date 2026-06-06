import 'dart:developer';

import 'package:aqedu/core/services_root/api_daotao/schedure/getTkbResponse.dart';
import 'package:aqedu/core/services_root/api_daotao/semester_timetable/getSemesterTimetable.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/services_get_cookie_token.dart';

import '../models/model_semester_timetable.dart';
import '../services/services_api_semester_timetable_copy.dart';

class CtrlsemesterTimetable {
  final String _cookie;
  final String _token;

  CtrlsemesterTimetable._(this._cookie, this._token);

  static Future<CtrlsemesterTimetable> create() async {
    final cookie = await GETDB.getCookie();
    final token = await GETDB.getToken();

    return CtrlsemesterTimetable._(cookie, token);
  }

  /// Lấy response đầy đủ từ API
  Future<SemesterTimetableResponse?> getFullTkbResponse({
    int? semesterId,
  }) async {
    try {
      return await getSemesterTimetableResponse(_cookie, _token);
    } catch (e) {
      log("Lỗi lấy SemesterTimetableResponse: $e");
      return null;
    }
  }

  /// Lấy toàn bộ danh sách lịch học của học kỳ
  Future<List<SemesterTimetableItem>> getTkbInSemester({
    int? semesterId,
  }) async {
    try {
      final response = await getFullTkbResponse(semesterId: semesterId);

      return response?.data?.dsNhomTo ?? [];
    } catch (e) {
      log("Lỗi lấy TKB học kỳ: $e");
      return [];
    }
  }

  /// Lấy môn đầu tiên trong danh sách
  Future<SemesterTimetableItem?> getFirstClass({int? semesterId}) async {
    try {
      final list = await getTkbInSemester(semesterId: semesterId);

      if (list.isEmpty) return null;

      return list.first;
    } catch (e) {
      log("Lỗi lấy môn đầu tiên: $e");
      return null;
    }
  }

  /// Lọc theo thứ
  Future<List<SemesterTimetableItem>> getByWeekday(
    int thu, {
    int? semesterId,
  }) async {
    try {
      final list = await getTkbInSemester(semesterId: semesterId);

      return list.where((e) => e.thu == thu).toList();
    } catch (e) {
      log("Lỗi lọc theo thứ: $e");
      return [];
    }
  }

  /// Lấy lịch hôm nay
  Future<List<SemesterTimetableItem>> getTodaySchedule({
    int? semesterId,
  }) async {
    try {
      int thu = DateTime.now().weekday + 1;

      if (thu > 7) {
        thu = 1; // Chủ nhật
      }

      return await getByWeekday(thu, semesterId: semesterId);
    } catch (e) {
      log("Lỗi lấy lịch hôm nay: $e");
      return [];
    }
  }

  /// Lấy môn tiếp theo trong ngày
  Future<SemesterTimetableItem?> getNextClass({int? semesterId}) async {
    try {
      final todayList = await getTodaySchedule(semesterId: semesterId);

      if (todayList.isEmpty) return null;

      todayList.sort(
        (a, b) => (a.tietBatDau ?? 0).compareTo(b.tietBatDau ?? 0),
      );

      final now = DateTime.now();

      for (final item in todayList) {
        if (item.tuGio == null) continue;

        final parts = item.tuGio!.split(':');

        if (parts.length < 2) continue;

        final hour = int.tryParse(parts[0]) ?? 0;
        final minute = int.tryParse(parts[1]) ?? 0;

        if (hour > now.hour || (hour == now.hour && minute > now.minute)) {
          return item;
        }
      }

      return null;
    } catch (e) {
      log("Lỗi lấy môn tiếp theo: $e");
      return null;
    }
  }

  /// Lấy danh sách theo mã tổ học
  Future<List<SemesterTimetableItem>> getByIdToHoc(
    String idToHoc, {
    int? semesterId,
  }) async {
    try {
      final list = await getTkbInSemester(semesterId: semesterId);

      return list.where((e) => e.idToHoc == idToHoc).toList();
    } catch (e) {
      log("Lỗi lọc theo id_to_hoc: $e");
      return [];
    }
  }

  /// Tìm kiếm theo tên môn
  Future<List<SemesterTimetableItem>> searchBySubject(
    String keyword, {
    int? semesterId,
  }) async {
    try {
      final list = await getTkbInSemester(semesterId: semesterId);

      return list.where((e) {
        return (e.tenMon ?? "").toLowerCase().contains(keyword.toLowerCase());
      }).toList();
    } catch (e) {
      log("Lỗi tìm kiếm môn học: $e");
      return [];
    }
  }

  loadData() {}
}
