FROM node:carbon

COPY . /home/

RUN cd /home/ \
    && npm install

WORKDIR /home/

ENTRYPOINT npm start
