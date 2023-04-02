import 'package:equatable/equatable.dart';
import 'package:project/class/models/ClassName.dart';
import 'package:project/teacher/models/Teachers.dart';

abstract class ClassEvent extends Equatable {
  const ClassEvent();
}

class CreateAClass extends ClassEvent {
  final String className;
  final String teacherName;
  final String teacherPassword;

  CreateAClass(this.className, this.teacherName, this.teacherPassword);
  @override
  List<Object?> get props => [className, teacherName, teacherPassword];
}

class FetchAClass extends ClassEvent {
  final Teacher teacher;

  FetchAClass({required this.teacher});
  @override
  List<Object?> get props => [teacher];
}

class FetchAllClasses extends ClassEvent {
  final String teacherName;
  final String teacherPassword;

  FetchAllClasses({required this.teacherName, required this.teacherPassword});
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchClassDetail extends ClassEvent {
  final int id;

  FetchClassDetail(this.id);
  @override
  List<Object?> get props => [];
}
class AddStudentToClass extends ClassEvent{
  final int classId;
  final int studentId;

  AddStudentToClass({required this.classId, required this.studentId});
  @override
  List<Object?> get props => [];
}

class DeleteClass extends ClassEvent {
  final int id;
  final String teacherName;
  final String teacherPassword;

  DeleteClass({required this.id, required this.teacherName, required this.teacherPassword});

  @override
  List<Object?> get props => [];
}

class ErrorClass extends ClassEvent{
  final String message;

  ErrorClass({required this.message});
  @override
  List<Object?> get props => [];
}