import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project/teacher/models/models.dart';

class TeacherApiClient {
  final http.Client httpClient;
  TeacherApiClient({required this.httpClient});
  Future<Teacher> createTeacher(Teacher teacher) async {
    print("ceatting teacher");
    final response = await httpClient.post(
      Uri.parse("http://127.0.0.1:3000/createTeacher"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{"name": teacher.name, "password": teacher.password},
      ),
    );
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception("Could not create teacher do to" + response.body);
    }
    print(response.body);
    return Teacher.fromJson(jsonDecode(response.body));
  }

  Future<Teacher> getTeacher(Teacher teacher) async {
    String username = teacher.name;
    String password = teacher.password;
    final response = await this.httpClient.get(
      Uri.parse("http://127.0.0.1:3000/getTeacher/$username/$password"),
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
      },
    );

    if (response.statusCode != 200) {
      print(response.body);
      throw Exception("Could not found teacher");
    }
    final json = jsonDecode(response.body);
    print(json);
    return Teacher.fromJson(json);
  }

  Future<List<Teacher>> getAllTeachers() async {
    print("hi");
    final response = await this.httpClient.get(
          Uri.parse("http://127.0.0.1:3000/getTeachers"),
        );
    print("response.body");
    if (response.statusCode != 200) {
      print(response.body);
      throw Exception("Could not found teachers");
    }
    print(response);
    final json = jsonDecode(response.body) as List;
    print(json);
    return json.map((teacher) => Teacher.fromJson(teacher)).toList();
  }

  Future<void> updateTeacher(
      String oldName, String newName, String password) async {
    final http.Response response = await httpClient.put(
        Uri.parse("http://127.0.0.1:3000/updateTeacher"),
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(<String, dynamic>{
          'old-name': oldName,
          'new-name': newName,
          'old-password': password
        }));
    if (response.statusCode != 200) {
      print(response.body);
      throw Exception("Failed to update Teacher");
    }
  }

  Future<void> deleteTeacher(Teacher teacher) async {
    final http.Response response = await httpClient.delete(
        Uri.parse("http://127.0.0.1:3000/deleteTeacher/1"),
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(<String, dynamic>{'name': teacher.name}));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete Teacher");
    }
  }
}
