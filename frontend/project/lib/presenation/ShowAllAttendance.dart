import 'package:flutter/material.dart';

class ShowAllAttendance extends StatefulWidget {
  @override
  _ShowAllAttendanceState createState()=>_ShowAllAttendanceState();

}
class _ShowAllAttendanceState extends State{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      home: Scaffold(
        body: Column(
          children: [
            Text("Show All Attendances"),
            ElevatedButton(onPressed: ()=>{
                Navigator.of(context).pop()
            }, child: Text("back"))
          ],
        ),
      ),
    );
  }
}
