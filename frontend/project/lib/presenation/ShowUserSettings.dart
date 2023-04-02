import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/routes.dart';
import 'package:project/teacher/bloc/TeacherBloc.dart';
import 'package:project/teacher/bloc/TeacherEvent.dart';
import 'package:project/teacher/models/Teachers.dart';

class ShowUserSettings extends StatefulWidget {
  final String teacherName;
  final String teacherPassword;

  const ShowUserSettings(
      {Key? key, required this.teacherName, required this.teacherPassword})
      : super(key: key);
  @override
  _ShowUserSettingsState createState() => _ShowUserSettingsState(
      teacherName: teacherName, teacherPassword: teacherPassword);
}

class _ShowUserSettingsState extends State {
  final String teacherName;
  final String teacherPassword;
  final namecontroller = TextEditingController();
  final _key = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _ShowUserSettingsState(
      {required this.teacherName, required this.teacherPassword});
  String? _validateName(String? value) {
    if (value!.isEmpty) {
      return "Name can not be empty";
    } else {
      return null;
    }
  }

  Widget _Name() {
    return TextFormField(
      controller: namecontroller,
      decoration: const InputDecoration(
          icon: Icon(Icons.verified_user), hintText: "Your Name"),
      validator: _validateName,
    );
  }

  @override
  Widget build(BuildContext buildContext) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("User settings"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(buildContext).pop();
            },
          ),
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 45),
            child: ElevatedButton(
                onPressed: () => {
                      BlocProvider.of<TeacherBloc>(buildContext).close(),
                      Navigator.of(context)
                          .popAndPushNamed(RouteGenerator.loginPage)
                    },
                child: Text(
                  "Log Out",
                  style: TextStyle(fontSize: 16),
                )),
          ),
          Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _Name(),
                Padding(
                  padding: const EdgeInsets.all(23.0),
                  child: ElevatedButton(
                      onPressed: () => {
                            if (_key.currentState!.validate())
                              {
                                BlocProvider.of<TeacherBloc>(context).add(
                                    TeacherUpdate(
                                        oldName: this.teacherName,
                                        newName: this.namecontroller.text,
                                        password: this.teacherPassword)),
                                BlocProvider.of<TeacherBloc>(context).close(),
                                Navigator.of(buildContext)
                                    .popAndPushNamed(RouteGenerator.loginPage)
                              }
                            else
                              {}
                          },
                      child: Text("Update Name")),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
