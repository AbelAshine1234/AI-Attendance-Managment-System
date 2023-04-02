import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/Arguments/ScreenArguments.dart';
import 'package:project/routes.dart';
import 'package:project/teacher/bloc/TeacherBloc.dart';
import 'package:project/teacher/bloc/TeacherEvent.dart';
import 'package:project/teacher/bloc/bloc.dart';
import 'package:project/teacher/models/Teachers.dart';

class LoginPage extends StatefulWidget {
  _LoginForm createState() => _LoginForm();
}

class _LoginForm extends State {
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

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherBloc, TeacherState>(
      builder: (context, state) {
        return MaterialApp(
          home: Scaffold(
            key: _scaffoldKey,
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width / 1.4,
              child: Padding(
                padding: const EdgeInsets.only(left:90),
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                                if (state is TeacherEmpty)
                                  {
                                    BlocProvider.of<TeacherBloc>(context).add(
                                        FetchATeacher(new Teacher(
                                            name: namecontroller.text,
                                            password: passwordcontroller.text,
                                            id: 0))),
                                  }
                                else if (state is OneTeacherLoaded)
                                  {
                                    Navigator.of(context).pushNamed(
                                      RouteGenerator.otherPage,
                                      arguments: ScreenArguments(
                                          classId: 0,
                                          className: "",
                                          name: this.namecontroller.text,
                                          password:
                                              this.passwordcontroller.text),
                                    )
                                  }
                                else if (state is TeacherError)
                                  {
                                    _scaffoldKey.currentState!
                                        // ignore: deprecated_member_use
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        'Could not find user please try again',
                                      ),
                                      duration: Duration(seconds: 2),
                                    )),
                                    namecontroller.clear(),
                                    passwordcontroller.clear()
                                  }
                              }
                            else
                              {}
                          },
                          child: Text("login"),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () => {
                                Navigator.of(context)
                                    .pushNamed(RouteGenerator.singupPage)
                              },
                          child: Text("Signup"))
                    ],
                  ),
                  key: _key,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
