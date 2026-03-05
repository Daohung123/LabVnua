import 'package:aqedu/env.dart';
import 'package:flutter/material.dart';
import 'package:aqedu/helper/helper_widgets/Button/btn_Common.dart';

class DetailSubjectSchedure extends StatefulWidget {
  final String nameSubject;
  final String room;
  final String teacherName;

  const DetailSubjectSchedure({
    super.key,
    required this.nameSubject,
    required this.teacherName,
    required this.room,
  });

  @override
  State<DetailSubjectSchedure> createState() => _DetailSubjectSchedureState();
}

class _DetailSubjectSchedureState extends State<DetailSubjectSchedure> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.nameSubject,
          style: TextStyle(
            color: Colors.black,
            fontSize: font_time_schedure + 1,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Phòng: ' + widget.room,
          style: TextStyle(
            color: Color(0xff777689),
            fontSize: font_time_schedure,
          ),
        ),
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: font_time_schedure),
            children: [
              TextSpan(
                text: 'Giảng viên: ',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: widget.teacherName,
                style: TextStyle(color: Color(0xff8cc34b)),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 115,
          height: 23.5,
        child: btnCommon(text: "Xem chi tiết >>>", width_text: 9, onPressed: () {print("Xem chi tiet");}, colors_background: Colors.indigo, colors_text: Colors.white),
        ),
      ],
    );
  }
}
