import 'package:flutter/material.dart';
import 'package:aqedu/features/home/screens/student_home_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:aqedu/config/env.dart';
class Avatar extends StatefulWidget {
  const Avatar({super.key});

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsetsGeometry.all(0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white38, width: 2),
        ),
        child: GestureDetector(
          onTap: () {
            print('Click avt');
          },
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: Image.asset(
                avt,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                alignment: Alignment(0, 0),
              ),
            ),
          ),
        )
    );
  }
}
