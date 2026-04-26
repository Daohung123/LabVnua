import "../models/notification_student.dart";

List<NotificationItem> getNotification() {
  try {
    final List<NotificationItem> fakeNotifications = [
      NotificationItem(
        id: "noti_001",
        doiTuongSearch: "sinh_vien",
        doiTuong: 1,
        phanCapSearch: "khoa_cntt",
        phanCapSinhVien: 2,
        tieuDe: "Thông báo nghỉ học",
        noiDung: "Ngày mai toàn bộ sinh viên nghỉ học do bảo trì hệ thống.",
        isPhaiXem: true,
        ngayGui: DateTime.parse("2026-04-25T08:00:00"),
        nguoiGui: "Phòng đào tạo",
        isDaDoc: false,
        dsDoiTuong: ["CNTT1", "CNTT2"],
        isXemPhanHoi: false,
      ),
      NotificationItem(
        id: "noti_002",
        doiTuongSearch: "sinh_vien",
        doiTuong: 1,
        phanCapSearch: "toan_truong",
        phanCapSinhVien: 1,
        tieuDe: "Đóng học phí",
        noiDung: "Hạn đóng học phí học kỳ 2 là ngày 30/04.",
        isPhaiXem: true,
        ngayGui: DateTime.parse("2026-04-24T10:30:00"),
        nguoiGui: "Phòng tài chính",
        isDaDoc: true,
        dsDoiTuong: ["ALL"],
        isXemPhanHoi: false,
        ngayXem: DateTime.parse("2026-04-24T12:00:00"),
      ),
      NotificationItem(
        id: "noti_003",
        doiTuongSearch: "giang_vien",
        doiTuong: 2,
        phanCapSearch: "khoa_cntt",
        phanCapSinhVien: 2,
        tieuDe: "Thực tập doanh nghiệp",
        noiDung: "Danh sách đăng ký thực tập đã được cập nhật.",
        isPhaiXem: false,
        ngayGui: DateTime.parse("2026-04-23T14:15:00"),
        nguoiGui: "Ban quản lý thực tập",
        isDaDoc: false,
        dsDoiTuong: ["CNTT3"],
        isXemPhanHoi: true,
      ),
      NotificationItem(
        id: "noti_004",
        doiTuongSearch: "sinh_vien",
        doiTuong: 1,
        phanCapSearch: "lop",
        phanCapSinhVien: 3,
        tieuDe: "Họp lớp",
        noiDung: "Lớp họp vào 19h tối nay tại phòng A101.",
        isPhaiXem: false,
        ngayGui: DateTime.parse("2026-04-26T09:00:00"),
        nguoiGui: "Lớp trưởng",
        isDaDoc: true,
        dsDoiTuong: ["CNTT1-K18"],
        isXemPhanHoi: true,
        ngayXem: DateTime.parse("2026-04-26T09:30:00"),
      ),
      NotificationItem(
        id: "noti_005",
        doiTuongSearch: "sinh_vien",
        doiTuong: 1,
        phanCapSearch: "khoa",
        phanCapSinhVien: 2,
        tieuDe: "Workshop AI",
        noiDung: "Đăng ký tham gia workshop AI trước ngày 28/04.",
        isPhaiXem: false,
        ngayGui: DateTime.parse("2026-04-22T16:45:00"),
        nguoiGui: "Khoa CNTT",
        isDaDoc: false,
        dsDoiTuong: ["CNTT"],
        isXemPhanHoi: true,
      ),
    ];
    
    return fakeNotifications;
  } catch (e) {
    return [];
  }
}
