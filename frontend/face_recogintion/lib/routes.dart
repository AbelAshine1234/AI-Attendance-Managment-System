import 'dart:js';

import 'package:face_recogintion/presentation/Login.dart';
import 'package:face_recogintion/presentation/ShowTeacher.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static const String homePage = "/";
  static const String showPage = "/showPage";
  RouteGenerator._();
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name){
      case homePage:
          return MaterialPageRoute(builder: (context)=>LoginForm());
      case showPage:
          return MaterialPageRoute(builder: (context)=>HomePage());
      default:
          throw FormatException("ROute could not be found");
    }
    
  }
}
