

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/students/bloc/StudentBloc.dart';
import 'package:project/students/bloc/StudentEvent.dart';
import 'package:project/students/bloc/StudentState.dart';

class CreateStudentWidget extends StatefulWidget {
  const CreateStudentWidget({Key? key,}) : super(key: key);
  _CreateClassState createState() => _CreateClassState();
}

class _CreateClassState extends State {
  final classnamecontroller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _key = GlobalKey<FormState>();
  
  String? _nameValidator(String? value) {
    if (value!.isEmpty) {
      return "Name can not be empty";
    } else {
      return null;
    }
  }

  Widget _StudentName() {
    return TextFormField(
      controller: classnamecontroller,
      decoration: InputDecoration(hintText: "Student Name"),
      validator: _nameValidator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentBloc, StudentState>(builder: (context, state) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("Create Student"),
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
                    _StudentName(),
                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: ElevatedButton(
                          onPressed: () {
                            if (_key.currentState!.validate()) {
                             BlocProvider.of<StudentBloc>(context).add(CreateStudent(name: this.classnamecontroller.text));
                            Navigator.of(context).pop();
                             
                            } else {

                            }
                          },
                          child: Text("Create a student")),
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
