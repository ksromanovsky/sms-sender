from flask import Flask
from config import Config
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager
from flask_wtf.csrf import CSRFProtect
import os
import logging

if os.path.exists('./log') != True:
    #raise FileExistsError
    os.system('mkdir ./log')

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)
formatter = logging.Formatter(u'[%(asctime)s]:[%(levelname)s]:[%(name)s]:[%(message)s]')
log_handler = logging.FileHandler('./log/main.log')
log_handler.setLevel(logging.INFO)
log_handler.setFormatter(formatter)
logger.addHandler(log_handler)

sms_sender = Flask(__name__)
sms_sender.config.from_object(Config)

db = SQLAlchemy(sms_sender)
login = LoginManager(sms_sender)
login.login_view = 'login'
csrf = CSRFProtect(sms_sender)

from sms_sender import routes, models

logger.warning('Program has started')