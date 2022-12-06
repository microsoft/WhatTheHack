# Challenge 14 - Running Containers

[< Previous Challenge](./Challenge-13.md) - **[Home](../README.md)**

## Description

Containers are executable units of software in which application code is packaged, along with its libraries and dependencies, in common ways so that it can be run anywhere, whether it be on desktop, traditional IT, or the cloud.

To do this, containers take advantage of a form of operating system (OS) virtualization in which features of the OS (in the case of the Linux kernel, namely the namespaces and cgroups primitives) are leveraged to both isolate processes and control the amount of CPU, memory, and disk that those processes have access to.

Containers are small, fast, and portable because unlike a virtual machine, containers do not need include a guest OS in every instance and can, instead, simply leverage the features and resources of the host OS.

Containers first appeared decades ago with versions like FreeBSD Jails and AIX Workload Partitions, but most modern developers remember 2013 as the start of the modern container era with the introduction of [Docker](https://www.docker.com/).

Docker is a platform for developing, shipping, and running applications. Let’s unpack that statement. Docker allows users to build new container images, push those images to Docker Hub, and also download those images from the Docker Hub. Docker Hub acts as a container image library, and it hosts container images that users build. There are also some new alternatives to Docker such as [Podman](https://podman.io/).

Podman is a daemonless container engine for developing, managing, and running OCI Containers (Open Containers Initiative) on your Linux System. Contrary to Docker, Podman does not require a daemon process to launch and manage containers. This is an important difference between the two projects.

Podman seeks to improve on some of Docker’s drawbacks. For one, Podman does not require a daemon running as root. In fact, Podman containers run with the same permissions as the user who launched them. This addresses a significant security concern, although you can still run containers with root permissions if you really want to.

Podman seeks to be a drop-in replacement for Docker as far as the CLI is concerned. The developers boast that most users can simply use alias docker=podman and continue running the same familiar commands. The container image format is also fully compatible between Docker and Podman, so existing containers built on Dockerfiles will work with Podman.

Another key difference is that, unlike Docker, Podman is not able to build container images (the tool [Buildah](https://buildah.io/) is instead used for this). This shows that Podman is not built to be monolithic.

It handles running containers (among some other things) but not building them. The goal here is to have a set of container standards that any application can be developed to support, rather than relying on a single monolithic application such as Docker to perform all duties.

This challenge will let you have your first contact with containers. You will: 

- Install the docker runtime
- Run a Nginx container
- Access the default website in your virtual machine

If you would like to go over an advanced challenge, try this one:

- Download this sample application [from here](/Student/resources/simple-php-app.tar.gz) to your home directory
- Create a Dockerfile to install the Nginx, PHP, and run this php application.
- Build the image
- Test the execution of the container
- Publish the image to Docker Hub

## Success Criteria

1. Make sure that Docker runtime was successfully installed
2. Ensure your Nginx container is running properly
3. Access the default website from Nginx through the public IP of your virtual machine

If you decided to take the advanced challenge:

1. Ensure the sample application was downloaded into the virtual machine
6. Have the application running via container and accessible from the browser
7. Validate that the container image were published into Docker Hub

## Learning resoures

- [What is a container?](https://azure.microsoft.com/en-us/resources/cloud-computing-dictionary/what-is-a-container/)
- [Introduction to Containers and Docker](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/container-docker-introduction)
- [A beginner’s guide to Docker — how to create your first Docker application](https://www.freecodecamp.org/news/a-beginners-guide-to-docker-how-to-create-your-first-docker-application-cc03de9b639f/)
