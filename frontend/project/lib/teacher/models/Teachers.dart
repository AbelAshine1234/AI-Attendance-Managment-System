import 'package:equatable/equatable.dart';

class Teacher extends Equatable {

  final String name;
  final String password;
  final int id;
  const Teacher({ required this.id,required this.name,required this.password});
  @override
  List<Object?> get props => [ name,password];

  factory Teacher.fromJson(Map<String,dynamic> json) {
    return Teacher( name: json["name"],password:json["password"], id: json["id"]);
  }
  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data["name"] = this.name;
    data["password"]=this.password;
    return data;
  }
  @override
  String toString() => "Name of the teacher $name and teacher password is $password";
}
