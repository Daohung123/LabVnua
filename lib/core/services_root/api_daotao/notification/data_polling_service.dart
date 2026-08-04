import 'package:aqedu/core/database/portal_local_read_store.dart';
import 'package:aqedu/features/course_register/models/model_course_register.dart';
import 'package:aqedu/features/exam_schedule/models/model_exam_schedule.dart';
import 'package:aqedu/features/notification/models/data_change_models.dart';
import 'package:aqedu/features/notification/models/notification_student.dart';
import 'package:aqedu/features/notification/services/data_change_detector_service.dart';
import 'package:aqedu/features/schedure/models/schedure_student.dart';
import 'package:aqedu/features/score_data/models/model_score_student.dart';
import 'package:aqedu/features/tuition/models/models_tuition.dart';

class DataPollingService {
  final DataChangeDetectorService _detector;

  DataPollingService({DataChangeDetectorService? detector})
    : _detector = detector ?? DataChangeDetectorService();

  Future<Map<WatchedDataType, List<WatchedDataItem>>> fetchAll() async {
    final result = <WatchedDataType, List<WatchedDataItem>>{};
    const local = PortalLocalReadStore();

    final scores = await local.scores();
    if (scores != null) {
      result[WatchedDataType.score] = mapScores(scores);
    }

    final schedule = await local.schedule();
    if (schedule != null) {
      result[WatchedDataType.schedule] = mapSchedule(schedule);
    }

    final tuition = await local.tuition();
    if (tuition != null) {
      result[WatchedDataType.tuition] = mapTuition(tuition);
    }

    final notificationResponse = await local.notifications();
    final notifications = notificationResponse == null
        ? null
        : mapTrainingNotifications(notificationResponse);
    if (notifications != null) {
      result[WatchedDataType.trainingNotification] = notifications;
    }

    final courseRegisterResponse = await local.courseRegisterCatalog();
    final courseRegister = courseRegisterResponse == null
        ? null
        : mapCourseRegister(courseRegisterResponse);
    if (courseRegister != null) {
      result[WatchedDataType.courseRegister] = courseRegister;
    }

    return result;
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
