import 'package:aqedu/features/register/models/khoa.dart';
import 'package:aqedu/features/register/models/lop.dart';
import 'package:aqedu/features/register/models/monHoc.dart';
import 'package:aqedu/features/register/models/nhomTo.dart';

class DataModel {
  final int? totalItems;
  final int? totalPages;
  final String? dienGiaiEnableChung;
  final String? hocKyDangKy;

  final List<KhoaModel>? dsKhoa;
  final List<LopModel>? dsLop;
  final List<MonHocModel>? dsMonHoc;
  final List<NhomToModel>? dsNhomTo;

  DataModel({
    this.totalItems,
    this.totalPages,
    this.dienGiaiEnableChung,
    this.hocKyDangKy,
    this.dsKhoa,
    this.dsLop,
    this.dsMonHoc,
    this.dsNhomTo,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      totalItems: json['total_items'],
      totalPages: json['total_pages'],
      dienGiaiEnableChung: json['dien_giai_enable_chung'],
      hocKyDangKy: json['hoc_ky_dang_ky'],

      dsKhoa: (json['ds_khoa'] as List?)
          ?.map((e) => KhoaModel.fromJson(e))
          .toList(),

      dsLop: (json['ds_lop'] as List?)
          ?.map((e) => LopModel.fromJson(e))
          .toList(),

      dsMonHoc: (json['ds_mon_hoc'] as List?)
          ?.map((e) => MonHocModel.fromJson(e))
          .toList(),

      dsNhomTo: (json['ds_nhom_to'] as List?)
          ?.map((e) => NhomToModel.fromJson(e))
          .toList(),
    );
  }
}
