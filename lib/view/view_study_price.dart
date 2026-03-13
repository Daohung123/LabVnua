import '../ctrl/ctrl_study_price.dart';
import '../model/study_price.dart';
Future<void> viewHocPhi(String cookie, String token) async {
  print("========== HỌC PHÍ SINH VIÊN ==========");
  final ctrl_study_price = ctrlStudyPrice(cookie, token);
  HocPhiResponse? hocPhiResponse = await ctrl_study_price;
  final data = hocPhiResponse!.data;

  print("Total Items : ${data.totalItems}");
  print("Total Pages : ${data.totalPages}");
  print("Tính tổng   : ${data.isTinhTong}");
  print("Show học bổng: ${data.isShowHocBong}");
  print("---------------------------------------");

  for (var hocKy in data.dsHocPhiHocKy) {
    print("====== HỌC KỲ ======");
    print("NHHK        : ${hocKy.nhhk}");
    print("Tên học kỳ  : ${hocKy.tenHocKy}");
    print("Nhóm CT     : ${hocKy.tenNhomCt}");
    print("Học phí     : ${hocKy.hocPhi}");
    print("Miễn giảm   : ${hocKy.mienGiam}");
    print("Được hỗ trợ : ${hocKy.duocHoTro}");
    print("Phải thu    : ${hocKy.phaiThu}");
    print("Học bổng    : ${hocKy.tongHocBong}");
    print("Đã thu      : ${hocKy.daThu}");
    print("Còn nợ      : ${hocKy.conNo}");
    print("Đơn giá     : ${hocKy.donGia}");
    print("Ghi chú     : ${hocKy.ghiChu}");
    print("---------------------------------------");
  }
}