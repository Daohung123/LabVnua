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

      StudentData studentDataFill = studentResponse.data;

      InforStudentFillData? student = InforStudentFillData(
        name: studentDataFill.tenDayDu,
        maSv: studentDataFill.maSv,
        ngaySinh: studentDataFill.ngaySinh,
        gioiTinh: studentDataFill.gioiTinh,
        lop: studentDataFill.lop,
        khoa: studentDataFill.khoa,
        heDaoTao: studentDataFill.bacHeDaoTao,
        nganh: studentDataFill.nganh,
        nienKhoa: studentDataFill.nienKhoa,
        trangThai: studentDataFill.hienDienSv,
      );

      return student;
    } catch (e) {
      print("Lỗi getInforStudentFill: $e");
      return null;
    }
  }
}
