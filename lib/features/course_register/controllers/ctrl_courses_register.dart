import 'package:aqedu/core/database/portal_read_sync_coordinator.dart';
import 'package:aqedu/core/logging/app_log.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/services_get_cookie_token.dart';
import 'package:aqedu/features/infor/models/models_infor_student.dart';

import '../models/model_course_register.dart';
import '../models/model_course_register_action.dart';
import '../models/model_course_register_fillter.dart';
import '../models/model_course_register_results.dart';
import '../services/service_course_register_student.dart';
import '../services/service_courses_register.dart';
import '../services/service_courses_register_action.dart';
import '../services/service_courses_register_fillter.dart';
import '../services/service_courses_register_results.dart';

class CourseRegisterScreenData {
  const CourseRegisterScreenData({
    required this.filters,
    required this.catalog,
    required this.student,
    this.syncResult,
  });

  final List<CourseRegisterFilter> filters;
  final CourseRegisterResponse? catalog;
  final StudentData? student;
  final PortalSyncResult? syncResult;

  bool get hasCatalog => catalog != null;
}

class CtrlCourseRegister {
  CtrlCourseRegister._(
    this._cookie,
    this._token, {
    PortalReadSyncCoordinator? syncCoordinator,
  }) : _syncCoordinator = syncCoordinator ?? PortalReadSyncCoordinator();

  final String _cookie;
  final String _token;
  final PortalReadSyncCoordinator _syncCoordinator;

  static Future<CtrlCourseRegister> create() async {
    final cookie = await GETDB.getCookie();
    final token = await GETDB.getToken();

    return CtrlCourseRegister._(cookie, token);
  }

  Future<CourseRegisterScreenData> loadScreenData({
    bool forceRefresh = false,
  }) async {
    var data = await _readLocalScreenData();
    final shouldRefresh =
        forceRefresh || !data.hasCatalog || data.filters.isEmpty;

    if (!shouldRefresh) return data;

    final syncResult = await _syncCoordinator.refreshCourseRegistration();
    AppLog.dongBo(
      'Làm mới dữ liệu đăng ký học phần',
      khuVuc: 'Đăng ký học phần',
      duLieu: {
        'tong_so_nguon': syncResult.total,
        'thanh_cong': syncResult.success,
        'that_bai': syncResult.failed,
      },
    );

    data = await _readLocalScreenData(syncResult: syncResult);
    if (!data.hasCatalog && syncResult.failedResources.isNotEmpty) {
      throw StateError(
        'Không thể tạo dữ liệu đăng ký học phần từ nguồn đồng bộ.',
      );
    }

    return data;
  }

  Future<CourseRegisterScreenData> _readLocalScreenData({
    PortalSyncResult? syncResult,
  }) async {
    final filters = await CourseRegisterFilterService.getFilters();
    final catalog = await CourseRegisterService.getCourseRegisterFull();
    final student = await CourseRegisterStudentService.getStudentData();

    return CourseRegisterScreenData(
      filters: filters,
      catalog: catalog,
      student: student,
      syncResult: syncResult,
    );
  }

  Future<List<CourseRegisterFilter>> getFilters() async {
    try {
      return await CourseRegisterFilterService.getFilters();
    } catch (error, stackTrace) {
      AppLog.loi(
        'Không thể đọc bộ lọc đăng ký học phần',
        khuVuc: 'Đăng ký học phần',
        loi: error,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  Future<List<CourseRegisterClass>> getClasses() async {
    try {
      return await CourseRegisterService.getClasses();
    } catch (error, stackTrace) {
      AppLog.loi(
        'Không thể đọc danh sách lớp học phần',
        khuVuc: 'Đăng ký học phần',
        loi: error,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  Future<CourseRegisterActionResponse?> actionCourseRegister({
    required String idToHoc,
    required bool isChecked,
    required int svNganh,
    required String idRs,
  }) async {
    try {
      final response = await CourseRegisterActionService.actionCourseRegister(
        _cookie,
        _token,
        idToHoc: idToHoc,
        isChecked: isChecked,
        svNganh: svNganh,
        idRs: idRs,
      );
      if (response?.data?.isThanhCong == true) {
        await _syncCoordinator.refreshCourseRegistration();
      }
      return response;
    } catch (error, stackTrace) {
      AppLog.loi(
        'Thao tác đăng ký học phần gặp lỗi',
        khuVuc: 'Đăng ký học phần',
        loi: error,
        stackTrace: stackTrace,
        duLieu: {'la_dang_ky': isChecked},
      );
      return null;
    }
  }

  Future<CourseRegisterResultResponse?> getCourseRegisterResult() async {
    try {
      return await CourseRegisterResultService.getCourseRegisterResult();
    } catch (error, stackTrace) {
      AppLog.loi(
        'Không thể đọc kết quả đăng ký học phần',
        khuVuc: 'Đăng ký học phần',
        loi: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<CourseRegisterResponse?> getCourseRegisterFull() async {
    try {
      return await CourseRegisterService.getCourseRegisterFull();
    } catch (error, stackTrace) {
      AppLog.loi(
        'Không thể đọc dữ liệu đăng ký học phần',
        khuVuc: 'Đăng ký học phần',
        loi: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<StudentData?> getStudentData() async {
    try {
      return await CourseRegisterStudentService.getStudentData();
    } catch (error, stackTrace) {
      AppLog.loi(
        'Không thể đọc hồ sơ sinh viên cho đăng ký học phần',
        khuVuc: 'Đăng ký học phần',
        loi: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }
}
