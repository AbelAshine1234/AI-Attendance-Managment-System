import 'package:http/http.dart' as http;
import 'package:project/teacher/models/Teachers.dart';
import 'package:project/teacher/repositories/teacher_api_client.dart';

class TeacherRepository {
  final TeacherApiClient teacherApiClient;
  TeacherRepository({required this.teacherApiClient});
  Future<Teacher> getTeacher(Teacher teacher) async {
    return await teacherApiClient.getTeacher(teacher);
  }

  Future<List<Teacher>> getAllTeachers() async {
    return await teacherApiClient.getAllTeachers();
  }

  Future<void> updateTeachers(
      String oldName, String newName, String password) async {
    return await teacherApiClient.updateTeacher(oldName, newName, password);
  }

  Future<void> deleteTeacher(Teacher teacher) async {
    return await teacherApiClient.deleteTeacher(teacher);
  }

  Future<Teacher> createTeacher(Teacher teacher) async {
    return await teacherApiClient.createTeacher(teacher);
  }
}
