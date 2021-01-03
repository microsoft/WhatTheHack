FROM node:10

RUN git clone https://github.com/smart-on-fhir/growth-chart-app

WORKDIR /growth-chart-app

RUN npm install

COPY startup.sh .
RUN ["chmod", "+x", "startup.sh"]

EXPOSE 9000

CMD ["/bin/bash", "startup.sh"]