import 'package:flutter/material.dart';
import 'package:aqedu/config/env.dart';
class ContainerMod1 extends StatefulWidget {
  final double my_width;
  final double my_heigth;
  final Widget my_child;
  const ContainerMod1({super.key,required this.my_child, required this.my_width, required this.my_heigth});
  @override
  State<ContainerMod1> createState() => _ContainerMod1State();
}

class _ContainerMod1State extends State<ContainerMod1> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        //background
        Container(
          width: widget.my_width,
          height: widget.my_heigth,
          decoration: BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.circular(circle),
          ),
        ),

        //card
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: widget.my_width,
            height: widget.my_heigth*0.95,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(circle),
            ),
            child: Center(
              child: widget.my_child,
            ),
          )
        ),
      ],
    );
  }
}
