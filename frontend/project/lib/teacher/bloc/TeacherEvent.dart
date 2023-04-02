import 'package:equatable/equatable.dart';
import 'package:project/teacher/models/Teachers.dart';

abstract class TeacherEvent extends Equatable {
  const TeacherEvent();
}

class FetchATeacher extends TeacherEvent {
  final Teacher teacher;
  FetchATeacher(this.teacher);

  @override
  List<Object?> get props => [];
}

class FetchAllTeachers extends TeacherEvent {
  @override
  List<Object?> get props => [];
}

class TeacherUpdate extends TeacherEvent {
final String oldName, newName,  password;

TeacherUpdate({required this.oldName, required this.newName, required this.password});


  @override
  List<Object?> get props => [];
}

class TeacherDelete extends TeacherEvent {
  final Teacher teacher;

  TeacherDelete(this.teacher);
  @override
  List<Object?> get props => [];
}

class CreateTeacher extends TeacherEvent {
  final Teacher teacher;
  CreateTeacher(this.teacher);
  @override
  List<Object?> get props => [];
}
