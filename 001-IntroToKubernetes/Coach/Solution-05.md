# Challenge 05 - Scaling and High Availability - Coach's Guide 

[< Previous Solution](./Solution-04.md) - **[Home](./README.md)** - [Next Solution >](./Solution-06.md)

## Notes & Guidance

- In the YAML file, they will have to update the **spec.replicas** value. They can use this command to edit the deployment resource:
	- `kubectl edit deployment content-web`
	- Alternatively (and perhaps preferably!), they can edit the yaml directly in the Azure portal.  
- They can watch cluster events by using the following command:
	- `kubectl get events --sort-by='{.lastTimestamp}' --watch`
- The error they will encounter is that there aren’t enough CPUs in the cluster to support the number of replicas they want to scale to.
- The three fixes to address resource constraints are:
	- Use the Azure portal or CLI to add more nodes to the AKS cluster.
	- Use the cluster autoscaler to automatically add more nodes to the cluster as resources are needed.
    	- Once the challenge is complete, show the team how easy it is to enable the cluster autoscaler  (Portal -> Cluster -> Node Pools -> Scale, then select 'Autoscale')
	- Change the deployment and reduce the needed CPU number from “0.5” to “0.125” (500m to 125m).
		- In production environment, consider a discussion with the application owner/architect before reducing any resources.
		- **NOTE** In this Challenge, if the last option doesn't work, delete the old deployment and reapply it. Kubernetes deploys new pods before tearing down old ones and if we are out of resources, no new pods will be deployed.
- **NOTE:** In case they do **NOT** get an error and are able to scale up, check how many nodes they have in their cluster and the size of the node VMs. Over provisioned clusters will not fail.
	- If a team doesn’t get a failure, just have them double the number of Web and API app instances.  
