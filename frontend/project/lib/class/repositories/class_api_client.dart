import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/class/models/class_model.dart';
import 'package:project/teacher/models/Teachers.dart';

class ClassApiClient {
  final http.Client httpClient;
  const ClassApiClient({required this.httpClient});
  Future<ClassName> getClassDetail(int id) async {
    final response = await this
        .httpClient
        .get(Uri.parse("http://127.0.0.1:3000/getClassDetail/$id"));
    if (response.statusCode != 200) {
      print(response.body);
    }
    final json = jsonDecode(response.body);
    print(json);
    return ClassName.fromJson(json);
  }

  Future<List<ClassName>> getClasses(String name, String password) async {
    final response = await this
        .httpClient
        .get(Uri.parse("http://127.0.0.1:3000/getClasses/$name/$password"));
    if (response.statusCode != 200) {
      print(response.body);
    }
    final json = jsonDecode(response.body) as List;
    return json.map((className) => ClassName.fromJson(className)).toList();
  }

  Future<ClassName> createClassName(
      String className, String teacherName, String teacherpPassword) async {
    final response =
        await httpClient.post(Uri.parse("http://127.0.0.1:3000/createClass"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              "teacher-name": teacherName,
              "teacher-password": teacherpPassword,
              "class-name": className
            }));
    if (response.statusCode != 200) {
      throw Exception("Could not create class Name due to" + response.body);
    }
    final json = jsonDecode(response.body);
    print(json);
    return ClassName.fromJson(json);
  }

  Future<void> addStudent(int classId, int studentId) async {
    final response = await httpClient.post(
        Uri.parse("http://127.0.0.1:3000/register/addStudent/$classId"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{"student-id": studentId}));
    if (response.statusCode != 200) {
      throw Exception("COuld not add student due to " + response.body);
    }
  }

  Future<void> deleteClass(int id) async {
    final response = await httpClient
        .delete(Uri.parse("http://127.0.0.1:3000/deleteClass/$id"));
    if (response.statusCode != 200) {
      throw Exception("Could not delete data because" + response.body);
    }
  }
}
