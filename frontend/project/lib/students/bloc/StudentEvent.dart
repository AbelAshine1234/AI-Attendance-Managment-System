import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class StudentEvent extends Equatable {
}

class CreateStudent extends StudentEvent {
  final String name;

  CreateStudent({required this.name});
  @override
  List<Object?> get props => [];
}
class UpdateStudent extends StudentEvent{
  final String studentName;
  final int id;

  UpdateStudent({required this.studentName, required this.id});
  @override
  List<Object?> get props => [studentName,id];
}
class AddImageToStudent extends StudentEvent{
  List<int> studentImage;
  int studentId;
  AddImageToStudent({required this.studentId,required this.studentImage});
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class GetAllStudents extends StudentEvent{
  @override
  List<Object?> get props => [];
}  
