# Deploy Voting App

## Prerequisites

To complete this tutorial you will need:

1. [Git](https://git-scm.com/)
2. [Azure CLI](https://docs.microsoft.com/cli/azure/get-started-with-azure-cli) or use [Azure Cloudshell](https://docs.microsoft.com/en-us/azure/cloud-shell/quickstart)
3. [Docker for Mac](https://store.docker.com/editions/community/docker-ce-desktop-mac) or [Docker for Windows](https://store.docker.com/editions/community/docker-ce-desktop-windows) -- see [Docker.com](https://www.docker.com/) for other installs
4. [Docker Hub Account](https://hub.docker.com/) -- Free account for public image storage

This tutorial assumes you have an active Azure Subscription, otherwise a free trial can be used (or using the Free Tier of App Service).

If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/) before you begin.

You should already have this sample code downloaded but if not:

Clone this repo:

```bash
git clone git@github.com:alihhussain/WhatTheHack.git
```

Switch to the correct folder:

```bash
cd app
```

## Test and Run Container Locally

If you are new to Docker and containers, it would be helpful to review the following [Getting Started Guide](https://docs.docker.com/get-started/) on Docker.com. If you are new to containers in general, please also read [What is a Container?](https://www.docker.com/what-container) on Docker.com.

Now lets build the docker image. To do so you will need a Docker Hub account (linked above in the prereqs) and a public repository.

From the `app` folder, run the following command replacing `<DockerHubUsername>` with your Docker Hub user name. 

```
docker build -t <DockerHubUsername>/<AppName> .
```

For instance:

```
docker build -t="alihhussain/voting-app:v1" .
```

Let's review what happened:
- `docker` - the Docker daemon/engine that runs, manages, and creates Docker images
- `build` - the build command tells Docker to get ready to build a Docker image based on a Dockerfile.
- `-t` - we need to tag our image with our user name so that we push to Docker Hub it is accept correctly
- `<DockerHubUsername>/voting-app` - the name of our Docker Hub account and the name of the app (e.g. voting-app) we want to name it.
- `.` - the dot is used to mean "current directory", in this case it provides the build command reference to find the Dockerfile.

Once build finishes, you can view local images using the following command:

```
docker images
```

Output should look like:

```
REPOSITORY              TAG                 IMAGE ID            CREATED             SIZE
alihhussain/votingapp   v1                  60c341b2af89        39 seconds ago      89.3MB
```

Test the application functions locally using the following Docker command:

```
docker run -p 80:80 alihhussain/voting-app:v1
```

That command maps the exposed port of 80 from within the container to the host's port of 80. Now you can see it at
- [http://localhost](http://localhost)

You can exit the container with `CTRL+C`.

Now that we have tested our application locally, let's push this to the Docker Hub so that Web App for Containers will receive it.

To do so you will have to login within your Docker environment and enter your username and password, to do so run the following command:

```
docker login
```

Lets now push the image up to DockerHub

```
docker push <DockerHubUsername>/voting-app:v1
```

It will look something like this:
```
docker push alihhussain/voting-app:v1
```

The image we pushed is public and now downloadable via Docker Hub to any machine or server. In a production scenario, you would have a private container registry like [Azure Container Registry](https://azure.microsoft.com/en-us/services/container-registry/). You can find details [here](https://docs.microsoft.com/en-us/azure/app-service/containers/app-service-linux-cli#using-docker-images-from-a-private-registry).
