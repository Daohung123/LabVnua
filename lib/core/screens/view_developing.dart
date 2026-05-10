import 'package:flutter/material.dart';

class Developing extends StatefulWidget {
  const Developing({super.key});

  @override
  State<Developing> createState() => _DevelopingState();
}

class _DevelopingState extends State<Developing> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Dev đang phát triển chức năng này, mong bạn thông cảm!"),
    );
  }
}
