import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/Arguments/ScreenArguments.dart';
import 'package:project/class/bloc/ClassBloc.dart';
import 'package:project/class/bloc/ClassEvent.dart';
import 'package:project/class/bloc/ClassState.dart';
import 'package:project/routes.dart';

class CreateClass extends StatefulWidget {
  final String teacherName;
  final String teacherPassword;

  const CreateClass({Key? key, required this.teacherName, required this.teacherPassword}) : super(key: key);
  _CreateClassState createState() => _CreateClassState(teacherName,teacherPassword);
}

class _CreateClassState extends State {
  final String teacherName;
  final String teacherPassword;
  final classnamecontroller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _key = GlobalKey<FormState>();

  _CreateClassState(this.teacherName, this.teacherPassword);

  String? _nameValidator(String? value) {
    if (value!.isEmpty) {
      return "Name can not be empty";
    } else {
      return null;
    }
  }

  Widget _ClassName() {
    return TextFormField(
      controller: classnamecontroller,
      decoration: InputDecoration(hintText: "Class Name"),
      validator: _nameValidator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassBloc, ClassState>(builder: (context, state) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("Create class"),
            leading: IconButton(
              padding: EdgeInsets.only(top: 5),
              alignment: Alignment.topLeft,
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          key: _scaffoldKey,
          body: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              height: MediaQuery.of(context).size.height / 1.6,
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    _ClassName(),
                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: ElevatedButton(
                          onPressed: () {
                            if (_key.currentState!.validate()) {
                              BlocProvider.of<ClassBloc>(context).add(CreateAClass(classnamecontroller.text,teacherName,teacherPassword));
                              Navigator.of(context).popAndPushNamed(RouteGenerator.showClasses,arguments: ScreenArguments(classId: 0, className: this.classnamecontroller.text, name: this.teacherName, password: this.teacherPassword));
                             
                            } else {

                            }
                          },
                          child: Text("Create a class")),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
