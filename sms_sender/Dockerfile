FROM python:latest
RUN mkdir -p /usr/src/sms_sender
WORKDIR /usr/src/sms_sender
COPY . /usr/src/sms_sender/
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
CMD ["uwsgi", "./uwsgi/sms_sender.ini"]