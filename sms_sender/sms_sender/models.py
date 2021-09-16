from sms_sender import db, login
from werkzeug.security import check_password_hash
from flask_login import UserMixin

class Admins(UserMixin, db.Model):
    __tablename__ = 'admins'
    adm_id = db.Column(db.Integer, primary_key=True)
    adm_login = db.Column(db.String(11))
    adm_pwd = db.Column(db.String(40))

    def check_pwd(self, password):
        return check_password_hash('md5$$' + self.adm_pwd, password)

    @property
    def id(self):
        return self.adm_id

class Users(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    status = db.Column(db.Integer)
    fullname = db.Column(db.String(100))
    balance = db.Column(db.Float)
    phone1 = db.Column(db.String(20))
    phone2 = db.Column(db.String(20))
    phone3 = db.Column(db.String(20))
    objid = db.Column(db.Integer, db.ForeignKey('objects.id'))

class Objects(db.Model):
    __tablename__ = 'objects'
    id = db.Column(db.Integer, primary_key=True)
    street = db.Column(db.Integer, db.ForeignKey('objects_streets.id'))
    dom = db.Column(db.String(5))
    korp = db.Column(db.String(5))

class Streets(db.Model):
    __tablename__ = 'objects_streets'
    id = db.Column(db.Integer, primary_key=True)
    city = db.Column(db.Integer, db.ForeignKey('objects_city.id'))
    street = db.Column(db.String(255))
    streettype = db.Column(db.Integer)

class Citys(db.Model):
    __tablename__ = 'objects_city'
    id =db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50))

class Statuses(db.Model):
    __tablename__ = 'users_active_status'
    id = db.Column(db.Integer, primary_key=True)
    description = db.Column(db.String(255))

class Services(db.Model):
    __tablename__ = 'services'
    id = db.Column(db.String(20), primary_key=True)
    name = db.Column(db.String(50))

class User_services(db.Model):
    __tablename__ = 'users_services'
    id = db.Column(db.Integer, primary_key=True)
    uid = db.Column(db.Integer, db.ForeignKey('users.id'))
    service = db.Column(db.String(20), db.ForeignKey('services.id'))
    date_end = db.Column(db.Date())

@login.user_loader
def load_user(id):
    return Admins.query.get(int(id))
