import "package:aqedu/features/infor_student/ctrls/ctrls_inforStudent.dart";
import "package:flutter/material.dart";

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CtrlsInforstudent.getInforStudent();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}