class KhoaModel {
  final String? ma;
  final String? ten;

  KhoaModel({this.ma, this.ten});

  factory KhoaModel.fromJson(Map<String, dynamic> json) {
    return KhoaModel(
      ma: json['ma'],
      ten: json['ten'],
    );
  }
}