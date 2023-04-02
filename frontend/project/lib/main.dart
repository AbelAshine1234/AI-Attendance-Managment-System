import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/attendance/bloc/attendance_bloc.dart';
import 'package:project/attendance/repository/attendance_api_client.dart';
import 'package:project/attendance/repository/attendance_repository.dart';
import 'package:project/class/bloc/ClassBloc.dart';
import 'package:project/class/repositories/class_api_client.dart';
import 'package:project/class/repositories/class_repositories.dart';
import 'package:project/routes.dart';
import 'package:project/students/bloc/StudentBloc.dart';
import 'package:project/students/repostiories/student_api_client.dart';
import 'package:project/students/repostiories/student_repositery.dart';
import 'package:project/teacher/bloc/TeacherBloc.dart';
import 'package:project/teacher/repositories/repository.dart';

import 'teacher/repositories/teacher_api_client.dart';
import 'package:http/http.dart' as http;

void main(List<String> args) {
  final AttendanceRepository attendanceRepository = new AttendanceRepository(
      attendanceApiClient: new AttendanceApiClient(httpClient: http.Client()));
  final ClassRepostiry classRepostiry = new ClassRepostiry(
      classApiClient: new ClassApiClient(httpClient: http.Client()));
  final TeacherRepository teacherRepository = new TeacherRepository(
      teacherApiClient: new TeacherApiClient(httpClient: http.Client()));
  final StudentRepository studentRepository = new StudentRepository(
      studentApiClient: new StudentApiClient(httpClient: http.Client()));
  runApp(App(
      teacherRepository: teacherRepository,
      classRepostiry: classRepostiry,
      studentRepository: studentRepository,
      attendanceRepository: attendanceRepository));
}

class App extends StatelessWidget {
  final TeacherRepository teacherRepository;
  final ClassRepostiry classRepostiry;
  final StudentRepository studentRepository;
  final AttendanceRepository attendanceRepository;
  const App(
      {required this.teacherRepository,
      required this.classRepostiry,
      required this.attendanceRepository,
      required this.studentRepository});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (context) =>
                      TeacherBloc(teacherRepository: this.teacherRepository)),
              BlocProvider(
                  create: (context) =>
                      ClassBloc(classRepostiry: classRepostiry)),
              BlocProvider(
                  create: (context) =>
                      StudentBloc(studentRepository: studentRepository)),
              BlocProvider(
                  create: (context) => AttendanceBloc(
                      attendanceRepository: attendanceRepository))
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: RouteGenerator.loginPage,
              onGenerateRoute: RouteGenerator.routegenerator,
            )),
      ),
    );
  }
}
