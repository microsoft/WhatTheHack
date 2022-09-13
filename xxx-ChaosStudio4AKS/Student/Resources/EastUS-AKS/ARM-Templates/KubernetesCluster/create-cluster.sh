# Add line to set login to az
#az login
# Set your azure subscription
#az account set -s "<subscription-id>"
# Defines the ARM template file location
export templateFile="aks-cluster.json"

# Defines the parameters that will be used in the ARM template
export parameterFile="parameters.json"

# Defines the name of the Resource Group our resources are deployed into
export resourceGroupName="PizzaAppEast"

export clusterName="pizzaappeast"

export location="eastus"

# Creates the resources group if it does not already exist
az group create --name $resourceGroupName --location $location

# Creates the Kubernetes cluster and the associated resources and dependencies for the cluster
az deployment group create --name dataProductionDeployment --resource-group $resourceGroupName --template-file $templateFile --parameters $parameterFile 

# Install the Kubectl CLI. This will be used to interact with the remote Kubernetes cluster
#sudo az aks install-cli

# Get the Credentials to Access the Cluster with Kubectl
az aks get-credentials --name $clusterName --resource-group $resourceGroupName

# List the node pools - expect two aks nodepools

az aks nodepool list --resource-group $resourceGroupName --cluster-name $clusterName -o table
