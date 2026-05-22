class SemesterTimetableResponse {
  final SemesterTimetableData? data;

  SemesterTimetableResponse({this.data});

  factory SemesterTimetableResponse.fromJson(Map<String, dynamic> json) {
    return SemesterTimetableResponse(
      data: json['data'] != null
          ? SemesterTimetableData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data?.toJson()};
  }
}

class SemesterTimetableData {
  final int? totalItems;
  final List<SemesterTimetableItem>? dsNhomTo;

  SemesterTimetableData({this.totalItems, this.dsNhomTo});

  factory SemesterTimetableData.fromJson(Map<String, dynamic> json) {
    return SemesterTimetableData(
      totalItems: json['total_items'],
      dsNhomTo: (json['ds_nhom_to'] as List<dynamic>?)
          ?.map((e) => SemesterTimetableItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_items': totalItems,
      'ds_nhom_to': dsNhomTo?.map((e) => e.toJson()).toList(),
    };
  }
}

class SemesterTimetableItem {
  final int? id;
  final String? idToHoc;
  final String? maMon;
  final String? tenMon;
  final String? nhomTo;
  final int? thu;
  final int? tietBatDau;
  final int? soTiet;
  final String? tuGio;
  final String? denGio;
  final String? phong;
  final String? lop;
  final String? gv;
  final String? tooltip;

  SemesterTimetableItem({
    this.id,
    this.idToHoc,
    this.maMon,
    this.tenMon,
    this.nhomTo,
    this.thu,
    this.tietBatDau,
    this.soTiet,
    this.tuGio,
    this.denGio,
    this.phong,
    this.lop,
    this.gv,
    this.tooltip,
  });

  factory SemesterTimetableItem.fromJson(Map<String, dynamic> json) {
    return SemesterTimetableItem(
      id: json['id'],
      idToHoc: json['id_to_hoc'],
      maMon: json['ma_mon'],
      tenMon: json['ten_mon'],
      nhomTo: json['nhom_to'],
      thu: json['thu'],
      tietBatDau: json['tbd'],
      soTiet: json['so_tiet'],
      tuGio: json['tu_gio'],
      denGio: json['den_gio'],
      phong: json['phong'],
      lop: json['lop'],
      gv: json['gv'],
      tooltip: json['tooltip'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_to_hoc': idToHoc,
      'ma_mon': maMon,
      'ten_mon': tenMon,
      'nhom_to': nhomTo,
      'thu': thu,
      'tbd': tietBatDau,
      'so_tiet': soTiet,
      'tu_gio': tuGio,
      'den_gio': denGio,
      'phong': phong,
      'lop': lop,
      'gv': gv,
      'tooltip': tooltip,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_to_hoc': idToHoc,
      'ma_mon': maMon,
      'ten_mon': tenMon,
      'nhom_to': nhomTo,
      'thu': thu,
      'tbd': tietBatDau,
      'so_tiet': soTiet,
      'tu_gio': tuGio,
      'den_gio': denGio,
      'phong': phong,
      'lop': lop,
      'gv': gv,
      'tooltip': tooltip,
    };
  }

  factory SemesterTimetableItem.fromMap(Map<String, dynamic> map) {
    return SemesterTimetableItem(
      id: map['id'],
      idToHoc: map['id_to_hoc'],
      maMon: map['ma_mon'],
      tenMon: map['ten_mon'],
      nhomTo: map['nhom_to'],
      thu: map['thu'],
      tietBatDau: map['tbd'],
      soTiet: map['so_tiet'],
      tuGio: map['tu_gio'],
      denGio: map['den_gio'],
      phong: map['phong'],
      lop: map['lop'],
      gv: map['gv'],
      tooltip: map['tooltip'],
    );
  }
}
