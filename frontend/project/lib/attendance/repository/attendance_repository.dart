import 'package:project/attendance/model/Attendance.dart';
import 'package:project/attendance/repository/attendance_api_client.dart';

class AttendanceRepository {
  final AttendanceApiClient attendanceApiClient;

  AttendanceRepository({required this.attendanceApiClient});
  Future<Attendance> takeAttendance(int classId, List<int> attendanceImage) async {
    return await attendanceApiClient.takeAttendance(classId, attendanceImage);
  }
}
