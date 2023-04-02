import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:project/students/bloc/StudentBloc.dart';
import 'package:project/students/bloc/StudentEvent.dart';
import 'package:project/students/bloc/StudentState.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;

enum ImageLoadingStatus { EMPTY, LOADING, ERROR, LOADED }

class ShowStudentDetail extends StatefulWidget {
  final String studentName;
  final String imagePath;
  final int id;

  const ShowStudentDetail(
      {Key? key,
      required this.studentName,
      required this.imagePath,
      required this.id})
      : super(key: key);
  _ShowStudentDetailState createState() => _ShowStudentDetailState(
      studentName: studentName, imagePath: imagePath, id: id);
}

class _ShowStudentDetailState extends State {
  final String studentName;
  final String imagePath;
  final int id;
  ImageLoadingStatus imageLoadingStatus = ImageLoadingStatus.EMPTY;

  _ShowStudentDetailState(
      {required this.studentName, required this.imagePath, required this.id});

  late List<int> _selectedFile;
  late Uint8List _bytesData;
  
  startWebFilePicker() async {
    html.InputElement uploadInput = html.FileUploadInputElement() as html.InputElement;
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      final file = files![0];
      final reader = new html.FileReader();

      reader.onLoadEnd.listen((e) {
        _handleResult(reader.result??"");
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
  Widget build(BuildContext Bcontext) {
    return BlocBuilder<StudentBloc, StudentState>(builder: (context, state) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Edit Students"),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              child: Text(
                "Name ${this.studentName}",
                style: TextStyle(fontSize: 45),
              ),
            ),
            Form(
                key: _key,
                child: Column(
                  children: [
                    Container(
                      child: Image.network("http://127.0.0.1:3000/register/displayImage/$id")  ,
                    ),
                     _Name(),
                    Container(
                        margin: EdgeInsets.all(16),
                        child: ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<StudentBloc>(context).add(
                                AddImageToStudent(
                                    studentId: this.id,
                                    studentImage: this._selectedFile));
                              Navigator.of(Bcontext).pop();
                                
                          },
                          child: Text('Save Image'),
                          
                        )),
                    // _buildAddPhoto(),
                  ElevatedButton(onPressed: ()=>{
                    startWebFilePicker()
                  }, child: Text("Load Image")),
                    ElevatedButton(
                        onPressed: () => {
                              if (_key.currentState!.validate())
                                {
                                  BlocProvider.of<StudentBloc>(context).add(
                                      UpdateStudent(
                                          studentName: this.namecontroller.text,
                                          id: id)),
                                }
                            },
                        child: Text("Update Name"))
                  ],
                ))
          ],
        ),
      );
    });
  }

  
}
