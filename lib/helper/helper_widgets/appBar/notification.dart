import 'package:flutter/material.dart';
class Noti extends StatefulWidget {
  const Noti({super.key});

  @override
  State<Noti> createState() => _NotiState();
}

class _NotiState extends State<Noti> {
  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: () {
      print("Notification");
    }, icon: Icon(Icons.notifications_active_outlined), iconSize: 30, color: Colors.white,);
  }
}
