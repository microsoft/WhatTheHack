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
ACR=
az acr create -n $ACR -g $RG --sku basic
```

## Create AKS cluster with attached ACR

```
RG=
LOCATION=
az group create $RG -l $LOCATION
az aks create -n $RG -g $RG --enable-cluster-autoscaler --enable-managed-identity —node-count 1 --attach-acr $ACR
az aks nodepool add --cluster-name $RG -g $RG -n userpool -c 1
```

