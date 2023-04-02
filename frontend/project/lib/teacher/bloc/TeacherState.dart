import 'package:equatable/equatable.dart';
import 'package:project/teacher/models/Teachers.dart';

abstract class TeacherState extends Equatable {
  const TeacherState();
  @override
  List<Object?> get props => [];
}

class TeacherEmpty extends TeacherState{}
class TeacherIsLoading extends TeacherState{}
class OneTeacherLoaded extends TeacherState {
  final Teacher teacher;
  const OneTeacherLoaded({required this.teacher});
  @override
  List<Object?> get props => [teacher];
}

class AllTeacherLoaded extends TeacherState {
  final Iterable<Teacher> teachers;
  const AllTeacherLoaded({required this.teachers});
  @override
  List<Object?> get props => [teachers];
}

class TeacherError extends TeacherState{}