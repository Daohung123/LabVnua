class LopModel {
  final String? ma;
  final String? ten;

  LopModel({this.ma, this.ten});

  factory LopModel.fromJson(Map<String, dynamic> json) {
    return LopModel(
      ma: json['ma'],
      ten: json['ten'],
    );
  }
}