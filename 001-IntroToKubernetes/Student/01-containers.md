# Challenge 1: Got Containers?

[< Previous Challenge](./00-prereqs.md) - **[Home](../README.md)** - [Next Challenge >](./02-acr.md)

## Introduction

The first step in our journey will be to take our application and package it as a container image using Docker.

## Demo
Your coach will demonstrate running the application natively without using containers.

## Description

In this challenge we'll use a Dockerfiles to build container images of our app, and we'll test them locally.

Choice:  you can choose to build the docker images locally on your workstation, or you can deploy a linux VM in Azure to act as your build server.

### Deploying and Access a Linux VM Build Server
If you choose to use a VM in Azure, deploy the build machine VM with Linux + Docker using the provided ARM Template and parameters file in the "Student/Resources/Chapter 1/build-machine" folder of this repo.  You can run the following script:
```
RG="akshack-RG" 
LOCATION="EastUS"  # Change as appropriate
az group create --name $RG --location $LOCATION
az deployment group create --name buildvmdeployment -g $RG \
    -f docker-build-machine-vm.json \
	-p docker-build-machine-vm.parameters.json
```
You will then need to ssh into the machine (which is using port 2266):

`ssh -p 2266 wthadmin@12.12.12.12 # replace 12.12.12.12 with the public IP of the vm`

(Alternatively, you can use the VSCode Remote Shell extension to remotely access the VM)

### Building the Docker Image
Our Fab Medical App consists of two components, a web component and an api component.  Your task is to build containers for each of these.  You have been provided source code (no need to edit) and a Docker file for each.

### Success Criteria
- Build Docker images for both `content-api` and `content-web`
- Run both containers you just built and verify that the app is working. 
	- **Hint:** Run the containers in 'detached' mode so that they run in the background.
	- The content-web app expects an environment variable named `CONTENT_API_URL` that points to the API app's URL.
	- **NOTE:** The containers need to run in the same network to talk to each other. 
		- Create a Docker network named "fabmedical"
		- Run each container using the "fabmedical" network
		- **Hint:** Each container you run needs to have a "name" on the fabmedical network and this is how you access it from other containers on that network.
		- **Hint:** You can run your containers in "detached" mode so that the running container does NOT block your command prompt.



## Learning Resources

See Docker documentation:  https://docs.docker.com/get-started/07_multi_container/