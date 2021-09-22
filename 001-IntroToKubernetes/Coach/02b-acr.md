# Challenge 1b & 2b: Coach's Guide

[< Previous Challenge](01-containers.md) - **[Home](README.md)** - [Next Challenge >](03-k8sintro.md)

## Challenge 1 & 2 Path B

This is **PATH B**: Use this path if your students understand docker, don't care about building images locally, and/or have environments issues that would prevent them from building containers locally. In this path, your students will be given a Dockerfile, will create an Azure Container Registry, and then will use ACR tasks to build the images natively inside ACR.

### Coach Notes:
#### Tooling:
The students will need to be able to run the Azure cli.  Ideally this would be run from their local workstation, but it could also be the Azure Cloud Shell.

#### Fab Medical Application:
The coach should demonstrate running the application locally.  To run the Fab Medical application locally:
- Each part of the app (api & web) runs independently.
- Build the API app by navigating to the content-api folder and run:
   	- `npm install`
- To start a node app, run:
       - `node ./server.js &`
- Verify the API app runs by browsing to its URL with one of the three function names, eg: 
   	- `http://localhost:3001/speakers`
- Repeat for the steps above for the Web app.
	- **NOTE:** The content-web app expects an environment variable named `CONTENT_API_URL` that points to the API app’s URL.
	- The environment variable value should be `http://localhost:3001`
	- **NOTE:** `localhost` only works when both apps are run locally using Node. You will need a different value for the environment variable when running in Docker.
	- **NOTE:** The node processes for both content-api and content-web must be stopped before attempting to run the docker containers in the next step. To do this, use the Linux `ps` command to list all processes running, and then the Linux `kill` command to kill the two Node.js processes.


#### Dockerizing the Application
- You will need to provide the sample Dockerfiles to the students  The sample dockerfiles for both content-api and content-web are in the Coach Solutions folder for Challenge 1.  They will use these Dockerfiles in conjunction with the source code for content-web and content-api.

If the students get stuck, point them to the ACR documentation for building a container image in Azure:

- https://docs.microsoft.com/en-us/azure/container-registry/container-registry-quickstart-task-cli
- https://docs.microsoft.com/en-us/azure/container-registry/container-registry-tutorial-quick-task

### Other tips / tricks

- To create the registry from the CLI, use: 
    - `az acr create -n <name of registry> -g <resource group> --sku Standard`
- To login to the ACR, use: 
    - `az acr login --name <name of ACR>`
- To list images in the repository, use:
    - `az acr repository list --name <name of ACR>`


