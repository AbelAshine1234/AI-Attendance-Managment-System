import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/Arguments/ScreenArguments.dart';
import 'package:project/teacher/bloc/TeacherBloc.dart';
import 'package:project/teacher/bloc/TeacherEvent.dart';
import 'package:project/teacher/bloc/TeacherState.dart';
import 'package:project/teacher/models/Teachers.dart';

import '../../routes.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State {
  final namecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final _key = GlobalKey<FormState>();

  Widget _Name() {
    return TextFormField(
      controller: namecontroller,
      decoration: const InputDecoration(
          icon: Icon(Icons.verified_user), hintText: "User Name"),
      validator: _validateName,
    );
  }

  Widget _password() {
    return TextFormField(
      controller: passwordcontroller,
      decoration: const InputDecoration(
        icon: Icon(Icons.vpn_key),
        hintText: "Password",
      ),
      obscureText: true,
      validator: _validatePassword,
    );
  }

  String? _validateName(String? value) {
    if (value!.isEmpty) {
      return "Name can not be empty";
    } else {
      return null;
    }
  }

  String? _validatePassword(String? value) {
    if (value!.length < 8) {
      return "Password should be greater than 8";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherBloc, TeacherState>(
      builder: (context, state) {
        return MaterialApp(
          home: Scaffold(
            body:  SizedBox(
                child: Form(
                  child: Padding(
                    padding: const EdgeInsets.all(80.0),
                    child: Column(
                      mainAxisAlignment:MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _Name(),
                        _password(),
                        Padding(
                          padding: const EdgeInsets.only(top: 14, bottom: 12),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(234, 44)),
                            onPressed: () => {
                              if (_key.currentState!.validate())
                                {
                                  print("start"),
                                  if (state is TeacherEmpty)
                                    {
                                      print("create teacher"),
                                      BlocProvider.of<TeacherBloc>(context).add(
                                          CreateTeacher(new Teacher(
                                              name: namecontroller.text,
                                              password: passwordcontroller.text,
                                              id: 0))),
                              
                                    }
                                  else if (state is OneTeacherLoaded)
                                    {
                                      Navigator.of(context)
                                          .pushNamed(RouteGenerator.otherPage,arguments: new ScreenArguments(classId: 0, className: "", name: this.namecontroller.text, password: this.passwordcontroller.text)),
                                      new CircularProgressIndicator(),
                                      print("hello this is sycc")
                                    }
                                  else if (state is TeacherError)
                                    {print("error")}
                                }
                              else
                                {}
                            },
                            child: Text("signup"),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () => {Navigator.pop(context)},
                            child: Text("back"))
                      ],
                    ),
                  ),
                  key: _key,
                ),
              ),
            
          ),
        );
      },
    );
  }
}
