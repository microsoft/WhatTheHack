## Instructions

Create accounts:

* https://github.com/join
* https://hub.docker.com/account/signup/

Install tools:

* https://helm.sh/docs/intro/install/
* https://stedolan.github.io/jq/
* https://github.com/ahmetb/kubectx
* https://github.com/ahmetb/kubectl-aliases


## Create ACR

```
ACR=<replace with the name of your acr>
az acr create -n $ACR -g $RG --sku basic
```

## Create AKS cluster with attached ACR

```
RG=<replace with the name of your resource group>
LOCATION=<replace with your location>
az group create $RG -l $LOCATION
az aks create -n $RG -g $RG --enable-cluster-autoscaler --enable-managed-identity --min-count 1 --max-count 5 --attach-acr $ACR --node-count 1
az aks nodepool add --cluster-name $RG -g $RG -n userpool --enable-cluster-autoscaler --min-count 1 --max-count 5
```
