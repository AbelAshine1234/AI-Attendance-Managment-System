import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/attendance/bloc/attendance_bloc.dart';
import 'package:project/attendance/bloc/attendance_state.dart';
import 'dart:convert';
class ShowClassAttendance extends StatefulWidget {
  @override
  _showClassAttendanceState createState() => _showClassAttendanceState();
}

class _showClassAttendanceState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Class Attendnce"),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => {Navigator.of(context).pop()})),
      body:
          BlocBuilder<AttendanceBloc, AttendanceState>(builder: (cont, state) {
        if (state is AttendnanceTaken) {
          
          return ListView.builder(itemCount:state.attendances.response.length,itemBuilder: (ct,index){
            return ListTile(title:Text(state.attendances.response[index].toString()));
          });
        }
        if (state is AttendanceTakenError) {
          return Center(
            child: Text("Error loading attendance"),
          );
        }

        return Center(child: CircularProgressIndicator());
      }),
    );
  }
}
