from flask import Flask
from flask_sqlalchemy import SQLAlchemy


db = SQLAlchemy()


def create_app():
    app = Flask(__name__)
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///database.db'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS']=False
    app.config['UPLOAD_FOLDER']='.'
    app.config['CORS_HEADERS'] = 'Content-Type'
    app.config['TESTING'] = True
    db.init_app(app)
    from .views import views
    from .register import register
    from .attendance import attendance
   
    app.register_blueprint(views)
    app.register_blueprint(register, url_prefix='/register')
    app.register_blueprint(attendance, url_prefix='/attend')
    return app
