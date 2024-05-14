# Challenge 07 - Updates and Rollbacks - Coach's Guide 

[< Previous Solution](./Solution-06.md) - **[Home](./README.md)** - [Next Solution >](./Solution-08.md)

## Notes & Guidance

- To verify that the MongoDB contains the FabMedical data after the content-init job has completed:
	- Connect to the pod running mongodb with the exec command: 
		- `kubectl exec -it <mongodbpodname> -- /bin/bash`
	- Connect to mongodb by running: 
		- `mongosh`
	- Check for the existence of “contentdb” database by running the following at the mongodb prompt: 
		- `show dbs`
- They will need to use something similar to the command below to perform the rolling update:
	- `kubectl set image deployment/content-web content-web=whatthehackmsft/content-web:v2`
		- where **deployment/content-web** is the name of the deployment used
	- `kubectl set image` takes the name of the deployment and the new image to update to.
	- **NOTE:** Use a similar command to perform a rolling update on content-api
- Use `kubectl get pods --watch` to show all the pods getting updated and terminated.
- Rollbacks are performed with:
	- `kubectl rollout undo deployment/content-web`
	- This will roll-back the last update to the **content-web** deployment.
- Blue/Green deployments are described here:
	- <https://www.ianlewis.org/en/bluegreen-deployments-kubernetes>
    - The students will need to create a separate deployment YAML with different tags and deploy it.
    	- **NOTE:** The **content-web-deploy-solution.bluegreen.yaml** solution file is an example of an updated deployment using the v2 flag.
    - When the new pods are ready to go, they will update the service YAML to point to the new tags.
- The following errors get reported with v2 of the app:
	- content-web crashes if content-api returns null/blank
	- content-api returns null/blank if it loses connection to mongodb after the first initialization
	- API has no db connection retry logic to reconnect if it loses db connection
	- **Solution:** If you restart the mongo backend for any reason (re-deploy/scale/crash/testing etc), you have to kill & restart all api pods to force them to re-establish their DB connection again.
- During Blue/Green deployment, some attendees create separate service files and/or change the ENV values. This results in extra competing services with the same name or ENV values that causes unexpected routing behavior.  
    - It is always wise to completely delete all deployments/services/etc before trying/re-trying an action. 
- The content-web's environment variable **CONTENT_API_URL** can not end in a trailing slash. If it does, then no data is returned from the API.
- **IMPORTANT:** You cannot update content-api v2 via a rolling update.  This is because it requires the mongodb connection ENV var to be set. But it is set by the content-api deployment yaml and thus rolling update fails. Some students might go down this path, consider letting them fail and then explaining why it didn’t work.
	- If they experience no error, it is because they set the ENV var inside the deployment and reapplied the file before performing a rolling update.
- **NOTE:** When creating the service YAML for MongoDB in Challenge 6, it is important for students to be aware of what service name they use.  The provided content-init.yml job file in Challenge 7 sets an environment variable that expects the service to be named **mongodb**.   If the service name does not match, the content-init job will fail with an error.  If students run into this error, help them troubleshoot and come up with a solution, eg: change the service name, or modify the content-init.yml.
- **NOTE:** When doing the blue/green update, students will need to create a new deployment YAML file for content-api v2.  This file will also set an environment variable with the location of the Mongo DB service.  The value of the DNS portion of the URL in this environment variable must match the name of the MongoDB service that the students created in Challenge 6. 

## Videos

### Challenge 7 Solution, part 1: Initializing the Data

[![Challenge 7 solution, part 1: Initializing the Data](../Images/WthVideoCover.jpg)](https://youtu.be/vFA-nOyCfy8 "Challenge 6 Solution, part 1: Initializing the Data")

### Challenge 7 Solution, part 2: Rolling Updates

[![Challenge 7 solution, part 2: Rolling Updates](../Images/WthVideoCover.jpg)](https://youtu.be/Omyhx1McBl8 "Challenge 6 Solution, part 2: Rolling Updates")

### Challenge 7 Solution, part 3: Blue/Green Deployments

[![Challenge 7 solution, part 3: Blue/Green Deployments](../Images/WthVideoCover.jpg)](https://youtu.be/l08a9LkEILw "Challenge 6 Solution, part 3: Blue/Green Deployments")
