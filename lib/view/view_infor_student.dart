import '../ctrl/ctrl_infor.dart';
import '../model/infor_Student.dart/student_response.dart';

Future<void> view_infor_student(String cookie, String token) async {

  StudentResponse? res = await ctrl_infor_Student(cookie, token);

  if (res == null) {
    print("❌ Không lấy được dữ liệu sinh viên");
    return;
  }

  if (!res.result) {
    print("❌ API trả về lỗi, code: ${res.code}");
    return;
  }

  final student = res.data;

  print("========= THÔNG TIN SINH VIÊN =========");
  print("Mã SV: ${student.maSv}");
  print("Họ tên: ${student.tenDayDu}");
  print("Giới tính: ${student.gioiTinh}");
  print("Ngày sinh: ${student.ngaySinh}");
  print("Nơi sinh: ${student.noiSinh}");
  print("Dân tộc: ${student.danToc}");
  print("Quốc tịch: ${student.quocTich}");
  print("Điện thoại: ${student.dienThoai}");
  print("Email: ${student.email}");
  print("Số CMND/CCCD: ${student.soCmnd}");
  print("Lớp: ${student.lop}");
  print("Ngành: ${student.nganh}");
  print("Khoa: ${student.khoa}");
  print("Niên khóa: ${student.nienKhoa}");
  print("Trường: ${student.tenTruong}");
  print("Hiện diện SV: ${student.hienDienSv}");
  print("=======================================");
}