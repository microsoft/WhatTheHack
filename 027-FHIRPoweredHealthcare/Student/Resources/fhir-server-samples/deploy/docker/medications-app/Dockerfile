FROM node:10

RUN git clone https://github.com/smart-on-fhir/sample-apps-stu3

WORKDIR /sample-apps-stu3/medications

RUN npm install

COPY startup.sh .
RUN ["chmod", "+x", "startup.sh"]

EXPOSE 9090

CMD ["/bin/bash", "startup.sh"]