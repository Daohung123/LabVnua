import 'package:aqedu/features/exam_schedule/models/model_data.dart';

class LichThiResponse {
  final LichThiData data;

  LichThiResponse({required this.data});

  factory LichThiResponse.fromJson(Map<String, dynamic> json) {
    return LichThiResponse(
      data: LichThiData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data.toJson(),
      };
}