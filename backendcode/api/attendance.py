import ast
from datetime import datetime
import re
from flask import Blueprint, json, request, jsonify
from werkzeug.exceptions import MethodNotAllowed
from werkzeug.utils import secure_filename
from .models import AttendanceSheet, ClassName, Student, Teacher
from . import db
import os
import face_recognition
attendance = Blueprint('attendance', __name__)

# This code will take attendance we enter the class id and image
# After comparing the students in the class image and the image we given it will give us the user that are present


@attendance.route("/takeAttendance/<int:id>", methods=['POST'])
def take_attendance(id):
    print("started")
    class_name = ClassName.query.filter_by(id=id).first()
    if not class_name:
        return jsonify({"message": "There is no class name by this id"})
    if 'file' not in request.files:
        return jsonify({"message": "Please take a picture or send a picture"})
    print("getting image request file")
    image = request.files['file']
    print("response is ccorrect")

    class_info = {"id": class_name.id, "name": class_name.name,
                  "students": class_name.students_id}

    image.save(os.path.join('./api/resources/attendance_image/',
                            str(class_info['id'])+".jpg"))

    attendance_image_directory = os.path.join(
        './api/resources/attendance_image/', str(class_info['id'])+".jpg")

# Before we add the image to the database we will check if there is a human in the picture
    attendance_image = face_recognition.load_image_file(
        attendance_image_directory)
    attendance_image_face_locations = face_recognition.face_locations(
        attendance_image)
    if(attendance_image_face_locations == []):
        return jsonify({"message": "Enter the picture of the student this does not look like it have one"})
    # We have to use the encoding of the faces to compare with the image of the student

    attendance_image_encodings = face_recognition.face_encodings(
        attendance_image)

# Getting all student id
    student_ids = class_info["students"].split(",")

    current_attendance = []
    to_return =[]

    # iterating through student
    for each_student_id in student_ids:
        # If the id is not equal to -1 we have user with id -1 for some case
        if(int(each_student_id) != -1):

            current_student = Student.query.filter_by(
                id=each_student_id).first()

            current_student_image_directory = current_student.student_image
            # We get the image of each user then compare it
            current_student_image = face_recognition.load_image_file(
                current_student_image_directory)
            current_student_image_face_encoding = face_recognition.face_encodings(
                current_student_image)[0]

# initally the attend is false
            isAttend = False
            # for each student we will compare the face encoding
            for each_face in attendance_image_encodings:
                same = face_recognition.compare_faces(
                    [each_face], current_student_image_face_encoding)
                # We will break if the user is there like calling in class
                if same[0] == True:
                    isAttend = True
                    break

            current_student_info = {"id": current_student.id, "name": current_student.name,
                                    "image": current_student.student_image, "attend": str(isAttend)}
            isAttend = str(isAttend)
            name = str(current_student.name)
            print(isAttend)
            print(name)
            to_append = f"Name {name} Attend {isAttend}"
            current_attendance.append(current_student_info)
            to_return.append(str(to_append))



# the id of the student is the current
    now = datetime.now()
    today_string = now.strftime("%d/%m/%Y %H %M")

    current_attendance = str(current_attendance)

    new_attendance = AttendanceSheet(id=today_string, attendances=current_attendance, day=today_string,
                                     image=attendance_image_directory, teacher_id=str(class_name.teacher), class_name=id)
    db.session.add(new_attendance)
    db.session.commit()

    to = jsonify({"id":str(new_attendance.id),"attendance":str(new_attendance.attendances),"day":str(new_attendance.day),"image":str(new_attendance.image),"teacher-id":str(new_attendance.teacher_id),"class-id":str(new_attendance.class_name)})

    return jsonify({"response":to_return})


@attendance.route("/getAttendance/<int:id>", methods=['GET'])
def get_attendance(id):
    class_name = ClassName.query.filter_by(id=id).first()
    if not class_name:
        return jsonify({"message": "There is no class name by this id"})
    data = request.get_json()
    if data is None:
        return jsonify({"message": "Please enter the time  of the attendance "})
    if data.get('time') is None:
        return jsonify({"message": "Please enter the time  of the attendance "})

    get_attendance = AttendanceSheet.query.filter_by(
        class_name=id).first()

    if not get_attendance:
        return jsonify({"message": "There is no attendance "})

    to_return = {"attendances": get_attendance.attendances,
                 "class name": get_attendance.class_name, "image": get_attendance.image}
    return jsonify({"m": to_return})


@attendance.route('/getallAttendance/<int:id>', methods=['GET'])
def get_all_attendances(id):
    class_name = ClassName.query.filter_by(id=id).first()
    if class_name is None:
        return jsonify({"message": "There is no class by this id"})
    all_attendance = AttendanceSheet.query.all()
    to_return = []
    another_to_return=[]
    students=[]
    days =[]
    for each_attendance in all_attendance:
        
        attendance = {"id": each_attendance.id,
                      "date": each_attendance.day,
                      "attendance": each_attendance.attendances,
                      "class": class_name.name}
        name = each_attendance.attendances
        name = str(name)
        anname = name.split("][")
        
        bname = anname[0].split("},{")
        cname = bname[0][1:-1]
        print("\n\n\n\n\n\n\n\n")
        # print(cname)
        dname = cname.split(", {'")
        # print(dname[0])
        ename = ast.literal_eval(dname[0])

        print(ename["name"])
        students.append(ename)
        day_attendance_taken = each_attendance.day
        days.append(day_attendance_taken)
        
        attendance = {"id": each_attendance.id,
                      "date": each_attendance.day,
                      "attendance": each_attendance.attendances,
                      "class": class_name.name}
        another_to_return.append(attendance)

        
    return jsonify({"message":another_to_return})


@attendance.route('/deleteAttendance/<int:id>', methods=['DELETE'])
def delete_attendance(id):
    class_name = ClassName.query.filter_by(id=id).first()
    if class_name is None:
        return jsonify({"message": "There is no class by this id"})
    data = request.get_json()
    if data is None:
        return jsonify({"message": "Enter year month day and the hour of the attendance FORMAT D/M/Y HOUR21/12/2021 13:05"})
    if data.get('day') is None:
        return jsonify({"message": "Enter day or year month day and the hour of the attendance FORMAT D/M/Y HOUR 21/12/2021 13:05"})

    get_attendance = AttendanceSheet.query.filter_by(
        id=data.get('day')).first()
    if get_attendance is None:
        return jsonify({"message": "No Attendance by this day and ime"})
    to_return = {"id": get_attendance.id, "data": get_attendance.day,
                 "class-id": get_attendance.class_name}
    db.session.delete(get_attendance)
    db.session.commit()

    return jsonify({"message": f"{to_return} has been deleted"})
