from threading import main_thread
from face_recognition.api import face_locations
from flask import Blueprint, request, jsonify,send_file
from flask.helpers import make_response
from werkzeug.exceptions import MethodNotAllowed
from werkzeug.utils import secure_filename, send_file, send_from_directory
from werkzeug.wrappers import response
from .models import ClassName, Student, Teacher
from . import db
import os,json
import face_recognition
from random import randrange
from PIL import Image
import io
import base64
import cv2


register = Blueprint('register', __name__)


@register.route("/registerStudent", methods=['POST'])
def register_student():
    from .views import create_student
    return create_student()


@register.route("/addStudent/<int:class_id>", methods=['POST'])
def add_student_to_class(class_id):
    class_name = ClassName.query.filter_by(id=class_id).first()
    print("classname")
    if not class_name:
        return jsonify({"message": "Class Not Found"}), 404
    data = request.get_json()
    if data is None:
        return jsonify({"message": "Please enter id of the student"}), 404
    if data.get('student-id') is None:
        return jsonify({"message": "Please enter  student-id"}), 404
    student = Student.query.filter_by(id=data.get('student-id')).first()
    if not student:
        return jsonify({"message": "There is no student by this id"}), 404
    # Getting value of this student

    current_student = {"id": student.id, "name": student.name}
    current_class = {"id": class_name.id, "name": class_name.name}

    all_students_id = class_name.students_id
    all_students_id_splitted = all_students_id.split(',')
    print(len(all_students_id_splitted))

    # If the class have only one student converting to int will cause error so we add -1
    if len(all_students_id_splitted) == 1:
        class_name.students_id = str(current_student['id'])+","+"-1"
        db.session.commit()
        return jsonify({"message": f"Student {current_student['name']} has been registerd to class{current_class['name']}"}), 404

    for each_student_id in all_students_id_splitted:
        if(int(each_student_id) == current_student['id']):
            return jsonify({"message": f"Student {current_student['name']} has already been registered"}), 404
    class_name.students_id = all_students_id+','+str(current_student["id"])
    db.session.commit()
    return jsonify({"message": f"Student {current_student['name']} has been registerd to class{current_class['name']}"})


@register.route("/addImage/<int:id>", methods=['PUT'])
def add_image_student(id):
    print("started")
    student = Student.query.filter_by(id=id).first()
    if student is None:
        print("no student")
        return jsonify({"message": "There is no student by this id"}),404
    if 'file' not in request.files:
        print("no file")
        return jsonify({"message": "Enter the image of the student"}),404

    image = request.files['file']
    student_info = {"id": student.id, "name": student.name}
    # TODO BEFORE SAVING AN IMAGE CHECK IF THERE IS A FACE LOCATION IF THERE IS MORE THAN ONE LOCATION OR THERE IS NO FACE LOCATION RETURN ERROR
    image.save(os.path.join('./api/resources/student_image/',
               str(student_info['id'])+".jpg"))

    image_directory = os.path.join(
        './api/resources/student_image/', str(student_info['id'])+".jpg")
    image_of_student = face_recognition.load_image_file(image_directory)
    student_image_face_location = face_recognition.face_locations(
        image_of_student)
    if (student_image_face_location == []):
        return jsonify({"message": "Enter the picture of the student this one does not look like human face"}),404

    student.student_image = image_directory
    db.session.commit()
    return jsonify({"message": "Image saved"})

@register.route("/displayImage/<int:sid>",methods=['GET'])
def return_an_image_of_student(sid):
    student = Student.query.filter_by(id=sid).first()
    if not student:
        return jsonify({"message": "There is no student by this id"}), 404
    directory = str(sid)
    
    image = Image.open(f"/home/abel/Lab/Year4/project/backend/api/resources/student_image/{directory}.jpg",mode='r')
    if not image:
        return jsonify({"message ":"Image not found"}),
    imagename = f"/home/abel/Lab/Year4/project/backend/api/resources/student_image/{directory}.jpg"
    img = cv2.imread(imagename)
   
    return send_file(
        imagename,
        environ=request.environ
        )


