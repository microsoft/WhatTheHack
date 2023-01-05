# Challenge 03 - Introduction To Kubernetes - Coach's Guide 

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-04.md)

## Notes & Guidance

- Remind teams that kubectl can be installed through the CLI, but don’t give away the answer:
	- `az aks install-cli`
- All teams should have an AKS cluster stood up relatively quickly but they will likely need some hints regarding the correct parameters for the `az aks create` command.
	- The default Kubernetes version used by the az aks create command should be fine.  
	- The CLI should be used to create the cluster to give the most realistic experience.  
	- Cluster names should be unique within the subscription.  
	- Here’s an example command that creates a cluster named **wth-aks02-poc** in resource group **wth-rg02-poc:** using basic networking, managed identity, 3 nodes in separate availability zones and an attached ACR and doesn't generate any ssh keys:
		- `az aks create --location eastus --name wth-aks02-poc --node-count 3  --no-ssh-key --resource-group wth-rg02-poc --zones 1 2 3 --enable-managed-identity --attach-acr <acrname>`
  	- **NOTE:** Attaching an ACR requires the student to have Owner or Azure account administrator role on the Azure subscription. If this is not possible then someone who is an Owner can do the attach for the student after they create the cluster.
		- See below for the `az aks update` command that is used to attach the ACR.
	- Documentation on installing AKS can be found here:
		- [Portal](https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough-portal)
		- [CLI](https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough)
- It is usually a good idea to explain to the students what kind of options they have when creating a cluster. Doing a walkthrough demo of provisioning a cluster with the Portal is good showcasing tool, but end by telling them they need to figure out how to achieve the same thing with the CLI.
- Have the teams show you the running cluster with:
	- `kubectl get nodes`
		- This should show three nodes, but it will not show the availability zone.  
    - To see the availability zone, run:  `kubectl get nodes -o custom-columns=NAME:'{.metadata.name}',REGION:'{.metadata.labels.topology\.kubernetes\.io/region}',ZONE:'{metadata.labels.topology\.kubernetes\.io/zone}'`  _(BTW, this command comes from the [Azure docs](https://docs.microsoft.com/en-us/azure/aks/availability-zones#verify-node-distribution-across-zones) )_
	- Each node should be a VM with at least 2 vCPU and 4 GB of memory.  The reason for this is that we need to have enough CPU and RAM for the system pods to run (e.g. CoreDNS and tunnelfront).  See this link for more details: 
    	- <https://docs.microsoft.com/en-us/azure/aks/use-system-pools>
	- **NOTE:** They will need to learn how to connect kubectl to their cluster using `az aks get-credentials`
- If someone needs to attach their ACR to the cluster after they created it, they can use: 
	- `az aks update -n myAKSCluster -g myResourceGroup --attach-acr <acrName>`
- **Optional:** The AKS "Workloads" screen in the Azure portal can be brought up with the CLI easily:
	- `az aks browse --name myAKSCluster --resource-group myAKSCluster`
	- **NOTE:** This will open a web browser and go to the Azure Portal. If you're not logged in, you will be prompted to do so.

## Videos

### Challenge 3 Solution

[![IMAGE ALT TEXT](http://img.youtube.com/vi/2sH-NlyikEk/0.jpg)](https://youtu.be/2sH-NlyikEk "Challenge 3 solution")
