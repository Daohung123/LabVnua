import 'package:aqedu/features/exam_schedule/models/model_main_object.dart';

class LichThiData {
  final int totalItems;
  final int totalPages;
  final bool isDhmo;
  final List<LichThi> dsLichThi;
  final List<dynamic> dsLichHoanThi;
  final String titleLichHoanThi;
  final String thongBaoNoHocPhi;
  final bool isShowInSvDuThi;

  LichThiData({
    required this.totalItems,
    required this.totalPages,
    required this.isDhmo,
    required this.dsLichThi,
    required this.dsLichHoanThi,
    required this.titleLichHoanThi,
    required this.thongBaoNoHocPhi,
    required this.isShowInSvDuThi,
  });

  factory LichThiData.fromJson(Map<String, dynamic> json) {
    return LichThiData(
      totalItems: json['total_items'],
      totalPages: json['total_pages'],
      isDhmo: json['is_DHMO'],
      dsLichThi: (json['ds_lich_thi'] as List)
          .map((e) => LichThi.fromJson(e))
          .toList(),
      dsLichHoanThi: json['ds_lich_hoan_thi'] ?? [],
      titleLichHoanThi: json['title_lich_hoan_thi'] ?? '',
      thongBaoNoHocPhi: json['thong_bao_no_hoc_phi'] ?? '',
      isShowInSvDuThi: json['is_show_in_sv_du_thi'],
    );
  }

  Map<String, dynamic> toJson() => {
        'total_items': totalItems,
        'total_pages': totalPages,
        'is_DHMO': isDhmo,
        'ds_lich_thi': dsLichThi.map((e) => e.toJson()).toList(),
        'ds_lich_hoan_thi': dsLichHoanThi,
        'title_lich_hoan_thi': titleLichHoanThi,
        'thong_bao_no_hoc_phi': thongBaoNoHocPhi,
        'is_show_in_sv_du_thi': isShowInSvDuThi,
      };
}