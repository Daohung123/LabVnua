import 'package:aqedu/core/constants/env.dart';
import 'package:aqedu/core/constants/UI/sizes/size_function.dart';
import 'package:aqedu/core/widgets/Button/btn_Icon.dart';
import 'package:aqedu/core/widgets/Text/text_common.dart';
import 'package:aqedu/features/infor/screens/view_inforStudent.dart';
import 'package:aqedu/features/tuition/screens/view_tuition.dart';
import 'package:flutter/material.dart';

class StudyTool extends StatefulWidget {
  const StudyTool({super.key});

  @override
  State<StudyTool> createState() => _StudyToolState();
}

class _StudyToolState extends State<StudyTool> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width_screen_percent(context, 85),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(circle),
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextCommon(txt: "Tiện ích học tập"),
            SizedBox(height: 10),
            Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 15,
                    children: [
                      ButtonImage(
                        text: "TKB ngày",
                        onPressed: () {
                          print("TKB ngày");
                        },
                        imagePath: "assets/calendar.png",
                        size: 40,
                      ),
                      ButtonImage(
                        text: "Lịch thi",
                        onPressed: () {
                          print("Lịch thi");
                        },
                        imagePath: "assets/schedule.png",
                        size: 40,
                      ),
                      ButtonImage(
                        text: "ĐKMH",
                        onPressed: () {
                          print("ĐKMH");
                        },
                        imagePath: "assets/text-books.png",
                        size: 40,
                      ),
                      ButtonImage(
                        text: "Hồ sơ",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InforStudentView(),
                            ),
                          );
                        },
                        imagePath: "assets/profile.png",
                        size: 40,
                      ),
                      ButtonImage(
                        text: "Điểm thi",
                        onPressed: () {
                          print("Điểm thi");
                        },
                        imagePath: "assets/score.png",
                        size: 40,
                      ),
                      ButtonImage(
                        text: "Học phí",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TuitionView(hocPhiResponse: null),
                            ),
                          );
                        },
                        imagePath: "assets/score.png",
                        size: 40,
                      ),
                      ButtonImage(
                        text: "Thêm",
                        onPressed: () {
                          print("Thêm");
                        },
                        imagePath: "assets/plus.png",
                        size: 40,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
