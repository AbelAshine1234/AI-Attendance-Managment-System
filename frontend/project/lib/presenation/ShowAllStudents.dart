import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/Arguments/ScreenArguments.dart';
import 'package:project/class/bloc/ClassBloc.dart';
import 'package:project/class/bloc/ClassEvent.dart';
import 'package:project/routes.dart';
import 'package:project/students/bloc/StudentBloc.dart';
import 'package:project/students/bloc/StudentState.dart';

class ShowAllStudents extends StatefulWidget {
  final String className;
  final int classId;
  final String teacherName;
  final String teacherPassword;

  const ShowAllStudents(
      {Key? key,
      required this.className,
      required this.classId,
      required this.teacherName,
      required this.teacherPassword})
      : super(key: key);
  @override
  _ShowAllStudentState createState() => _ShowAllStudentState(
      className: className,
      classId: classId,
      teacherName: teacherName,
      teacherPassword: teacherPassword);
}

class _ShowAllStudentState extends State {
  final String className;
  final int classId;
  final String teacherName;
  final String teacherPassword;

  _ShowAllStudentState(
      {required this.className,
      required this.classId,
      required this.teacherName,
      required this.teacherPassword});
  @override
  Widget build(BuildContext bcontext) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("All Students"),
          leading: IconButton(
              onPressed: () => Navigator.of(context).popAndPushNamed(
                  RouteGenerator.classDetail,
                  arguments: ScreenArguments(
                      classId: classId,
                      className: className,
                      name: this.teacherName,
                      password: this.teacherPassword)),
              icon: Icon(Icons.arrow_back)),
        ),
        body: Container(
          child: BlocBuilder<StudentBloc, StudentState>(
            builder: (con, st) {
              if (st is StudentEmpty) {
                return Center(
                  child: Text("There are no students"),
                );
              }
              if (st is AllStudentLoaded) {
                return ListView.builder(
                    itemCount: st.students.length,
                    itemBuilder: (c, index) {
                      return ListTile(
                        leading: Text(st.students.elementAt(index).imagePath),
                        title: Text(st.students.elementAt(index).studentName),
                        onTap: () => {
                          BlocProvider.of<ClassBloc>(context).add(
                              AddStudentToClass(
                                  classId: classId,
                                  studentId:
                                      st.students.elementAt(index).studentId)),
                          Navigator.of(bcontext).popAndPushNamed(
                              RouteGenerator.classDetail,
                              arguments: ScreenArguments(
                                  classId: classId,
                                  className: className,
                                  name: this.className,
                                  password: this.teacherPassword))
                        },
                      );
                    });
              }
              if (st is Error) {
                return Center(
                  child: Text("could not load students"),
                );
              }
              print(st);
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
