# Challenge 8: Coach's Guide

[< Previous Challenge](./07-updaterollback.md) - **[Home](README.md)** - [Next Challenge >](./09-helm.md)

## Notes & Guidance

- Azure disks are zone-specific resources and must be in the same zone as the node that the pod is running on. See [here](https://docs.microsoft.com/en-us/azure/aks/availability-zones#azure-disks-limitations).
- Generally, PVCs are bound immediately on creation. That means it is possible for the two PVCs for the mongodb pod to be bound to Azure Disks in different zones.
- To force the two PVs to be deployed to the same zone, a new storage class is created with "volumeBindingMode: WaitForFirstConsumer". This forces kubernetes to wait until a workload is deployed before provisioning the disks. See [here](https://kubernetes.io/docs/concepts/storage/storage-classes/#volume-binding-mode).
- Kubernetes is smart enough to not schedule pods with PVs in a specific zone on a node in a different zone, see [here](https://kubernetes.io/docs/setup/best-practices/multiple-zones/#storage-access-for-zones).


### Troubleshooting

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
- **NOTE**: If mongodb is not working with the new disk, a potential fix is to restart the API.
