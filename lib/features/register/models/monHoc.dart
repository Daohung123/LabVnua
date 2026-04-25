class MonHocModel {
  final String? ma;
  final String? ten;
  final String? tenEg;

  MonHocModel({this.ma, this.ten, this.tenEg});

  factory MonHocModel.fromJson(Map<String, dynamic> json) {
    return MonHocModel(
      ma: json['ma'],
      ten: json['ten'],
      tenEg: json['ten_eg'],
    );
  }
}