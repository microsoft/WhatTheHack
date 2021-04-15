# Challenge 1: Got Containers?

[< Previous Challenge](./00-prereqs.md) - **[Home](../README.md)** - [Next Challenge >](./02-acr.md)

## Introduction

The first step in our journey will be to take our application and package it as a container image using Docker.

## Description

In this challenge we'll be building and running the node.js based FabMedical app locally on our machines to see it working. Then we'll be creating Dockerfiles to build a container image of our app.

- Deploy build machine VM with Linux + Docker using provided ARM Template and parameters file in the "Files" tab of the Team's General channel. Run the Fab Medical application locally on the VM and verify access
	- **NOTE:** To ssh into the build machine using port 2266 on the VMs public IP:
    	- `ssh -p 2266 wthadmin@12.12.12.12` 
	- Each part of the app (api and web) runs independently.
	- Build the API app by navigating to the content-api folder and run `npm install`.
	- To start the app, run `node ./server.js &`
	- Verify the API app runs by hitting its URL with one of the three function names. Eg: **<http://localhost:3001/speakers>**
	- Repeat for the steps above for the content-web app, but verify it's available via a browser on the Internet!
	- **NOTE:** The content-web app expects an environment variable named `CONTENT_API_URL` that points to the API app's URL. 
- Create a Dockerfile for the content-api app that will:
	- Create a container based on the **node:8** container image
	- Build the Node application like you did above (Hint: npm install)
	- Exposes the needed port
	- Starts the node application
- Create a Dockerfile for the content-web app that will:
	- Do the same as the Dockerfile for the content-api
	- Also sets the environment variable value as above
- Build Docker images for both content-api and content-web
- Run both containers you just built and verify that it is working. 
	- **Hint:** Run the containers in 'detached' mode so that they run in the background.
	- **NOTE:** The containers need to run in the same network to talk to each other. 
		- Create a Docker network named "fabmedical"
		- Run each container using the "fabmedical" network
		- **Hint:** Each container you run needs to have a "name" on the fabmedical network and this is how you access it from other containers on that network.
		- **Hint:** You can run your containers in "detached" mode so that the running container does NOT block your command prompt.

## Success Criteria

1. You can run both the web and api parts of the FabMedical app locally on your machine
1. You have created 2 Dockerfiles files and created a container image for both web and api.
1. You can run the application locally from the containers just built.

## Learning Resources

Reference articles on how to Dockerize a Node.js app:
- <https://nodejs.org/en/docs/guides/nodejs-docker-webapp/>
- <https://buddy.works/guides/how-dockerize-node-application>
- <https://www.cuelogic.com/blog/why-and-how-to-containerize-modern-nodejs-applications>