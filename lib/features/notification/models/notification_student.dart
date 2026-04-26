class NotificationResponse {
  final NotificationData? data;

  NotificationResponse({this.data});//constructor == ham khoi tao 

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      data: json['data'] != null
          ? NotificationData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
    };
  }
}

class NotificationData {
  final int? totalItems;
  final int? totalPages;
  final int? notification;
  final List<NotificationItem>? dsThongBao;

  NotificationData({
    this.totalItems,
    this.totalPages,
    this.notification,
    this.dsThongBao,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      totalItems: json['total_items'],
      totalPages: json['total_pages'],
      notification: json['notification'],
      dsThongBao: (json['ds_thong_bao'] as List<dynamic>?)
          ?.map((e) => NotificationItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_items': totalItems,
      'total_pages': totalPages,
      'notification': notification,
      'ds_thong_bao': dsThongBao?.map((e) => e.toJson()).toList(),
    };
  }
}

class NotificationItem {
  final String? id;
  final String? doiTuongSearch;
  final int? doiTuong;
  final String? phanCapSearch;
  final int? phanCapSinhVien;
  final String? tieuDe;
  final String? noiDung;
  final bool? isPhaiXem;
  final DateTime? ngayGui;
  final String? nguoiGui;
  final bool? isDaDoc;
  final List<dynamic>? dsDoiTuong;
  final bool? isXemPhanHoi;
  final DateTime? ngayXem;

  NotificationItem({
    this.id,
    this.doiTuongSearch,
    this.doiTuong,
    this.phanCapSearch,
    this.phanCapSinhVien,
    this.tieuDe,
    this.noiDung,
    this.isPhaiXem,
    this.ngayGui,
    this.nguoiGui,
    this.isDaDoc,
    this.dsDoiTuong,
    this.isXemPhanHoi,
    this.ngayXem,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      doiTuongSearch: json['doi_tuong_search'],
      doiTuong: json['doi_tuong'],
      phanCapSearch: json['phan_cap_search'],
      phanCapSinhVien: json['phan_cap_sinh_vien'],
      tieuDe: json['tieu_de'],
      noiDung: json['noi_dung'],
      isPhaiXem: json['is_phai_xem'],
      ngayGui: json['ngay_gui'] != null
          ? DateTime.parse(json['ngay_gui'])
          : null,
      nguoiGui: json['nguoi_gui'],
      isDaDoc: json['is_da_doc'],
      dsDoiTuong: json['ds_doi_tuong'],
      isXemPhanHoi: json['is_xem_phan_hoi'],
      ngayXem: json['ngay_xem'] != null
          ? DateTime.parse(json['ngay_xem'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doi_tuong_search': doiTuongSearch,
      'doi_tuong': doiTuong,
      'phan_cap_search': phanCapSearch,
      'phan_cap_sinh_vien': phanCapSinhVien,
      'tieu_de': tieuDe,
      'noi_dung': noiDung,
      'is_phai_xem': isPhaiXem,
      'ngay_gui': ngayGui?.toIso8601String(),
      'nguoi_gui': nguoiGui,
      'is_da_doc': isDaDoc,
      'ds_doi_tuong': dsDoiTuong,
      'is_xem_phan_hoi': isXemPhanHoi,
      'ngay_xem': ngayXem?.toIso8601String(),
    };
  }
}   