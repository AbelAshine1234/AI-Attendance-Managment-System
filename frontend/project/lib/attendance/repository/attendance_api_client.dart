import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:project/attendance/model/Attendance.dart';

class AttendanceApiClient {
  final http.Client httpClient;
  AttendanceApiClient({required this.httpClient});
  Future<Attendance> takeAttendance(
      int classId, List<int> attendanceImage) async {
    var url = Uri.parse("http://127.0.0.1:3000/attend/takeAttendance/$classId");

    var request = new http.MultipartRequest("POST", url);
    print("start");
    request.files.add(await http.MultipartFile.fromBytes(
        'file', attendanceImage,
        contentType: new MediaType('application', 'octet-stream'),
        filename: "a"));
    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    final json = jsonDecode(respStr);
    return Attendance.fromJson(json);
   
  }
}
