import 'package:equatable/equatable.dart';
import 'package:project/students/models/student_models.dart';

abstract class StudentState extends Equatable{

}
class StudentEmpty extends StudentState{
  @override
  List<Object?> get props => [];
}

class OneStudentLoading extends StudentState {
  @override
  List<Object?> get props => [];
}
class AllStudentLoaded extends StudentState{
  final List<Student> students;

  AllStudentLoaded({required this.students});
  @override
  List<Object?> get props => [];
}
class OneStudentLoaded extends StudentState {
  final Student student;

  OneStudentLoaded({required this.student});
  @override
  List<Object?> get props => [];
}
class StudentError extends StudentState{
  @override
  List<Object?> get props => [];
}
