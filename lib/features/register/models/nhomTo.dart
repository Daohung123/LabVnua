class NhomToModel {
  final String? idToHoc;
  final String? idMon;
  final String? maMon;

  final String? tenMon;
  final String? tenMonEg;

  final double? soTcSo;
  final int? slCp;
  final int? slCl;

  final String? tkb;
  final bool? enable;
  final bool? isDk;

  final List<String>? dsLop;
  final List<String>? dsKhoa;

  NhomToModel({
    this.idToHoc,
    this.idMon,
    this.maMon,
    this.tenMon,
    this.tenMonEg,
    this.soTcSo,
    this.slCp,
    this.slCl,
    this.tkb,
    this.enable,
    this.isDk,
    this.dsLop,
    this.dsKhoa,
  });

  factory NhomToModel.fromJson(Map<String, dynamic> json) {
    return NhomToModel(
      idToHoc: json['id_to_hoc'],
      idMon: json['id_mon'],
      maMon: json['ma_mon'],
      tenMon: json['ten_mon'],
      tenMonEg: json['ten_mon_eg'],
      soTcSo: (json['so_tc_so'] as num?)?.toDouble(),
      slCp: json['sl_cp'],
      slCl: json['sl_cl'],
      tkb: json['tkb'],
      enable: json['enable'],
      isDk: json['is_dk'],
      dsLop: (json['ds_lop'] as List?)?.map((e) => e.toString()).toList(),
      dsKhoa: (json['ds_khoa'] as List?)?.map((e) => e.toString()).toList(),
    );
  }
}