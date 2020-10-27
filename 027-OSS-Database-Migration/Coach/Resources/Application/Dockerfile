FROM ubuntu:18.04
RUN apt-get update
RUN apt-get -y install nodejs npm openjdk-8-jdk 
RUN apt-get -y purge openjdk-11-jre-headless 
RUN mkdir -p /home/pedrorod/pizzeria
WORKDIR /home/pedrorod/pizzeria
COPY . /home/pedrorod/pizzeria
EXPOSE 8081
ENTRYPOINT ["java","-jar","webapp/target/dependency/webapp-runner.jar","--port","8081","--path","pizzeria","webapp/target/webapp-0.0.1-SNAPSHOT.war"]
#ENTRYPOINT ["sleep","100000"]
# Command to build and push the new Docker image to the remote repository
# docker build . -f Debugger-Dockerfile -t izzyacademy/ubuntu-pizza:18.04
# docker push izzyacademy/ubuntu-pizza:18.04
# docker run --name debugger -it izzyacademy/ubuntu-pizza:18.04
