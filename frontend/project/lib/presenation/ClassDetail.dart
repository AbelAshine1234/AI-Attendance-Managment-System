
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/Arguments/ScreenArguments.dart';
import 'package:project/Arguments/StudentArgument.dart';
import 'package:project/class/bloc/ClassBloc.dart';
import 'package:project/class/bloc/ClassEvent.dart';
import 'package:project/class/bloc/ClassState.dart';
import 'package:project/routes.dart';
import 'package:project/students/bloc/StudentBloc.dart';
import 'package:project/students/bloc/StudentEvent.dart';
import 'package:project/students/models/student_models.dart';
import 'package:project/teacher/models/Teachers.dart';

class ClassDetail extends StatefulWidget {
  final String className;
  final int classId;
  final String teacherName;
  final String teacherPassword;

  const ClassDetail(
      {Key? key,
      required this.className,
      required this.teacherName,
      required this.classId,
      required this.teacherPassword})
      : super(key: key);
  @override
  _ClassDetailState createState() => _ClassDetailState(
      className: className,
      classId: classId,
      teacherName: teacherName,
      teacherPassword: teacherPassword);
}

class _ClassDetailState extends State {
  final String className;
  final int classId;
  final String teacherName;
  final String teacherPassword;

  _ClassDetailState(
      {required this.className,
      required this.classId,
      required this.teacherName,
      required this.teacherPassword});
  @override
  Widget build(BuildContext buildCcontext) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
          body: BlocBuilder<ClassBloc, ClassState>(builder: (context, state) {
        if (state is AllClassesLoaded) {
          BlocProvider.of<ClassBloc>(context)
              .add(FetchClassDetail(this.classId));
          return Container(child: Text("$classId"));
        }
        if (state is ClassError) {
          return Center(
            child: Text("class error"),
          );
        }
        if (state is ClassEmpty) {
          return Center(
            child: Text("There is no class selected"),
          );
        }
        if (state is OneClassLoaded) {
          print(state.className.studentsId.runtimeType);
          final all_students = state.className.studentsId;
          final all_students_json =
              all_students.map((e) => Student.fromJson(e)).toList();
          for (var i = 0; i < all_students_json.length; i++) {
            print(all_students_json.elementAt(i).studentName);
          }

          return Scaffold(
            appBar: AppBar(
              title: Text("${state.className.name}"),
              leading: IconButton(
                padding: EdgeInsets.only(top: 5),
                alignment: Alignment.topLeft,
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(buildCcontext).pop();
                },
              ),
            ),
            body: ListView.builder(
                itemCount: all_students.length,
                itemBuilder: (ct, index) {
                  return ListTile(
                    title: Text(all_students_json[index].studentName),
                    trailing: IconButton(
                        onPressed: () => {
                              Navigator.of(buildCcontext).popAndPushNamed(
                                  RouteGenerator.showStudentDetail,
                                  arguments: new StudentArguments(
                                      id: all_students_json[index].studentId,
                                      studentName:
                                          all_students_json[index].studentName,
                                      imagePath:
                                          all_students_json[index].imagePath))
                            },
                        icon: Icon(Icons.edit)),
                  );
                }),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => {
                BlocProvider.of<StudentBloc>(context).add(GetAllStudents()),
                Navigator.of(buildCcontext).popAndPushNamed(
                    RouteGenerator.showAllStudents,
                    arguments: ScreenArguments(
                        classId: classId,
                        className: className,
                        name: this.teacherName,
                        password: this.teacherPassword))
              },
              label: Text("Add Student"),
              icon: Icon(
                Icons.add,
              ),
            ),
          );
        }
        return CircularProgressIndicator();
      })),
    );
  }
}
