import 'package:project/class/models/ClassName.dart';
import 'package:project/class/repositories/class_api_client.dart';
import 'package:project/teacher/models/Teachers.dart';

class ClassRepostiry{
  final ClassApiClient classApiClient;

  ClassRepostiry({required this.classApiClient});

  Future<ClassName> getClassDetail(int id) async{
    return await classApiClient.getClassDetail(id);
  }
  Future<List<ClassName>> getClasses(String name,String password) async{
    return await classApiClient.getClasses(name, password);
  }
  Future<void> addStudent(int classId,int studentId) async{
    return await classApiClient.addStudent(classId, studentId);
  }
  Future<void> deleteClass(int id) async{
    return await classApiClient.deleteClass(id);
  }

}