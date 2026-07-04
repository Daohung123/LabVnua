import 'package:aqedu/features/register/models/data_model.dart';

class DangKyMonHocModel {
  final int? loaiHienThiTuan;
  final bool? isMergeToHoc;
  final bool? isBbChonNhomTo;
  final DataModel? data;

  DangKyMonHocModel({
    this.loaiHienThiTuan,
    this.isMergeToHoc,
    this.isBbChonNhomTo,
    this.data,
  });

  factory DangKyMonHocModel.fromJson(Map<String, dynamic> json) {
    return DangKyMonHocModel(
      loaiHienThiTuan: json['loai_hien_thi_tuan'],
      isMergeToHoc: json['is_merge_to_hoc'],
      isBbChonNhomTo: json['is_bb_chon_nhomto'],
      data: json['data'] != null ? DataModel.fromJson(json['data']) : null,
    );
  }
}
