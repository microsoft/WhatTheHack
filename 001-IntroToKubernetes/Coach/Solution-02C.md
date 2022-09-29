# Challenge 02 - Path C: The Azure Container Registry - Coach's Guide 

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Challenge 1 & 2 Path C

This is **PATH C**: Use this path if your students understand docker, don't care about building images , and/or have environments issues that would prevent them from building containers locally. In this path, your students will will create an Azure Container Registry, and then will import the images to their ACR.

## Notes & Guidance

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


#### Importing the Application
If the students get stuck, point them to the ACR documentation:

- https://docs.microsoft.com/en-us/azure/container-registry/container-registry-import-images

### Other tips / tricks

- To create the registry from the CLI, use: 
    - `az acr create -n <name of registry> -g <resource group> --sku Standard`
- To login to the ACR, use: 
    - `az acr login --name <name of ACR>`
- To list images in the repository, use:
    - `az acr repository list --name <name of ACR>`
