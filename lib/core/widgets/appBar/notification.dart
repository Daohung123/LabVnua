import 'package:aqedu/features/notification/screens/view_noti_student.dart';
import 'package:flutter/material.dart';

class Noti extends StatefulWidget {
  const Noti({super.key});

  @override
  State<Noti> createState() => _NotiState();
}

class _NotiState extends State<Noti> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationView()),
        );
      },
      icon: Icon(Icons.notifications_active_outlined),
      iconSize: 30,
      color: Colors.white,
    );
  }
}
