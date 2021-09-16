import os
import requests
from sms_sender import logger
from dotenv import load_dotenv

load_dotenv()
SMS_USER = os.getenv('SMS_USERNAME')
SMS_PASSWORD = os.getenv('SMS_USERPASSWORD')

def sender(user):
    results = dict()
    message1 = 'Уважаемый абонент. У Вас долг за %s:%s. Тел:000-00-00' % (user['service'], user['balance'])
    message2 = 'Уважаемый абонент. Баланс на счете за %s:%s. Тел:000-00-00' % (user['service'], user['balance'])
    message = message1 if user['balance'] < 0 else message2
    for phone in user['phones']:
        r = requests.get('https://gateway.api.sc/get/', params={'user': SMS_USER, 'pwd': SMS_PASSWORD, 'sadr': 'LLC', 'dadr': phone, 'text': message})
        rst = requests.get('https://gateway.api.sc/get/', params={'user': SMS_USER, 'pwd': SMS_PASSWORD, 'smsid': r.text})
        logger.warning(u'Message was send to [%s] [%s]. Status %s' % (user['id'], phone, rst.text))
        results[phone] = rst.text
    return results
