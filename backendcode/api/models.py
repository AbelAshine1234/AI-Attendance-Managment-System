from . import db




class ClassName(db.Model):

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100))
    teacher = db.Column(db.Integer, db.ForeignKey('teacher.id'))
    students_id = db.Column(db.String(10000))
    students_attendance = db.Column(db.String(1000))


class Teacher(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100))
    password = db.Column(db.String(100))


class Student(db.Model):

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100))
    student_image = db.Column(db.String(300))


class AttendanceSheet(db.Model):
    id = db.Column(db.String(1000), primary_key=True,unique=True)
    attendances = db.Column(db.String(10000))
    day = db.Column(db.String(100))
    image = db.Column(db.String(200))
    teacher_id = db.Column(db.Integer)
    class_name = db.Column(db.Integer)
