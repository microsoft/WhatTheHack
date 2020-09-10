# Challenge 8: Coach's Guide

[< Previous Challenge](./07-updaterollback.md) - **[Home](README.md)** - [Next Challenge >](./09-helm.md)

## Notes & Guidance
- Make sure that the attendees are using the latest container images including the **content-init** Node.js container
- Make sure that the attendees are verifying the MongoDB connection, data and disks by connecting to the MongoDB with an interactive terminal.
- Make sure that the attendees understand the concept of storage volumes and how AKS provides value by providing the azure disk / file storage in both dynamic and static mode.
- To troubleshoot mongo and verify that there is data in the database, you need to:
	- Connect to the mongo pod using: 
		- `kubectl exec -it <mongo-db pod name> bash`
	- Execute these commands:
		```
		mongo
		show dbs
		use <databasename>
		db.<table/collection>.find()
		```
- **NOTE:** This challenge is using static persistent storage using an Azure disk attached to a single pod.  While this technically works for this example, it is not a best practice.  A better practice is to configure a persistent volume on the cluster, then use a persistent volume claim (PVC) in the mongo pod that uses the cluster’s volume.  
    - This challenge should be re-written to use the PVC pattern. 
	- To do this, we’ll need a new solution file in the repo that has the ‘answers’ that work.
- **NOTE** Static and dynamic volumes will not work if they do not have availability zones enabled.
	- For static volumes: To fix this, add a specfic availability zone to your Azure managed disk.
	- For dynamic volumes: To fix this, enable availability zones and then use Node Affinity/Node Selectors and attach the Azure Disk to the node that is in the same AZ.
	- For static and dynamic volumes: Another workaround is to redeploy the AKS cluster without availability zones enabled.
- **NOTE** If mongodb is not working with the new disk, a potential fix is to restart the API.
