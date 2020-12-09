

## How to Build the Docker Image

### Compile the Java and Node.js Application as follows

```shell

# Navigate to the application folder
cd 027-OSS-Database-Migration/Coach/Resources/Application

mvn clean package -DskipTests

```

### Log into Docker Hub with your Credentials

This is how to login to Docker Hub. You first logout from any exisiting sessions and then log in with your credentials

```shell

docker logout

docker login

```


### Build the Docker and Push the Docker Image

Once you are logged in your can build and tag the image as follows. izzymsft is the username of the Dockerhub account used for this exercise

```shell

docker build . -t izzymsft/ubuntu-pizza:1.0

docker push izzymsft/ubuntu-pizza:1.0

```