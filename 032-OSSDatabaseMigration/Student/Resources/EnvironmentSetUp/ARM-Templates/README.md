
## How to Deploy AKS Cluster

You can run the following commands to do the following:

* Create Resource Group
* Deploy AKS Cluster
* Fetch Cluster Credentials
* View the AKS Node Pools
* How to Scale up the cluster node pools
* How to Scale down the cluster node pools


```bash
# Defines the ARM template file location
export templateFile="aks-cluster.json"

# Defines the parameters that will be used in the ARM template
export parameterFile="parameters.json"

# Defines the name of the Resource Group our resources are deployed into
export resourceGroupName="OSSDBMigration"

export clusterName="ossdbmigration"

# Creates the resources group if it does not already exist
az group create --name $resourceGroupName --location "West US"

# Creates the Kubernetes cluster and the associated resources and dependencies for the cluster
az deployment group create --name dataProductionDeployment --resource-group $resourceGroupName --template-file $templateFile --parameters $parameterFile

# Install the Kubectl CLI. This will be used to interact with the remote Kubernetes cluster
sudo az aks install-cli

# Get the Credentials to Access the Cluster with Kubectl
az aks get-credentials --name $clusterName --resource-group $resourceGroupName

# List the node pools
az aks nodepool list --resource-group $resourceGroupName --cluster-name $clusterName

# Scale the User Node Pool Manually to 5 nodes
# You can use this to scale up the user node pools
az aks nodepool scale --resource-group $resourceGroupName --cluster-name $clusterName --name userpool --node-count 5 --no-wait

# You can use this to scale down the user node pools
az aks nodepool scale --resource-group $resourceGroupName --cluster-name $clusterName --name userpool --node-count 1 --no-wait

```