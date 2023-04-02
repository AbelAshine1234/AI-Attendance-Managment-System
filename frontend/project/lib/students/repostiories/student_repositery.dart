import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:project/students/models/student_models.dart';
import 'package:project/students/repostiories/student_api_client.dart';

class StudentRepository {
  final StudentApiClient studentApiClient;

  StudentRepository({required this.studentApiClient});
  Future<Student> createClass(String name) async {
    return await studentApiClient.createStudent(name);
  }
  Future<Student> updateStudent(int id,String studentName) async{
    return await studentApiClient.updateStudent(id, studentName);
  }
  Future<void> addImageStudent(int studentId,List<int> studentImage) async{
    return await studentApiClient.addImage(studentId, studentImage);
  }
  Future<List<Student>> getStudents() async{
    return await studentApiClient.getStudents();
  }
}
