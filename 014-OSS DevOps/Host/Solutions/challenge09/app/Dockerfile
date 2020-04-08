FROM python:alpine3.8

COPY . /var/server

ADD requirements.txt /tmp/requirements.txt

RUN pip install -r /tmp/requirements.txt

ADD app.py /var/server/app.py
ADD config_file.cfg /var/server/config_file.cfg

EXPOSE 5000

CMD python /var/server/app.py
