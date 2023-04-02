import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/Arguments/ScreenArguments.dart';
import 'package:project/routes.dart';

class OtherPage extends StatefulWidget {
  final String teacherName;
  final String teacherPassword;

  const OtherPage({Key? key, required this.teacherName, required this.teacherPassword}) : super(key: key);
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState(teacherName: teacherName,teacherPassword: teacherPassword);
}

class _MyStatefulWidgetState extends State {
  final String teacherName;
  final String teacherPassword;

  _MyStatefulWidgetState({required this.teacherName, required this.teacherPassword});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Attendance ")),
      body: const Center(
        child: Text('Show and see attendance'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Attendance managment system'),
            ),
            ListTile(
              title: const Text('Take Atendance'),
              onTap: () {
                Navigator.of(context).pushNamed(RouteGenerator.takeAttendance,arguments:new ScreenArguments(classId: 0, className: "", name: this.teacherName, password: this.teacherPassword));
              },
            ),
            ListTile(
              title: const Text('Show classes'),
              onTap: () {
                Navigator.of(context).pushNamed(RouteGenerator.showClasses,arguments: new ScreenArguments(classId: 0, className: "", name: this.teacherName, password: this.teacherPassword));
              },
            ),
           
            ListTile(
              title: const Text('Your settings'),
              onTap: () {
                Navigator.of(context).pushNamed(RouteGenerator.showUserSettings,arguments: ScreenArguments(classId: 0, className: "", name: this.teacherName, password: this.teacherPassword));
              },
            ),
          ],
        ),
      ),
    );
  }
}
