import 'package:bloc/bloc.dart';
import 'package:project/teacher/models/Teachers.dart';
import 'package:project/teacher/repositories/teacher_repository.dart';

import 'TeacherEvent.dart';
import 'TeacherState.dart';

class TeacherBloc extends Bloc<TeacherEvent, TeacherState> {
  final TeacherRepository teacherRepository;
  TeacherBloc({required this.teacherRepository}) : super(TeacherEmpty());
  Stream<TeacherState> mapEventToState(TeacherEvent teacherEvent) async* {
    if (teacherEvent is FetchATeacher) {
      print("fetching");
      yield TeacherIsLoading();
      try {
        await teacherRepository.getTeacher(teacherEvent.teacher);
        yield OneTeacherLoaded(teacher: teacherEvent.teacher);
      } catch (e) {
        print(e);
        yield TeacherError();
      }
    } else if (teacherEvent is FetchAllTeachers) {
      yield TeacherIsLoading();
      try {
        final List<Teacher> teachers = await teacherRepository.getAllTeachers();
        yield AllTeacherLoaded(teachers: teachers);
      } catch (e) {
        print(e);
        yield TeacherError();
      }
    } else if (teacherEvent is TeacherUpdate) {
      yield TeacherIsLoading();
      try {
        await teacherRepository.updateTeachers(teacherEvent.oldName,teacherEvent.newName,teacherEvent.password);
        final teachers = await teacherRepository.getAllTeachers();
        yield AllTeacherLoaded(teachers: teachers);
      } catch (e) {
        print(e);
        yield TeacherError();
      }
    } else if (teacherEvent is TeacherDelete) {
      yield TeacherIsLoading();
      try {
        await teacherRepository.deleteTeacher(teacherEvent.teacher);
        final teachers = await teacherRepository.getAllTeachers();
        yield AllTeacherLoaded(teachers: teachers);
      } catch (e) {
        print(e);
        yield TeacherError();
      }
    } else if (teacherEvent is CreateTeacher) {
      yield TeacherIsLoading();
      try {
        await teacherRepository.createTeacher(teacherEvent.teacher);
        yield OneTeacherLoaded(teacher: teacherEvent.teacher);
      } catch (e) {
        print(e);
        yield TeacherError();
      }
    }
  }
}

//
//
