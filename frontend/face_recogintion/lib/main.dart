import 'package:face_recogintion/presentation/Login.dart';
import 'package:face_recogintion/repositories/teacher_api_client.dart';
import 'package:face_recogintion/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/TeacherBloc.dart';
import 'repositories/teacher_repository.dart';
import 'package:http/http.dart' as http;

void main(List<String> args) {
  final TeacherRepository teacherRepository = new TeacherRepository(
      teacherApiClient: new TeacherApiClient(httpClient: http.Client()));
  runApp(App(
    teacherRepository: teacherRepository,
  ));
}

class App extends StatelessWidget {
  final TeacherRepository teacherRepository;
  const App({required this.teacherRepository});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  TeacherBloc(teacherRepository: this.teacherRepository)),
        ],
        child: MaterialApp(
          initialRoute: RouteGenerator.homePage,
          onGenerateRoute: RouteGenerator.generateRoute,
        ));
  }
}
