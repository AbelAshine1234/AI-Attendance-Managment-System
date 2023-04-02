class Attendance {
  final List<dynamic> response;
  static const int index = 0;
  Attendance({required this.response});
  @override
  factory Attendance.fromJson(Map<String,dynamic> json) {
    
    return Attendance(response: json["response"] );
  }
}
