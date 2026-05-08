import 'package:aqedu/core/services_root/api_daotao/information_Student/getInformation.dart';

import '../models/models_inforStudent.dart';
import '../models/model_inforStudentFill.dart';

class ServiceInforStudent {
  static Future<InforStudentFillData?> getInforStudentFill(
    String cookie,
    String token,
  ) async {
    try {
      StudentResponse? studentResponse = await getInformationResponse(
        cookie,
        token,
      );
      if (studentResponse == null) {
        print("Lỗi lấy thông tin sinh viên");
        return null;
      }

      StudentData studentData = studentResponse.data;
      print("Thông tin sinh viên đã lấy được:");
      print(studentData);
      InforStudentFillData? student = InforStudentFillData(
        name: studentData.tenDayDu,
        maSv: studentData.maSv,
        ngaySinh: studentData.ngaySinh,
        gioiTinh: studentData.gioiTinh,
        lop: studentData.lop,
        khoa: studentData.khoa,
        heDaoTao: studentData.bacHeDaoTao,
        nganh: studentData.nganh,
        nienKhoa: studentData.nienKhoa,
        trangThai: studentData.hienDienSv,
      );
      print(student);

      return student;
    } catch (e) {
      print("Lỗi getInforStudentFill: $e");
      return null;
    }
  }
}
