import 'package:aqedu/features/tuition/models/model_data.dart';

class HocPhiResponse {
  final Data data;
  final bool result;
  final int code;

  HocPhiResponse({
    required this.data,
    required this.result,
    required this.code,
  });

  factory HocPhiResponse.fromJson(Map<String, dynamic> json) {
    return HocPhiResponse(
      data: Data.fromJson(json['data']),
      result: json['result'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data.toJson(),
        'result': result,
        'code': code,
      };
}