import 'package:aqedu/features/notification/ctrls/ctrl_noti_student.dart';
import 'package:flutter/material.dart';


class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = getNotification(); // ✅ gọi trực tiếp

    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông báo"),
      ),
      body: notifications.isEmpty
          ? const Center(child: Text("Không có thông báo"))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: Icon(
                      item.isDaDoc == true
                          ? Icons.notifications_none
                          : Icons.notifications_active,
                    ),
                    title: Text(
                      item.tieuDe ?? "",
                      style: TextStyle(
                        fontWeight: item.isDaDoc == true
                            ? FontWeight.normal
                            : FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.noiDung ?? ""),
                        const SizedBox(height: 4),
                        Text(
                          "${item.nguoiGui ?? ""} • ${_formatDate(item.ngayGui)}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (item.isPhaiXem == true)
                          const Icon(Icons.priority_high, size: 18),
                        if (item.isXemPhanHoi == true)
                          const Icon(Icons.reply, size: 18),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "";
    return "${date.day}/${date.month}/${date.year}";
  }
}