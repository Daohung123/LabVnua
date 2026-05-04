import 'package:aqedu/features/notification/ctrls/ctrl_noti_student.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Nhớ thêm intl vào pubspec.yaml
import '../models/notification_student.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    // Giả sử lấy dữ liệu từ hàm của bạn
    final List<NotificationItem> notifications = getNotification();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Thông báo",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: notifications.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, indent: 80),
        itemBuilder: (context, index) {
          final item = notifications[index];
          final bool isRead = item.isDaDoc ?? false;
          final bool isUrgent = item.isPhaiXem ?? false;

          return Container(
            color: isRead ? Colors.white : Colors.blue.withOpacity(0.05),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: isRead
                        ? Colors.grey[200]
                        : Colors.blue[100],
                    child: Icon(
                      isUrgent ? Icons.priority_high : Icons.notifications_none,
                      color: isUrgent ? Colors.orange : Colors.blue,
                    ),
                  ),
                  if (!isRead)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              title: Text(
                item.tieuDe ?? 'Không có tiêu đề',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
                  color: isRead ? Colors.black87 : Colors.black,
                  fontSize: 15,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    item.noiDung ?? 'Không có nội dung',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 14,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.nguoiGui ?? "N/A",
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                      const Spacer(),
                      Text(
                        item.ngayGui != null
                            ? DateFormat('dd/MM/yyyy').format(item.ngayGui!)
                            : "--/--",
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () => _showDetail(context, item),
            ),
          );
        },
      ),
    );
  }

  void _showDetail(BuildContext context, NotificationItem item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              item.tieuDe ?? "",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Text(item.noiDung ?? ""),
            const SizedBox(height: 20),
            Text(
              "Người gửi: ${item.nguoiGui}",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Text("Đối tượng: ${(item.dsDoiTuong ?? []).join(", ")}"),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
