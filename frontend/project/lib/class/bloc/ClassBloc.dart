import 'package:bloc/bloc.dart';
import 'package:project/class/bloc/ClassEvent.dart';
import 'package:project/class/bloc/ClassState.dart';
import 'package:project/class/models/class_model.dart';
import 'package:project/class/repositories/class_repositories.dart';

class ClassBloc extends Bloc<ClassEvent, ClassState> {
  final ClassRepostiry classRepostiry;
  ClassBloc({required this.classRepostiry}) : super(ClassEmpty());
  Stream<ClassState> mapEventToState(ClassEvent classEvent) async* {
    if (classEvent is FetchAllClasses) {
      print("fetching all classes");
      yield ClassIsLoading();
      try {
        final List<ClassName> classNames = await classRepostiry.getClasses(
            classEvent.teacherName, classEvent.teacherPassword);
        yield AllClassesLoaded(classNames: classNames);
      } catch (e) {
        print("Error in fetching all class due to $e");
        yield ClassError(message: e.toString());
      }
    }
    if (classEvent is CreateAClass) {
      print("creating a class");
      yield ClassIsLoading();
      try {
        final classNameCreated = await classRepostiry.classApiClient
            .createClassName(classEvent.className, classEvent.teacherName,
                classEvent.teacherPassword);
        final List<ClassName> classNames = await classRepostiry.getClasses(
            classEvent.teacherName, classEvent.teacherPassword);
        yield AllClassesLoaded(classNames: classNames);
      } catch (e) {
        print("Error happen while creating class due to" + e.toString());
        yield ClassError(message: e.toString());
      }
    }
    if (classEvent is FetchClassDetail) {
      print("loading classname by detail ");
      yield ClassIsLoading();
      try {
        final classDetail =
            await classRepostiry.classApiClient.getClassDetail(classEvent.id);
        yield OneClassLoaded(className: classDetail);
      } catch (e) {
        print("Error on class detail" + e.toString());
        yield ClassError(message: e.toString());
      }
    }
    if (classEvent is AddStudentToClass) {
      print("adding  student to class");
      yield ClassIsLoading();
      try {
        await classRepostiry.classApiClient
            .addStudent(classEvent.classId, classEvent.studentId);
        final classDetail = await classRepostiry.classApiClient
            .getClassDetail(classEvent.classId);
        yield OneClassLoaded(className: classDetail);
      } catch (e) {
        print("Error on class addd student due to " + e.toString());
        yield ClassError(message: e.toString());
      }
    }
    if (classEvent is DeleteClass) {
      print("deleting a class");
      yield ClassIsLoading();
      try {
        await classRepostiry.classApiClient.deleteClass(classEvent.id);
        final List<ClassName> classNames = await classRepostiry.getClasses(
            classEvent.teacherName, classEvent.teacherPassword);
        yield AllClassesLoaded(classNames: classNames);
      } catch (e) {
        print("Error in fetching all class due to $e");
        yield ClassError(message: e.toString());
      }
    }
  }
}
