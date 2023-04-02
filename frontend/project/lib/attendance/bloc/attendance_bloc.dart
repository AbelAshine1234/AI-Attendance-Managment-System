import 'package:bloc/bloc.dart';
import 'package:project/attendance/bloc/attendance_event.dart';
import 'package:project/attendance/bloc/attendance_state.dart';
import 'package:project/attendance/model/Attendance.dart';
import 'package:project/attendance/repository/attendance_repository.dart';

class AttendanceBloc extends Bloc<AttendanceEvent,AttendanceState>{
  final AttendanceRepository attendanceRepository;
  AttendanceBloc({required this.attendanceRepository}) : super(AttendanceTakenEmpty());

  @override
  Stream<AttendanceState> mapEventToState(AttendanceEvent event) async*{
    if(event is TakeAttendanceEvent){
      print("taking attendance");
      yield AttendanceTakenLoading();
      try{
        var  attendances = await this.attendanceRepository.attendanceApiClient.takeAttendance(event.classId, event.classImage);
        yield AttendnanceTaken(attendances: attendances);
      }
      catch(e){
        print("e"+e.toString());
        yield AttendanceTakenError();
      }
    }
  }

}