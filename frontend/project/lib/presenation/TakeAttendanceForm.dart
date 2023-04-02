import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:html' as html;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/attendance/bloc/attendance_bloc.dart';
import 'package:project/attendance/bloc/attendance_event.dart';
import 'package:project/attendance/bloc/attendance_state.dart';
import 'package:project/routes.dart';

class TakeAttendanceForm extends StatefulWidget {
  final int classId;

  const TakeAttendanceForm({Key? key, required this.classId}) : super(key: key);
  _TakeAttendanceFormState createState() =>
      _TakeAttendanceFormState(classId: classId);
}

class _TakeAttendanceFormState extends State {
  final int classId;

  _TakeAttendanceFormState({required this.classId});

  late List<int> _selectedFile;
  late Uint8List _bytesData;

  startWebFilePicker() async {
    html.InputElement uploadInput =
        html.FileUploadInputElement() as html.InputElement;
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      final file = files![0];
      final reader = new html.FileReader();

      reader.onLoadEnd.listen((e) {
        _handleResult(reader.result ?? "");
      });
      reader.readAsDataUrl(file);
    });
  }

  void _handleResult(Object result) {
    setState(() {
      _bytesData = Base64Decoder().convert(result.toString().split(",").last);
      _selectedFile = _bytesData;
    });
  }

  final namecontroller = TextEditingController();
  final _key = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
          icon: Icon(Icons.verified_user), hintText: "Student Name"),
      validator: _validateName,
    );
  }

  @override
  Widget build(BuildContext buildContext) {
    return BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Take Attendance"),
        ),
        body: Form(
            key: _key,
            child: Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                          onPressed: () => {startWebFilePicker()},
                          child: Text(
                            "Load Image",
                            style: TextStyle(fontSize: 23),
                          )),
                    ),
                    ElevatedButton(
                        onPressed: () => {
                              BlocProvider.of<AttendanceBloc>(context).add(
                                  TakeAttendanceEvent(
                                      classId: this.classId,
                                      classImage: this._selectedFile)),
                              Navigator.of(context).popAndPushNamed(
                                  RouteGenerator.showClassAttendance)
                            },
                        child: Text(
                          "Take Attedance",
                          style: TextStyle(fontSize: 23),
                        ))
                  ],
                ),
              ),
            )),
      );
    });
  }
}
