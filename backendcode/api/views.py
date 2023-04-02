from re import T
import re
from flask import Blueprint, json, request, jsonify, make_response
from flask.wrappers import Response
from werkzeug.exceptions import MethodNotAllowed
from .models import ClassName, Student, Teacher
from . import db
from random import randrange


views = Blueprint('views', __name__)


@views.route("/getTeachers", methods=['GET'])
def get_teachers():

    teachers = Teacher.query.all()
    to_return = []
    for each_teacher in teachers:
        results = {"id": each_teacher.id, 'name': each_teacher.name,
                   'password': each_teacher.password}
        to_return.append(results)

    to_return = jsonify(to_return)
    to_return = make_response(to_return)

    to_return.headers['Access-Control-Allow-Origin'] = '*'
    return to_return


@views.route("/getTeacher/<string:name>/<string:password>", methods=['GET'])
def get_teacher(name, password):
    teacher = Teacher.query.filter_by(password=password, name=name).first()
    if teacher is None:
        return jsonify({"message": "Password or username is incorrect "}), 404
    to_return = {"id": teacher.id, "name": teacher.name,
                 'password': teacher.password}

    to_return = jsonify(to_return)
    to_return.headers['Access-Control-Allow-Origin'] = '*'
    return to_return


@views.route("/createTeacher", methods=['POST'])
def create_teacher():
    data = request.get_json()
    rand_id = randrange(2345634)
    print(data)
    if data is None:
        return jsonify({"message": "Please enter a name and password"}), 404
    if data.get('name') is None:
        return jsonify({"message": "Please enter name of the teacher"}), 404
    if data.get('password') is None:
        return jsonify({"message": "Please enter password of the teacher"}), 400
    user = Teacher.query.filter_by(id=rand_id).first()
    if user:
        return jsonify({"message": "This  Teacher id is already in use please try againg"}), 404
    name = data.get('name')
    password = data.get('password')

    new_teacher = Teacher(
        id=rand_id, name=name, password=password)
    db.session.add(new_teacher)
    db.session.commit()

    to_return = {"id": new_teacher.id, "name": new_teacher.name,
                 "password": new_teacher.password}
    to_return = jsonify(to_return)

    return to_return


@views.route("/updateTeacher", methods=['PUT'])
def update_teacher():
    data = request.get_json()
    if data is None:
        return jsonify({"message": "Enter old data and new data "}), 404
    if data.get('old-password') is None:
        return jsonify({"message": "enter old-password"}), 404
    if data.get('old-name') is None:
        return jsonify({"message": "enter old-name"}), 404
    old_password = data.get('old-password')
    old_name = data.get('old-name')

    user = Teacher.query.filter_by(
        name=old_name, password=old_password).first()
    if user is None:
        return jsonify({"message": "There is no teacher by this name and password"}), 400
    if data.get('new-name') is None:
        return jsonify({"message": "enter new-name"})
    user.name = data.get('new-name')
    db.session.commit()

    to_return = {'id': user.id,
                 'name': user.name, 'password': user.password}
    to_return = jsonify(to_return)

    return to_return


@views.route("/deleteTeacher", methods=['DELETE'])
def delete_teacher():
    data = request.get_json()
    if data is None:
        return jsonify({"message": "No password or name is  entered"}), 404
    if data.get('name') is None:
        return jsonify({"message": "No user name entered"}), 404
    if data.get('password') is None:
        return jsonify({"message": "No password entered"}), 404
    user = Teacher.query.filter_by(name=data.get(
        'name'), password=data.get('password')).first()
    if user is None:
        return jsonify({"Message": "There is No User by this name and passwordd"})

    to_return = {'id': user.id, 'name': user.name, "password": user.password}
    db.session.delete(user)
    db.session.commit()
    return jsonify({"Message": f"User {to_return}has been deleted"})


# Student


@views.route("/getStudents", methods=['GET'])
def get_students():

    students = Student.query.all()
    to_return = []
    for each_student in students:
        results = {"id": each_student.id, 'name': each_student.name,
                   'image': each_student.student_image}
        to_return.append(results)
    return jsonify(to_return)


@views.route("/getStudent/<int:id>", methods=['GET'])
def get_student(id):

    student = Student.query.filter_by(id=id).first()
    if student is None:
        return jsonify({"message": "There is no student by this id"}), 404

    to_return = {"id": student.id, "name": student.name,
                 "image": student.student_image}

    return jsonify(to_return)


@views.route("/createStudent", methods=['POST'])
def create_student():

    data = request.get_json()
    rand_id = randrange(345678)
    if data is None:
        return jsonify({"message": "Please enter a name of the student"}), 400
    if data.get('name') is None:
        return jsonify({"message": "Please enter name of the studnet"}), 400

    old_student = Student.query.filter_by(id=rand_id).first()

    if old_student:
        return jsonify({"message": "There is student by this id"})
    new_student = Student(id=rand_id, name=data.get('name'), student_image="")
    db.session.add(new_student)
    db.session.commit()
    to_return = {"id": new_student.id, "name": new_student.name,
                 "image": new_student.student_image}
    return jsonify(to_return)


@views.route("/updateStudent/<id>", methods=['PUT'])
def update_student(id):
    data = request.get_json()
    student = Student.query.filter_by(id=id).first()
    if student is None:
        return jsonify({"message": "There is no student by this id"}), 404
    if data.get('name') is None:
        return jsonify({"message": "Please enter name of the student"}), 400

    student.name = data.get('name')
    db.session.commit()

    to_return = {'id': student.id,  'name': student.name,
                 "image": student.student_image}

    return jsonify(to_return)


@views.route("/deleteStudent/<id>", methods=['DELETE'])
def delete_student(id):
    user = Student.query.filter_by(id=id).first()

    if user is None:
        return jsonify({"Message": "There is no user by this id"})
    id = user.id
    name = user.name
    to_return = {'id': id, 'name': name}
    db.session.delete(user)

    return jsonify({"Message": f"User {to_return}has been deleted"})

    db.session.commit()

# Class


@views.route("/getClassDetail/<int:id>", methods=['GET'])
def get_classes_detail(id):
    class_name = ClassName.query.filter_by(id=id).first()
    if not class_name:
        return jsonify({"message": "No Class Name by this id"}), 404
    all_students = class_name.students_id
    print(all_students == "")
    student_to_return = []
    if not all_students == "":
        all_students = all_students.split(',')
        if all_students is not None:
            for each_student_id in all_students:
                print(each_student_id+"\n")
                if(int(each_student_id) == -1):
                    continue
                student = Student.query.filter_by(id=each_student_id).first()
                current_student = {
                    "id": student.id, "name": student.name, "image": student.student_image}
                student_to_return.append(current_student)
    teacher = Teacher.query.filter_by(id=class_name.teacher).first()
    student_attendance = class_name.students_attendance

    to_return = {
        "id": class_name.id,
        "name": class_name.name,
        "teacher": teacher.id,
        "students-id": student_to_return,
        "students-attendance": student_attendance
    }

    return jsonify(to_return)


@views.route("/getClasses", methods=['GET'])
def get_classes():
    class_names = ClassName.query.all()
    to_return = []
    for each_class_name in class_names:
        result = {"id": each_class_name.id, "name": each_class_name.name,
                  "teacher_id": each_class_name.teacher, "students": each_class_name.students_id}
        to_return.append(result)
    return jsonify(
        to_return)


@views.route("/getClasses/<string:name>/<string:password>", methods=['GET'])
def get_classes_of_teacher(name, password):
    teacher = Teacher.query.filter_by(name=name, password=password).first()
    if teacher is None:
        return jsonify({"message": "could not found teacher "}), 404
    class_name = ClassName.query.filter_by(teacher=teacher.id).all()
    if class_name is None:
        return jsonify({"message": "could not found classes"}), 404
    class_name_data = []
    for each_class_name in class_name:
        to_append = {"id": each_class_name.id, "name": each_class_name.name, "teacher": each_class_name.teacher,
                     "students-id": each_class_name.students_id, 'students-attendance': each_class_name.students_attendance}
        class_name_data.append(to_append)

    to_return = Response(json.dumps(class_name_data),
                         mimetype='application/json')

    return to_return


@views.route("/createClass", methods=['POST'])
def create_class():
    data = request.get_json()
    rand_id = randrange(233567)
    if data is None:
        return jsonify({"message": "Please enter the teacher name and teacher password  and class name "}), 404
    else:
        if data.get('teacher-name') is None:
            return jsonify({"message": "Enter the teacher-name"}), 404
        if data.get("teacher-password") is None:
            return jsonify({"message": "Enter the teacher-password"}), 404

        name = data.get('teacher-name')
        password = data.get('teacher-password')
        print(name, password)
        teacher = Teacher.query.filter_by(name=name, password=password).first()
        if teacher is None:
            return jsonify({"message": "There is no teacher by this Name and password"}), 404
        old_class = ClassName.query.filter_by(id=rand_id).first()
        if old_class:
            return jsonify({"message": "There is class by this id"}), 404
        if data.get('class-name') is None:
            return jsonify({"message": "please enter class-name"}), 404

        new_class_name = ClassName(
            id=rand_id, name=data['class-name'], teacher=teacher.id, students_id="", students_attendance="")
        db.session.add(new_class_name)
        db.session.commit()

        to_return = {"id": new_class_name.id,
                     "name": new_class_name.name, "teacher": teacher.id, "students-id": new_class_name.students_id, "students-attendance": new_class_name.students_attendance}
        return jsonify(to_return)


@views.route("/updateClass/<int:id>", methods=['PUT'])
def update_class(id):
    data = request.get_json()
    if data is None:
        return jsonify({"message": "Please enter class name "}), 404
    else:
        class_name = ClassName.query.filter_by(id=id).first()
        if class_name is None:
            return jsonify({"message": "There is no class by this id"}), 404
        else:
            if data.get('name') is None:
                return jsonify({"message": "Please enter the class name"}), 404

            class_name.name = data.get('name')
            id = class_name.id
            db.session.commit()
            to_return = {"id": id, "name": data.get('name')}
            return jsonify({"Class updated to": to_return})


@views.route("/deleteClass/<int:id>", methods=['DELETE'])
def delete_class(id):

    class_name = ClassName.query.filter_by(id=id).first()
    if class_name is None:
        return jsonify({"message": "There is no class by this id"}), 404
    else:
        name = class_name.name
        id = class_name.id
        db.session.delete(class_name)
        db.session.commit()
        to_return = {"id": id, "name": name}
        return jsonify({"Class deleted": to_return})
