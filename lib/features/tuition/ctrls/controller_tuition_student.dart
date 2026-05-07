import '../models/model_item.dart';
import '../models/model_data.dart';
import '../models/models_tuition.dart';

List<HocPhiHocKy> getFakeTuition() {
  try {
    final List<HocPhiHocKy> FakeTuition = [
      HocPhiHocKy(
        nhhk: 1,
        tenNhomCt: "Chương trinh đào tạo",
        tenHocKy: "Học kì 1 - Năm học 2024-2025",
        hocPhi: "9392000000",
        mienGiam: "0",
        duocHoTro: '0',
        phaiThu: '9392000000',
        tongHocBong: "0",
        daThu: "9000000000",
        conNo: "392000000",
        ghiChu: "Vui lòng thanh toán nốt số tiền còn lại ! ",
        donGia: "9392000000",
      ),
      HocPhiHocKy(
        nhhk: 2,
        tenNhomCt: "Chương trinh đào tạo",
        tenHocKy: "Học kỳ 2 - Năm học 2025 - 2026",
        hocPhi: "9200000",
        mienGiam: "0",
        duocHoTro: "500000",
        phaiThu: "8700000",
        tongHocBong: "1500000",
        daThu: "8700000",
        conNo: "0",
        ghiChu: "Đã hoàn thành học phí.",
        donGia: "920000",
      ),
      HocPhiHocKy(
        nhhk: 3,
        tenNhomCt: "Chương trinh đào tạo",
        tenHocKy: "Học kỳ 3 - Năm học 2025 - 2026",
        hocPhi: "4500000",
        mienGiam: "0",
        duocHoTro: "0",
        phaiThu: "4500000",
        tongHocBong: "0",
        daThu: "2000000",
        conNo: "2500000",
        ghiChu: "Cần thanh toán phần còn lại trước 15/06.",
        donGia: "900000",
      ),
    ];

    return FakeTuition;
  } catch (e) {
    return [];
  }
}
