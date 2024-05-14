# Challenge 1: Coach's Guide - Setup

**[Home](README.md)** - [Next Challenge>](./02-helm.md)

## Instructions

Create accounts:

* <https://github.com/join>
* <https://hub.docker.com/account/signup/>

Install tools:

* <https://helm.sh/docs/intro/install/>
* <https://stedolan.github.io/jq/>
* <https://github.com/ahmetb/kubectx>
* <https://github.com/ahmetb/kubectl-aliases>


## Create ACR

```
RG_NAME=aks-wth
ACR_NAME=akswthacr

az acr create -n $ACR_NAME -g $RG_NAME --sku basic
```

## Create AKS cluster with attached ACR

```
RG_NAME=aks-wth
AKS_NAME=aks-wth
NODEPOOL_NAME=userpool
LOCATION=eastus

# create resource group
az group create -n $RG_NAME --location $LOCATION

# create AKS cluster
az aks create -n $AKS_NAME -g $RG_NAME \
    --node-count 1 \
    --enable-cluster-autoscaler \
    --min-count 1 --max-count 5 \
    --enable-managed-identity \
    --attach-acr $ACR

# add new nodepool
az aks nodepool add --cluster-name AKS_NAME -g $RG_NAME \
    -n $NODEPOOL_NAME \
    --enable-cluster-autoscaler \
    --min-count 1 --max-count 5
    
# authenticate to AKS cluster
az aks get-credentials -g $RG_NAME -n $AKS_NAME
```
