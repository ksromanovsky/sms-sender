import os
import binascii
from datetime import timedelta
from dotenv import load_dotenv

load_dotenv()
DB_SERVER = os.getenv('MYSQL_SERVER')
DB_USER = os.getenv('MYSQL_USER')
DB_PASSWORD = os.getenv('MYSQL_PASSWORD')
DB_NAME = os.getenv('MYSQL_DATABASE')

class Config(object):
    SECRET_KEY = binascii.hexlify(os.urandom(32))
    SQLALCHEMY_DATABASE_URI = 'mysql://' + DB_USER + ':' + DB_PASSWORD + '@' + DB_SERVER + ':3306/' + DB_NAME
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    PERMANENT_SESSION_LIFETIME = timedelta(minutes=15)

print(Config.SQLALCHEMY_DATABASE_URI)