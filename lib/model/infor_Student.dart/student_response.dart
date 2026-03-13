import'./student_data.dart';
class StudentResponse {
  final StudentData data;
  final bool result;
  final int code;

  StudentResponse({
    required this.data,
    required this.result,
    required this.code,
  });

  factory StudentResponse.fromJson(Map<String, dynamic> json) {
    return StudentResponse(
      data: StudentData.fromJson(json['data']),
      result: json['result'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "data": data.toJson(),
      "result": result,
      "code": code,
    };
  }
}