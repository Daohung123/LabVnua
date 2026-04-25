import 'package:aqedu/core/constants/UI/styles/colors.dart';
import 'package:aqedu/core/widgets/appBar/avt.dart';
import 'package:aqedu/core/widgets/appBar/name_user.dart';
import 'package:aqedu/core/widgets/appBar/notification.dart';
import 'package:aqedu/core/widgets/appBar/scan.dart';
import 'package:aqedu/core/widgets/appBar/time_fomat.dart';
import 'package:flutter/material.dart';
import 'package:aqedu/features/schedure/screens/components/schedure.dart';
import 'package:aqedu/core/widgets/study_tool/study_tool.dart';
class HomeStudent extends StatefulWidget {
  const HomeStudent({super.key});

  @override
  State<HomeStudent> createState() => _HomeStudentState();
}

class _HomeStudentState extends State<HomeStudent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff104492),
        toolbarHeight: 95,
        leadingWidth: 210,
        leading: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Avatar(),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      NameUser(),
                      Text(
                        "Welcome back!",
                        style: TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const TimeFormat(
                leading: Icon(Icons.access_time, size: 18),
                backgroundColor: Colors.white,
                textStyle: TextStyle(fontSize: 10, color: Colors.black),
              ),
            ],
          ),
        ),
        title: Align(
          alignment: Alignment.topRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [Noti(), Scan()],
              ),
              SizedBox(height: 2.5),
            ],
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: bg_color,
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: const [
                  Schedure(),
                  SizedBox(height: 10),
                  StudyTool(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}