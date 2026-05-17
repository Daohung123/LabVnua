import 'package:aqedu/core/services_root/sqlite/exam_schedule/exam_schedule_sqlite.dart';
import '../models/model_main_object.dart';
import '../models/model_semester.dart';
import '../models/model_exam_schedule.dart';
import 'services_api_examSchedule.dart';

class ServiceSqlExamSchedule {
  /// Đồng bộ lịch thi từ API vào SQLite
  static Future<void> syncExamSchedule(int hocKy) async {
    try {
      final ServiceApiExamSchedule serviceApi = await ServiceApiExamSchedule.create();
      
      // 1. Lấy ObjectId
      final objectId = await serviceApi.getObjectId(hocKy);
      if (objectId == null) {
        print("Không lấy được ObjectId cho học kỳ $hocKy");
        return;
      }

      // 2. Lấy Lịch thi từ API
      final response = await serviceApi.getExams(hocKy, objectId);

      // 3. Kiểm tra response.data và lưu vào SQLite nếu có dữ liệu
      if (response != null && response.data.dsLichThi.isNotEmpty) {
        final ServiceSqlExamScheduleRoot serviceSql = ServiceSqlExamScheduleRoot();
        await serviceSql.insertExams(response.data.dsLichThi, hocKy);
        print("Đã đồng bộ ${response.data.dsLichThi.length} lịch thi cho HK $hocKy");
      } else {
        print("API trả về dữ liệu lịch thi trống cho HK $hocKy");
      }
    } catch (e) {
      print("Error ServiceSqlExamSchedule.syncExamSchedule: $e");
    }
  }

  /// Lấy tất cả lịch thi từ SQLite
  static Future<List<LichThi>> getAllExams(int hocKy) async {
    final ServiceSqlExamScheduleRoot serviceSql = ServiceSqlExamScheduleRoot();
    return await serviceSql.getExamsBySemester(hocKy);
  }
}
