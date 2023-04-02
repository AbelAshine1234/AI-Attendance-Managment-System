import 'package:bloc/bloc.dart';
import 'package:project/class/bloc/ClassEvent.dart';
import 'package:project/students/bloc/StudentEvent.dart';
import 'package:project/students/bloc/StudentState.dart';
import 'package:project/students/models/student_models.dart';
import 'package:project/students/repostiories/student_repositery.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentRepository studentRepository;

  StudentBloc({required this.studentRepository}) : super(StudentEmpty());
  Stream<StudentState> mapEventToState(StudentEvent studentEvent) async* {
    if (studentEvent is CreateStudent) {
      print("creating student");
      yield OneStudentLoading();
      try {
        final Student student = await studentRepository.studentApiClient
            .createStudent(studentEvent.name);
        yield OneStudentLoaded(student: student);
      } catch (e) {
        print(e.toString());
        yield StudentError();
      }
    }
    if (studentEvent is UpdateStudent) {
      print("updating student");
      yield OneStudentLoading();
      try {
        final Student student = await studentRepository.studentApiClient
            .updateStudent(studentEvent.id, studentEvent.studentName);
        yield OneStudentLoaded(student: student);
      } catch (e) {
        print(e.toString());
        yield StudentError();
      }
    }
    if(studentEvent is AddImageToStudent){
      print("adding student");
      yield OneStudentLoading();
      try {
        await studentRepository.studentApiClient.addImage(studentEvent.studentId, studentEvent.studentImage);
        print("hi");
        final List<Student> students =
            await studentRepository.studentApiClient.getStudents();
        yield AllStudentLoaded(students: students);
      } catch (e) {
        print("object");
        print(e.toString());
        yield StudentError();
      }
      
    }
    if (studentEvent is GetAllStudents) {
      print("student loadind");

      yield OneStudentLoading();
      try {
        final List<Student> students =
            await studentRepository.studentApiClient.getStudents();
        yield AllStudentLoaded(students: students);
      } catch (e) {
        print(e.toString());
        yield StudentError();
      }
    }
  }
}
