import 'package:equatable/equatable.dart';

abstract class AttendanceEvent extends Equatable{
  @override
  List<Object?> get props => [];
}
class TakeAttendanceEvent extends AttendanceEvent{
  final int classId;
  final List<int> classImage;

  TakeAttendanceEvent({required this.classId, required this.classImage});
  @override
  List<Object?> get props => [classId,classImage];

}