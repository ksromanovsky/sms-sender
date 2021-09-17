# -*- coding: utf-8 -*-
from flask import render_template, redirect, url_for, request, jsonify
from werkzeug.urls import url_parse
from sms_sender import sms_sender, logger
from flask_login import current_user, login_user, logout_user, login_required
from sms_sender.models import Admins, Users, Objects, Streets, Citys, Statuses, Services, User_services
from sms_sender.sender import sender
import re

@sms_sender.route('/')
@login_required
def index():
    return render_template('index.html')

@sms_sender.route('/login', methods=['GET'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('index'))
    return render_template('login.html')

@sms_sender.route('/api/getlogin', methods=['POST'])
def get_login():
    login_form_data = request.form.to_dict()
    if login_form_data['login-form-login'] != '' and login_form_data['login-form-password'] != '':
        adm = Admins.query.filter_by(adm_login=login_form_data['login-form-login']).first()
        if adm is None or not adm.check_pwd(login_form_data['login-form-password']):
            return url_for('login')
        login_user(adm)
        logger.info(u'User %s has just logged in from %s' % (Admins.query.get(current_user.id).adm_login, request.remote_addr))
        return url_for('index')
    else:
        return url_for('login')

@sms_sender.route('/logout')
def logout():
    logger.info(u'User %s has just logged out from %s' % (Admins.query.get(current_user.id).adm_login, request.remote_addr))
    logout_user()
    return redirect(url_for('login'))

@sms_sender.route('/search', methods=['GET', 'POST'])
@login_required
def search():
    logger.info(u'User %s has access to the search page from %s' % (Admins.query.get(current_user.id).adm_login, request.remote_addr))
    return render_template('search.html')

@sms_sender.route('/api/getaddresses', methods=['GET'])
@login_required
def api_get_addresses():
    addr_list = dict()
    for c in Citys.query.all():
        addr_list.update({c.name: dict()})
        for s in Streets.query.filter_by(city=c.id).all():
            addr_list[c.name].update({s.street: list()})
            for h in Objects.query.filter_by(street=s.id).all():
                addr_list[c.name][s.street].append(h.dom)
    return jsonify(addr_list)

@sms_sender.route('/api/getstatuses', methods=['GET'])
@login_required
def api_get_statuses():
    statuses = dict()
    for s in Statuses.query.all():
        statuses.update({s.id: s.description})
    return jsonify(statuses)

@sms_sender.route('/api/getservices', methods=['GET'])
@login_required
def api_get_services():
    services = dict()
    for s in Services.query.all():
        services.update({s.id: s.name})
    return jsonify(services)

@sms_sender.route('/api/getusers', methods=['POST'])
@login_required
def api_get_users():
    results = dict()
    users_list_temp = list()
    users_list = list()
    form_data = request.form.to_dict()
    logger.info(u'User %s has request information from database from %s' % (Admins.query.get(current_user.id).adm_login, request.remote_addr))
    
    jc = form_data['jcity']
    jstr = form_data['jstreet']
    jh = form_data['jhouse']
    jb = int(form_data['jbalance'])
    jse = form_data['jservice']
    je = form_data['jequal']
    jsta = form_data['jstatus']

    logger.info(u'The requested information was from %s, %s, %s' % (jc, jstr, jh))
    
    if jc != '':
        if jstr != '':
            if jh != '':
                users_list_temp = Users.query.filter(Users.objid==Objects.query.filter_by(street=Streets.query.filter_by(city=Citys.query.filter_by(name=jc).first().id, street=jstr).first().id, dom=jh).first().id, Users.status==1).all()
            else:
                for obj in Objects.query.filter_by(street=Streets.query.filter_by(city=Citys.query.filter_by(name=jc).first().id, street=jstr).first().id).all():
                    users_list_temp.extend(Users.query.filter(Users.objid==obj.id, Users.status==1).all())
        else:
            for street in Streets.query.filter_by(city=Citys.query.filter_by(name=jc).first().id).all():
                for obj in Objects.query.filter_by(street=street.id).all():
                    users_list_temp.extend(Users.query.filter(Users.objid==obj.id, Users.status==1).all())
    else:
        users_list_temp = Users.query.filter(Users.status==1).all()
    
    for u in users_list_temp:
        if jse != '':
            if jb != '':
                if je == '1':
                    for s in User_services.query.filter(User_services.uid == u.id, User_services.date_end == '2999-12-31 23:59:59').all():
                        if (Services.query.filter(Services.id == s.service).first().name == jse) & (u.balance <= jb):
                            users_list.append(u)
                elif je == '2':
                    for s in User_services.query.filter(User_services.uid == u.id, User_services.date_end == '2999-12-31 23:59:59').all():
                        if (Services.query.filter(Services.id == s.service).first().name == jse) & (u.balance == jb):
                            users_list.append(u)
                elif je == '3':
                    for s in User_services.query.filter(User_services.uid == u.id, User_services.date_end == '2999-12-31 23:59:59').all():
                        if (Services.query.filter(Services.id == s.service).first().name == jse) & (u.balance >= jb):
                            users_list.append(u)
            else:
                for s in User_services.query.filter(User_services.uid == u.id, User_services.date_end == '2999-12-31 23:59:59').all():
                    if Services.query.filter(Services.id == s.service).first().name == jse:
                        users_list.append(u)
        else:
            if jb != '':
                if je == '1':
                    if u.balance <= jb:
                        users_list.append(u)
                elif je == '2':
                    if u.balance == jb:
                        users_list.append(u)
                elif je == '3':
                    if u.balance >= jb:
                        users_list.append(u)
            else:
                users_list.append(u)

    for u in users_list:
        us = list()
        for s in User_services.query.filter(User_services.uid == u.id, User_services.date_end == '2999-12-31 23:59:59').all():
            us.append(Services.query.filter(Services.id == s.service).first().name)
        results.update({u.id: {'1services': us, '2fullname': u.fullname, '3phones': [u.phone1, u.phone2, u.phone3], '4balance': int(u.balance)}})
    return jsonify(results)

@sms_sender.route('/api/sendmsg', methods=['POST'])
@login_required
def api_send_msg():
    request_dict = request.form.to_dict()
    response_dict = dict()
    
    h = Objects.query.get(Users.query.get(request_dict['0']).objid).dom
    s = Streets.query.get(Objects.query.get(Users.query.get(request_dict['0']).objid).street).street
    c = Citys.query.get(Streets.query.get(Objects.query.get(Users.query.get(request_dict['0']).objid).street).city).name

    logger.warning(u'User %s has sended messages to %s, %s, %s from %s' % (current_user.adm_login, c, s, h, request.remote_addr))
    for i in request_dict:
        phones_list = []
        u = Users.query.get(request_dict[i])
        if re.match(r'[+]?[8|7]?[-\.\s\(]?[\d]{3}[-\.\s\)]?[\d]{3}[-\.\s]?[\d]{2}[-\.\s]?[\d]{2}',u.phone1):
            phones_list.append('+7' + re.sub('^[+]?[7]?[8]?', '', re.sub('[\(\)\-\s\.]', '', u.phone1)))
        if re.match(r'[+]?[8|7]?[-\.\s\(]?[\d]{3}[-\.\s\)]?[\d]{3}[-\.\s]?[\d]{2}[-\.\s]?[\d]{2}',u.phone2):
            phones_list.append('+7' + re.sub('^[+]?[7]?[8]?', '', re.sub('[\(\)\-\s\.]', '', u.phone2)))
        if re.match(r'[+]?[8|7]?[-\.\s\(]?[\d]{3}[-\.\s\)]?[\d]{3}[-\.\s]?[\d]{2}[-\.\s]?[\d]{2}',u.phone3):
            phones_list.append('+7' + re.sub('^[+]?[7]?[8]?', '', re.sub('[\(\)\-\s\.]', '', u.phone3)))
        if phones_list:
            serv = 'Объединенный' if len(User_services.query.filter_by(uid=u.id).all()) > 1 else Services.query.get(User_services.query.filter_by(uid=u.id).first().service).name
            response_dict.update({u.id: sender({'id': u.id, 'service': serv, 'phones': phones_list, 'balance': int(u.balance)})})
        else:
            logger.warning(u'Message was not sended to [%s], no mobile phones' % (u.id, ))
            response_dict.update({u.id: {'': 'Нет подходящих номеров.'}})
    return jsonify(response_dict)
