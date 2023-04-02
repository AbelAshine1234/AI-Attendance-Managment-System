import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/Arguments/AttendanceArgument.dart';
import 'package:project/Arguments/ScreenArguments.dart';
import 'package:project/attendance/bloc/attendance_bloc.dart';
import 'package:project/attendance/bloc/attendance_event.dart';
import 'package:project/class/bloc/ClassBloc.dart';
import 'package:project/class/bloc/ClassEvent.dart';
import 'package:project/class/bloc/ClassState.dart';
import 'package:project/routes.dart';

class TakeAttendance extends StatefulWidget {
  final String className;
  final int classId;
  final String teacherName;
  final String teacherPassword;

  const TakeAttendance(
      {Key? key,
      required this.className,
      required this.classId,
      required this.teacherName,
      required this.teacherPassword})
      : super(key: key);

  @override
  _TakeAttendanceState createState() => _TakeAttendanceState(
      className: className,
      classId: classId,
      teacherName: teacherName,
      teacherPassword: teacherPassword);
}

class _TakeAttendanceState extends State {
  final String className;
  final int classId;
  final String teacherName;
  final String teacherPassword;

  _TakeAttendanceState(
      {required this.className,
      required this.classId,
      required this.teacherName,
      required this.teacherPassword});
  Widget build(BuildContext buildContext) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Take Attendance"),
          leading: IconButton(
            padding: EdgeInsets.only(top: 5),
            alignment: Alignment.topLeft,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: BlocBuilder<ClassBloc, ClassState>(builder: (context, state) {
          if (state is ClassEmpty) {
            BlocProvider.of<ClassBloc>(context).add(FetchAllClasses(
                teacherName: teacherName, teacherPassword: teacherPassword));
            return Center(child: CircularProgressIndicator());
          }
          if (state is OneClassLoaded) {
            BlocProvider.of<ClassBloc>(context).add(FetchAllClasses(
                teacherName: teacherName, teacherPassword: teacherPassword));
            return Center(child: CircularProgressIndicator());
          }
          if (state is ClassError) {
            return Center(
              child: Text("Error finding class"),
            );
          }
          if (state is AllClassesLoaded) {
            final allclassNames = state.classNames.toList();
            if (state.classNames.length > 0) {
              return Scaffold(
                body: ListView.builder(
                    itemCount: allclassNames.length,
                    itemBuilder: (c, index) {
                      return ListTile(
                          title: Text(allclassNames.elementAt(index).name),
                          onTap: () {
                            Navigator.of(buildContext).popAndPushNamed(RouteGenerator.takeAttendanceFrom,arguments: AttendanceArgument(classId: state.classNames.elementAt(index).classNameId));
                          });
                    }),
              );
            }
          }
          return Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }
}
