# Challenge 4: System protection with backup

[< Previous Challenge](./03-SAP-Security.md) - **[Home](../README.md)** - [Next Challenge >](./05-PowerApps.md)

## Introduction

Mango Inc heavily relies on SAP infrastructure to perform day to day business transactions. Unavailability of IT infrastructure for SAP or SAP application itself can heavily impact business transactions and potentially delay revenue recognition. Mango Inc is concerning about the data consistency on backups and restorability with online backups and necessity of offline backups along with periodicity. CIO heard about Azure netapp files and its features and took a decision to use ANF across the SAP infrastructure for Hana database.  

## Description

SAP S/4 Hana system is fully protected with required IT monitoring, secured & compliance configuration and also with high availabitly for IT component failures. However, it is not protected with accidental errors, unintended data discrepencies, data loss / corruption or geographical catastrophies. Design and implement BCDR solution for SAP S/4 Hana system by implementing secondary copy of SAP system in another seperate azure region from production region with continuous asynchronous data replication.

## Guidelines




- **NOTE:** If you have not or cannot deploy your containers to the Azure Container Registry, we have staged the FabMedical apps on Docker Hub at these locations:
	- **API app:** whatthehackmsft/content-api
	- **Web app:** whatthehackmsft/content-web
- Deploy the **API app** from the command line using kubectl and YAML files:
	- **NOTE:** Sample YAML files to get you started can be found in the Files section of the General channel in Teams.
	- Number of pods: 1
	- Service: Internal
	- Port and Target Port: 3001
	- CPU: 0.5
	- Memory: 128MB
- We have not exposed the API app to the external world. Therefore, to test it you need to:
	- Figure out how to get a bash shell on the API app pod just deployed.
	- Curl the url of the `/speakers` end point.
	- You should get a huge json document in response.
- Deploy the Web app from the command line using kubectl and YAML files
	- **NOTE:** Sample YAML files to get you started can be found in the Files section of the General channel in Teams.
	- **NOTE:** The Web app expects to have an environment variable pointing to the URL of the API app named:
		- **CONTENT_API_URL**
	- Create a deployment yaml file for the Web app using the specs from the API app, except for:
		- Port and Target Port: 3000
	- Create a service yaml file to go with the deployment
		- **Hint:** Not all "types" of Services are exposed to the outside world
	- **NOTE:** Applying your YAML files with kubectl can be done over and over as you update the YAML file. Only the delta will be changed.
	- **NOTE:** The Kubernetes documentation site is your friend. The full YAML specs can be found there: <https://kubernetes.io/docs>
- Find out the External IP that was assigned to your service. You can use kubectl for this.
- Test the application by browsing to the Web app's external IP and port and seeing the front page come up.
	- Ensure that you see a list of both speakers and sessions on their respective pages.
	- If you don't see the lists, then the web app is not able to communicate with the API app.

## Success Criteria

1. A successfil setup of backup solution and successful backup. 
2. An automated orchestration of ANF snapshots on hana data/log volumes to achieve point in time recovery.
3. Availability of offloaded snapshots in azure storage account containers as per the requirement. Demonstrate successful restore that BACKUPTEST user. 
4. Be able to successfully restore the dual purpose environment with the recent prodution data (with DRTEST user)

## Resources

1. help
2. netap
3. blog
4. 

