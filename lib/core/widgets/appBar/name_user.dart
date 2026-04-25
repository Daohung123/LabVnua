import 'package:flutter/material.dart';
import 'package:aqedu/core/constants/env.dart';
class NameUser extends StatefulWidget {
  const NameUser({super.key});

  @override
  State<NameUser> createState() => _NameUserState();
}

class _NameUserState extends State<NameUser> {


  @override
  Widget build(BuildContext context) {
    return Text("Hi, $Lastname $MiddleName $FirstName 👋",style: TextStyle(color: Colors.white));

  }
}
