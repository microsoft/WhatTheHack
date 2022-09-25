# Challenge 01 - Path A: Got Containers? - Coach's Guide 

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02A.md)

## Challenge 1, Path A

This is **PATH A**: Use this path if your students want to understand what's involved in creating a Docker container, and understand basic docker commands.  In this path, your students will create a Dockerfile, build and test local containers, and then push these container images to Azure Container Registry.

## Notes & Guidance

**NOTE:** Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack into a `Resources.zip` file. The coach should then provide a copy of the `Resources.zip` file to all students at the start of the hack.  The student guide refers to relative path locations within this zip package.

#### Tooling:
The students can either work with Docker locally on their workstation or they can deploy a build machine VM in Azure using the provided template.  There is no need to do both.  We recommend using the build VM deployed in Azure as this provides a known-to-work common environment.

  - The following bash & powershell scripts can be provided to students to deploy the Build VM in Azure. Advise students to use one or the other depending on their platform.
	```bash
	# Bash Script
	RG="akshack-RG"  #Change as appropriate
	LOCATION="EastUS"  # Change as appropriate
	az group create --name $RG --location $LOCATION
	az deployment group create --name buildvmdeployment -g $RG \
    	-f docker-build-machine-vm.json \
		-p docker-build-machine-vm.parameters.json
	```
	```Powershell
	# Powershell Script
	$RG="akshack-RG"  #Change as appropriate
	$LOCATION="EastUS"  # Change as appropriate
	az group create --name $RG --location $LOCATION
	az deployment group create --name buildvmdeployment -g $RG `
    	-f docker-build-machine-vm.json `
		-p docker-build-machine-vm.parameters.json
	```

  - Once the build VM is deployed, you can SSH into it on port 2266 on the public IP of the VM
	- **`ssh -p 2266 wthadmin@12.12.12.12`**

- Alternatively, if the student can use WSL v2, there should be no need for the Linux VM in Azure. All work can be performed locally in WSL 2 on Windows.  However, this will require the user to perform more setup steps on their workstation, including:
	- Install Docker Desktop in Windows
	- Copy the FabMedical code into their WSL environment.
      - Get the Fab Medical code from the Student Resources folder for Challenge 1
      - _NOTE: The FabMedical code files are pre-loaded onto the Linux VM created by the ARM template + script, so there is no need to copy them manually if the student is using the build VM_

#### Fab Medical Application:
One of the tasks in this challenge is, prior to building the docker images, is to run the application locally.  **In many cases, the coach may simply want to demonstrate this for the students rather than having them each do this individually.**  To run the Fab Medical application locally:
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
	- **NOTE:** Attendees should **not** struggle with getting the app to run locally.  If they are not familiar with Node.js, help them through this part.  Let them spend more time figuring out Docker later.

#### Dockerizing the Application
- It is up to you as coach to gauge how long attendees should spend creating their own Dockerfiles.  **Feel free to provide the sample Dockerfiles at an appropriate time.**  The sample dockerfiles for both content-api and content-web are in the `/Coach/Solutions` folder for Challenge 1. These files are also located in the `/Challenge-02` folder of the `Resources.zip` package the students have, but they shouldn't know that at this point unless you tell them.
	- The value of the env URL for content-web should match whatever value is used for the --name parameter when executing docker run on content-api as seen below.
- Build Docker images for both content-api & content-web. 
	- `docker build –t content-api .`
	- `docker build –t content-web .`
- Run the applications in the Docker containers in a network and verify access
	- Create a Docker network named **fabmedical**: 
		- `docker network create fabmedical`
	- Run each container using a name and using the **fabmedical** network. The containers should be run in "detached" mode so they don’t block the command prompt.
		- `docker run -d -p 3001:3001 --name api --net fabmedical content-api`
		- `docker run -d -p 3000:3000 --name web --net fabmedical content-web`
	- **NOTE:** The value specified in the `--name` parameter of the `docker run` command for content-api will be the DNS name for that container on the docker network.  Therefore, the value of the **CONTENT_API_URL** environment variable in the content-web Dockerfile should match it.
	- This is a good time for coaches to discuss the concept of a software defined network within the docker engine.  Explain how if there are more than one container listening on the same port, docker provides a network abstraction layer and the ability to map ports from the VM to ports on the container. For example, two containers listening on port 3001. Docker can map one to the VM’s port 3001 and the other to the VM’s port 3005.
- Be familiar with Docker commands and ready to help attendees who get stuck troubleshooting:
	- `docker ps `
		- lists all container processes running
	- `docker rm `
    	- removes/deletes an image
	- `docker kill `
    	- kills a container
	- `docker image list `
    	- lists all images on the machine
	- `docker image prune `
    	- kills all dangling images
- `sudo netstat -at | less` is useful to see what ports are running. This may help students with troubleshooting.



