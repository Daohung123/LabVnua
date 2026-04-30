import '../models/models_inforStudent.dart';
import '../services/services_inforStudent.dart';

class StudentController {
  Map<String, String> getProfile() {
    final data = StudentStaticData.getStudent().data;

    return {
      "name": data.tenDayDu,
      "maSv": data.maSv,
      "ngaySinh": data.ngaySinh,
      "gioiTinh": data.gioiTinh,
      "lop": data.lop,
      "khoa": data.khoa,
      "heDaoTao": data.bacHeDaoTao,
      "nganh": data.nganh,
      "nienKhoa": data.nienKhoa,
    };
  }
}