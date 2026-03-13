class NotificationResponse {
  final NotificationData data;

  NotificationResponse({required this.data});

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      data: NotificationData.fromJson(json['data']),
    );
  }
}

class NotificationData {
  final int totalItems;
  final int totalPages;
  final int notification;
  final List<ThongBao> dsThongBao;

  NotificationData({
    required this.totalItems,
    required this.totalPages,
    required this.notification,
    required this.dsThongBao,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      totalItems: json['total_items'],
      totalPages: json['total_pages'],
      notification: json['notification'],
      dsThongBao: (json['ds_thong_bao'] as List)
          .map((e) => ThongBao.fromJson(e))
          .toList(),
    );
  }
}

class ThongBao {
  final String id;
  final String tieuDe;
  final String noiDung;
  final String ngayGui;
  final String nguoiGui;
  final bool isDaDoc;

  ThongBao({
    required this.id,
    required this.tieuDe,
    required this.noiDung,
    required this.ngayGui,
    required this.nguoiGui,
    required this.isDaDoc,
  });

  factory ThongBao.fromJson(Map<String, dynamic> json) {
    return ThongBao(
      id: json['id'],
      tieuDe: json['tieu_de'],
      noiDung: json['noi_dung'],
      ngayGui: json['ngay_gui'],
      nguoiGui: json['nguoi_gui'],
      isDaDoc: json['is_da_doc'],
    );
  }
}