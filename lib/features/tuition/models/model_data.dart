import './model_item.dart';
class Data {
  final int totalItems;
  final int totalPages;
  final bool isTinhTong;
  final bool isShowHocBong;
  final bool isTgDongHocPhi;
  final bool isHvsg;
  final bool isShowDonGia;
  final List<HocPhiHocKy> dsHocPhiHocKy;
  final List<dynamic> dsHocBongMg;

  final bool isDongHpTheoEdubill;
  final String urlEdubillGateway;
  final String messsageErrorEdubill;
  final String urlCallApi;
  final String noiDungGiaHan;
  final String ngayGiaHan;

  Data({
    required this.totalItems,
    required this.totalPages,
    required this.isTinhTong,
    required this.isShowHocBong,
    required this.isTgDongHocPhi,
    required this.isHvsg,
    required this.isShowDonGia,
    required this.dsHocPhiHocKy,
    required this.dsHocBongMg,
    required this.isDongHpTheoEdubill,
    required this.urlEdubillGateway,
    required this.messsageErrorEdubill,
    required this.urlCallApi,
    required this.noiDungGiaHan,
    required this.ngayGiaHan,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      totalItems: json['total_items'],
      totalPages: json['total_pages'],
      isTinhTong: json['is_tinh_tong'],
      isShowHocBong: json['is_show_hoc_bong'],
      isTgDongHocPhi: json['is_tg_dong_hoc_phi'],
      isHvsg: json['is_hvsg'],
      isShowDonGia: json['is_show_don_gia'],
      dsHocPhiHocKy: (json['ds_hoc_phi_hoc_ky'] as List)
          .map((e) => HocPhiHocKy.fromJson(e))
          .toList(),
      dsHocBongMg: json['ds_hoc_bong_mg'] ?? [],
      isDongHpTheoEdubill: json['is_dong_hp_theo_edubill'],
      urlEdubillGateway: json['url_edubill_gateway'] ?? '',
      messsageErrorEdubill: json['messsage_error_edubill'] ?? '',
      urlCallApi: json['url_call_api'] ?? '',
      noiDungGiaHan: json['noi_dung_gia_han'] ?? '',
      ngayGiaHan: json['ngay_gia_han'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'total_items': totalItems,
        'total_pages': totalPages,
        'is_tinh_tong': isTinhTong,
        'is_show_hoc_bong': isShowHocBong,
        'is_tg_dong_hoc_phi': isTgDongHocPhi,
        'is_hvsg': isHvsg,
        'is_show_don_gia': isShowDonGia,
        'ds_hoc_phi_hoc_ky':
            dsHocPhiHocKy.map((e) => e.toJson()).toList(),
        'ds_hoc_bong_mg': dsHocBongMg,
        'is_dong_hp_theo_edubill': isDongHpTheoEdubill,
        'url_edubill_gateway': urlEdubillGateway,
        'messsage_error_edubill': messsageErrorEdubill,
        'url_call_api': urlCallApi,
        'noi_dung_gia_han': noiDungGiaHan,
        'ngay_gia_han': ngayGiaHan,
      };
}