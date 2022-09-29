# Challenge 08 - Storage - Coach's Guide 

[< Previous Solution](./Solution-07.md) - **[Home](./README.md)** - [Next Solution >](./Solution-09.md)

## Notes & Guidance
- Azure disks are zone-specific resources and must be in the same zone as the node that the pod is running on. See [here](https://docs.microsoft.com/en-us/azure/aks/availability-zones#azure-disks-limitations).
- Generally, PVCs are bound immediately on creation. That means it is possible for the two PVCs for the mongodb pod to be bound to Azure Disks in different zones.
- As of the most recent edit to this lab (March 2021), the default storage class uses `volumeBindingMode: WaitForFirstConsumer`.  This forces kubernetes to wait until a workload is deployed before provisioning the disks. See [here](https://kubernetes.io/docs/concepts/storage/storage-classes/#volume-binding-mode).
  - In earlier days, this was not the case; the default was `volumeBindingMode: Immediate`.  Thus, in earlier days, to force the two PVs to be deployed to the same zone, a new custom storage class needed to be created with `volumeBindingMode: WaitForFirstConsumer`.  **Using a custom storage class is no longer necessary for this hack**
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

## Extra Credit Discussion
Q: What would happen if the node running MongoDB were to crash?  Would Kubernetes be able to redeploy the pod?

A:  Maybe; more specifically, only if there was another node running in the same AZ as the original node.
