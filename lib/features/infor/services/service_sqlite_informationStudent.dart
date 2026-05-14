

import 'package:aqedu/core/services_root/sqlite/infomationStudent/information_sqlite.dart';
import 'package:aqedu/features/infor/models/model_inforStudentFill.dart';
import 'package:aqedu/features/infor/models/models_inforStudent.dart';
import 'package:aqedu/features/infor/services/services_api_informationStudent.dart';

class ServiceSqlInformationStudent {
  static Future<void> syncInformation() async {
    final ServiceSqlInformationStudentRoot serviceSql =
        ServiceSqlInformationStudentRoot();

    final ServiceApiInforStudent serviceApi =
        await ServiceApiInforStudent.create();

    final StudentData? result = await serviceApi.getStudentInformation();

    if (result == null) {
      print("Lỗi lấy thông tin sinh viên từ API");
      return;
    }

    await serviceSql.insertStudent(result);
  }

  static Future<StudentData?> getAllInformation() async {
    final ServiceSqlInformationStudentRoot serviceSql =
        ServiceSqlInformationStudentRoot();

    return await serviceSql.getStudent();
  }

  static Future<InforStudentFillData?> getInforStudentFill() async {
    try {
      final StudentData? data = await getAllInformation();
      if (data == null) {
        print("Lỗi lấy thông tin sinh viên từ SQLite");
        return null;
      }
      InforStudentFillData? student = InforStudentFillData(
        name: data.tenDayDu,
        maSv: data.maSv,
        ngaySinh: data.ngaySinh,
        gioiTinh: data.gioiTinh,
        lop: data.lop,
        khoa: data.khoa,
        heDaoTao: data.bacHeDaoTao,
        nganh: data.nganh,
        nienKhoa: data.nienKhoa,
        trangThai: data.hienDienSv,
      );
      return student;
    } catch (e) {
      print("Lỗi getInforStudentFill: $e");
      return null;
    }
  }
}