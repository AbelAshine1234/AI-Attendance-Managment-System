class Student {
  final int studentId;
  final String studentName;
  final String imagePath;

  Student({required this.studentId, required this.studentName,required this.imagePath});
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(studentId: json["id"], studentName: json["name"],imagePath: json["image"]);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    
    data["name"] = this.studentName;
    data["id"] = this.studentId;
    data["image"]=this.imagePath;
    return data;
  }
  @override
  String toString() => "StudentName $studentName and Student id $studentId";
}
