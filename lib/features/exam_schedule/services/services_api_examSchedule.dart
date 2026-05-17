import 'dart:convert';
import 'package:aqedu/core/services_root/api_daotao/examSchedule/getExamSchedule.dart';
import 'package:aqedu/core/services_root/sqlite/sessions/core_service_session.dart';
import '../models/model_semester.dart';
import '../models/model_exam_schedule.dart';
import '../models/model_data.dart';

class ServiceApiExamSchedule {
  final String _cookie;
  final String _token;

  ServiceApiExamSchedule._(this._cookie, this._token);

  static Future<ServiceApiExamSchedule> create() async {
    final session = await SqliteServices().getSession();
    if (session == null) throw Exception("Session not found");
    return ServiceApiExamSchedule._(session.cookie, session.token);
  }

  /// Lấy danh sách học kỳ
  Future<List<SemesterModel>> getSemesters() async {
    try {
      final res = await getExamSemestersResponse(_cookie, _token);
      final Map<String, dynamic>? jsonData = res is String ? jsonDecode(res) : (res as Map<String, dynamic>?);
      
      if (jsonData != null && jsonData["result"] == true && jsonData["data"] != null) {
        final List ds = jsonData["data"]["ds_hoc_ky"] ?? [];
        return ds.map((e) => SemesterModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error ServiceApiExamSchedule.getSemesters: $e");
    }
    return [];
  }

  /// Lấy mã đối tượng (ObjectId)
  Future<int?> getObjectId(int hocKy) async {
    try {
      final res = await getExamObjectIdResponse(_cookie, _token, hocKy);
      final Map<String, dynamic>? jsonData = res is String ? jsonDecode(res) : (res as Map<String, dynamic>?);
      
      if (jsonData != null && jsonData["result"] == true && jsonData["data"] != null) {
        final List ds = jsonData["data"]["ds_doi_tuong_tkb"] ?? [];
        if (ds.isNotEmpty) {
          final id = ds[0]["id"] ?? ds[0]["id_dot_dk"] ?? ds[0]["loai_doi_tuong"];
          return int.tryParse(id.toString());
        }
      }
    } catch (e) {
      print("Error ServiceApiExamSchedule.getObjectId: $e");
    }
    return null;
  }

  /// Lấy dữ liệu lịch thi
  Future<LichThiResponse?> getExams(int hocKy, int objectId) async {
    final response = await getExamScheduleResponse(_cookie, _token, hocKy, objectId);
    
    // Thêm log để kiểm tra dữ liệu thực tế từ API
    if (response != null) {
      print("DEBUG: API Response Lịch thi HK $hocKy: ${response.data.dsLichThi.length} item(s)");
    } else {
      print("DEBUG: API Response Lịch thi HK $hocKy: NULL");
    }
    
    return response;
  }
}
