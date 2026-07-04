import 'package:aqedu/core/models/sqlite/session.dart';
import 'package:aqedu/core/services_root/api_daotao/course_Register/get_course_register_respone.dart';
import 'package:aqedu/core/services_root/api_daotao/notification/get_notification.dart';
import 'package:aqedu/core/services_root/api_daotao/schedure/get_tkb_response.dart';
import 'package:aqedu/core/services_root/api_daotao/score/get_score_response.dart';
import 'package:aqedu/core/services_root/api_daotao/tuition/get_tuition.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/core_service_session.dart';
import 'package:aqedu/features/course_register/models/model_course_register.dart';
import 'package:aqedu/features/exam_schedule/models/model_exam_schedule.dart';
import 'package:aqedu/features/notification/models/data_change_models.dart';
import 'package:aqedu/features/notification/models/notification_student.dart';
import 'package:aqedu/features/notification/services/data_change_detector_service.dart';
import 'package:aqedu/features/schedure/models/schedure_student.dart';
import 'package:aqedu/features/score_data/models/model_score_student.dart';
import 'package:aqedu/features/tuition/models/models_tuition.dart';

class DataPollingService {
  final SqliteServices _sessionService;
  final DataChangeDetectorService _detector;

  DataPollingService({
    SqliteServices? sessionService,
    DataChangeDetectorService? detector,
  }) : _sessionService = sessionService ?? SqliteServices(),
       _detector = detector ?? DataChangeDetectorService();

  Future<Map<WatchedDataType, List<WatchedDataItem>>> fetchAll() async {
    final session = await _sessionService.getSession();
    if (session == null || session.cookie.isEmpty || session.token.isEmpty) {
      return {};
    }

    final result = <WatchedDataType, List<WatchedDataItem>>{};

    final scores = await fetchScores(session);
    if (scores != null) result[WatchedDataType.score] = scores;

    final schedule = await fetchSchedule(session);
    if (schedule != null) result[WatchedDataType.schedule] = schedule;

    final tuition = await fetchTuition(session);
    if (tuition != null) result[WatchedDataType.tuition] = tuition;

    final notifications = await fetchTrainingNotifications(session);
    if (notifications != null) {
      result[WatchedDataType.trainingNotification] = notifications;
    }

    final courseRegister = await fetchCourseRegister(session);
    if (courseRegister != null) {
      result[WatchedDataType.courseRegister] = courseRegister;
    }

    return result;
  }

  Future<List<WatchedDataItem>?> fetchScores(SessionModel session) async {
    final response = await getScoreResponse(session.cookie, session.token);
    if (response == null) return null;
    return mapScores(response);
  }

  Future<List<WatchedDataItem>?> fetchSchedule(SessionModel session) async {
    final response = await core_services_get_TkbResponse(
      session.cookie,
      session.token,
    );
    if (response == null) return null;
    return mapSchedule(response);
  }

  Future<List<WatchedDataItem>?> fetchTuition(SessionModel session) async {
    final response = await getHocPhiResponse(session.cookie, session.token);
    if (response == null) return null;
    return mapTuition(response);
  }

  Future<List<WatchedDataItem>?> fetchTrainingNotifications(
    SessionModel session,
  ) async {
    final response = await getNotificationResponse(
      session.cookie,
      session.token,
    );
    if (response == null) return null;
    return mapTrainingNotifications(response);
  }

  Future<List<WatchedDataItem>?> fetchCourseRegister(
    SessionModel session,
  ) async {
    final response = await getCourseRegisterResponse(
      session.cookie,
      session.token,
    );
    if (response == null) return null;
    return mapCourseRegister(response);
  }

  List<WatchedDataItem> mapScores(ScoreResponse response) {
    final items = <WatchedDataItem>[];
    final semesters = response.data?.dsDiemHocky ?? [];

    for (final semester in semesters) {
      for (final subject in semester.dsDiemMonHoc ?? <SubjectScore>[]) {
        final entityId = [
          semester.hocKy,
          subject.maMon ?? subject.maMonTt,
          subject.nhomTo,
        ].whereType<String>().join('_');

        items.add(
          _detector.buildItem(
            dataType: WatchedDataType.score,
            entityId: entityId.isEmpty ? subject.hashCode.toString() : entityId,
            title: subject.tenMon ?? subject.maMon ?? 'Môn học',
            payload: {
              ...subject.toJson(),
              'hoc_ky': semester.hocKy,
              'ten_hoc_ky': semester.tenHocKy,
            },
          ),
        );
      }
    }

    return items;
  }

  List<WatchedDataItem> mapSchedule(TkbResponse response) {
    final items = <WatchedDataItem>[];

    for (final week in response.dsTuanTkb) {
      for (final schedule in week.dsThoiKhoaBieu) {
        final entityId = [
          schedule.ngayhoc,
          schedule.thu,
          schedule.tietBatDau,
          schedule.tenMon,
        ].join('_');

        items.add(
          _detector.buildItem(
            dataType: WatchedDataType.schedule,
            entityId: entityId,
            title: schedule.tenMon,
            payload: {
              'tuan_hoc_ky': week.tuanHocKy,
              'thong_tin_tuan': week.thongTinTuan,
              'thu_kieu_so': schedule.thu,
              'tiet_bat_dau': schedule.tietBatDau,
              'so_tiet': schedule.soTiet,
              'ten_mon': schedule.tenMon,
              'ten_giang_vien': schedule.giangVien,
              'ma_phong': schedule.phong,
              'ngay_hoc': schedule.ngayhoc,
            },
          ),
        );
      }
    }

    return items;
  }

  List<WatchedDataItem> mapExamSchedule(LichThiResponse response) {
    return response.data.dsLichThi.map((exam) {
      final entityId = [
        exam.idNhomThi,
        exam.idMonHoc,
        exam.ngayThi,
        exam.tietBatDau,
      ].join('_');

      return _detector.buildItem(
        dataType: WatchedDataType.examSchedule,
        entityId: entityId,
        title: exam.tenMon,
        payload: exam.toJson(),
      );
    }).toList();
  }

  List<WatchedDataItem> mapTuition(HocPhiResponse response) {
    return response.data.dsHocPhiHocKy.map((tuition) {
      return _detector.buildItem(
        dataType: WatchedDataType.tuition,
        entityId: tuition.nhhk.toString(),
        title: tuition.tenHocKy,
        payload: tuition.toJson(),
      );
    }).toList();
  }

  List<WatchedDataItem> mapTrainingNotifications(
    NotificationResponse response,
  ) {
    return (response.data?.dsThongBao ?? <NotificationItem>[]).map((item) {
      return _detector.buildItem(
        dataType: WatchedDataType.trainingNotification,
        entityId: item.id ?? item.hashCode.toString(),
        title: item.tieuDe ?? 'Thông báo đào tạo',
        payload: item.toJson(),
        sourceUpdatedAt: item.ngayGui,
      );
    }).toList();
  }

  List<WatchedDataItem> mapCourseRegister(CourseRegisterResponse response) {
    return (response.data?.dsNhomTo ?? <CourseRegisterClass>[]).map((item) {
      final entityId =
          item.idToHoc ?? '${item.maMon}_${item.nhomTo}_${item.lop}';

      return _detector.buildItem(
        dataType: WatchedDataType.courseRegister,
        entityId: entityId,
        title:
            '${item.tenMon ?? item.maMon ?? 'Học phần'} - ${item.nhomTo ?? ''}',
        payload: item.toJson(),
      );
    }).toList();
  }
}
