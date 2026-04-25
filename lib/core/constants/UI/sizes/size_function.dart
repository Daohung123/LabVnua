//Size Screen with percent
import 'package:flutter/material.dart';

double width_screen_percent(BuildContext context,double percentScreen){
  double widthscreen = MediaQuery.of(context).size.width * percentScreen;
  return widthscreen;
}

double height_screen_percent(BuildContext context,double percentScreen){
  double heightscreen = MediaQuery.of(context).size.height * percentScreen;
  return heightscreen;
}
