import 'package:equatable/equatable.dart';
import 'package:project/attendance/model/Attendance.dart';

abstract class AttendanceState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}
class AttendanceTakenEmpty extends AttendanceState{
}
class AttendnanceTaken extends AttendanceState{
  final Attendance attendances;

  AttendnanceTaken({required this.attendances});
  
}
class AttendanceTakenLoading extends AttendanceState{
}
class AttendanceTakenError extends AttendanceState{
}