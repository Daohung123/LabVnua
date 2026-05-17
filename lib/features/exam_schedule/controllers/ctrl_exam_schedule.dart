import '../models/model_main_object.dart';
import '../models/model_semester.dart';
import '../services/service_sqlite_exam_schedule.dart';
import '../services/services_api_examSchedule.dart';

class CtrlExamSchedule {
  /// Lấy danh sách học kỳ
  static Future<List<SemesterModel>> getSemesters() async {
    try {
      final serviceApi = await ServiceApiExamSchedule.create();
      return await serviceApi.getSemesters();
    } catch (e) {
      print("Error CtrlExamSchedule.getSemesters: $e");
      return [];
    }
  }

  /// Lấy lịch thi (Ưu tiên offline, nếu không có thì đồng bộ)
  static Future<List<LichThi>> getExams(int hocKyId, {bool forceRefresh = false}) async {
    try {
      // 1. Thử lấy offline
      if (!forceRefresh) {
        final offlineExams = await ServiceSqlExamSchedule.getAllExams(hocKyId);
        if (offlineExams.isNotEmpty) return offlineExams;
      }

      // 2. Đồng bộ từ API (Lưu vào SQLite)
      await ServiceSqlExamSchedule.syncExamSchedule(hocKyId);
      
      // 3. Trả về dữ liệu từ SQLite sau khi đồng bộ
      return await ServiceSqlExamSchedule.getAllExams(hocKyId);
    } catch (e) {
      print("Error CtrlExamSchedule.getExams: $e");
      return [];
    }
  }
}
