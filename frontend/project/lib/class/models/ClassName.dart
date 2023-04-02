import 'package:equatable/equatable.dart';

class ClassName extends Equatable {
  final String name;
  final int classNameId;
  final int teacherId;
  final List<dynamic> studentsId;
  final String studentsAttendance;

  ClassName(
      {required this.name,
      required this.classNameId,
      required this.teacherId,
      required this.studentsId,
      required this.studentsAttendance});
  List<Object?> get props => [name, teacherId, studentsId, studentsAttendance];

  @override
  factory ClassName.fromJson(Map<String, dynamic> json) {

    return ClassName(
        classNameId: json["id"] as int,
        name: json["name"] as String,
        teacherId: json["teacher"] as int,
        studentsId: json["students-id"] is String?[]:json["students-id"] as List<dynamic>,
        studentsAttendance: json['students-attendance'] as String);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["name"] = this.name;
    data["teacher"] = this.teacherId;
    data["students-id"] = this.studentsId;
    data["students-attendance"] = this.studentsAttendance;
    return data;
  }

  @override
  String toString() =>
      "Name of the  class ${this.name} Teacher id ${this.teacherId}";
}
