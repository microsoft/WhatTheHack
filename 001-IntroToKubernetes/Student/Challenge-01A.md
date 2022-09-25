# Challenge 01 - Path A: Got Containers?

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02A.md)

## Introduction

The first step in our journey will be to take our application and package it as a container image using Docker.

## Description

To help ensure everyone can start this hack on the same page and avoid the complexities of installing and setting up Docker, we have provided you with an ARM Template that will deploy a Linux VM into Azure. Once deployed, the Linux VM will have the FabMedical application's source code and all of the Docker & Node.js tools pre-installed.

You will use the Linux VM during this challenge to perform several tasks to prepare the application for containerization and eventual deployment into Kubernetes, including:
- Build and run the Node.js-based FabMedical application locally on the VM to observe how it works
- Create a set of Dockerfiles to build container images of the application
- Run the containerized application on the VM to observe how it works in the Docker environment

### Deploy an Azure Linux VM "Build Machine"

Deploy an Azure VM using the provided ARM Template and parameters file in the `/Challenge-01/build-machine` folder of the `Resources.zip` file provided to you by your coach.
- The template file is named: `docker-build-machine-vm.json`
- The parameters file is named: `docker-build-machine-vm.parameters.json`

This is a three step process which any Azure professional should be familiar with.  We will list these steps below in case you are new to Azure.

**NOTE:** If you are using [Azure Cloud Shell](https://shell.azure.com) to run this hack, you will need to upload the `Resources.zip` file provided by your coach into the Cloud Shell.  Unpack the `Resources.zip` file there first, and then proceed with the instructions below.

1. Log into your Azure Subscription with the Azure CLI: 
    ```
    az login
    ```
1. Create a new Resource Group: 
    ```
    az group create --name <resource-group-name> --location <azure-region>
    ```

    - If using a shared Azure subscription, we recommend you use the a combination of your initials and "rg" for the `<resource-group-name>` value. For example: `peterlaudati-rg`
    - The `<azure-region>` value must be one of the pre-defined Azure Region names. You can view the list of available region names by running the following command: `az account list-locations -o table`
1. Deploy the template by running the following Azure CLI command from wherever you have unpacked the `/Challenge-01/build-machine` folder:
    ```
    az deployment group create -g <resource-group-name> -n LinuxBuildVM -f docker-build-machine-vm.json -p docker-build-machine-vm.parameters.json
    ```
    - The template deployment will ask you to provide an admin password for the VM. The 12-character password must meet 3 out of 4 of these criteria:
        - Have lower characters
        - Have upper characters
        - Have a digit
        - Have a special character 

When the deployment is complete, you can ssh into the build machine using port 2266 on the VMs public IP:
- `ssh -p 2266 wthadmin@<VM Public IP>` 
- Verify that Docker and Azure CLI are installed on the VM.

### Build & Run the FabMedical Application

- Run the Node.js application
	- Each part of the app (api and web) runs independently.
	- Build the API app by navigating to the `/content-api` folder and run `npm install`.
	- To start the app, run `node ./server.js &`
	- Verify the API app runs by hitting its URL with one of the three function names. Eg: **<http://localhost:3001/speakers>**
- Repeat for the steps above for the content-web app which is located in the `/content-web` folder, but verify it's available via a browser on the Internet!
	- **NOTE:** The content-web app expects an environment variable named `CONTENT_API_URL` that points to the API app's URL. 

### Create Dockerfiles to Containerize the FabMedical Application

- Create a Dockerfile for the content-api app that will:
	- Create a container based on the **node:8** container image
	- Build the Node application like you did above (Hint: npm install)
	- Exposes the needed port
	- Starts the node application

- Create a Dockerfile for the content-web app that will:
	- Do the same as the Dockerfile for the content-api
	- Also sets the environment variable value as above

- Build Docker images for both content-api and content-web

### Run the Containerized FabMedical Application with Docker

- Run both containers you just built and verify that it is working. 
	- **Hint:** Run the containers in 'detached' mode so that they run in the background.
	- **NOTE:** The containers need to run in the same network to talk to each other. 
		- Create a Docker network named "fabmedical"
		- Run each container using the "fabmedical" network
		- **Hint:** Each container you run needs to have a "name" on the fabmedical network and this is how you access it from other containers on that network.
		- **Hint:** You can run your containers in "detached" mode so that the running container does NOT block your command prompt.


## Success Criteria

1. Verify that you can run both the Node.js based web and api parts of the FabMedical app on the VM
2. Verify that you have created 2 Dockerfiles files and created a container image for both web and api.
3. Verify that you can run the application using containers.

## Learning Resources

- [Dockerizing a Node.js web app](https://nodejs.org/en/docs/guides/nodejs-docker-webapp/)
- [How to Dockerize a Node.js application](https://buddy.works/guides/how-dockerize-node-application)
- [Why and How To Containerize Modern Node.js Applications](https://www.cuelogic.com/blog/why-and-how-to-containerize-modern-nodejs-applications)
