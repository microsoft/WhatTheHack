# Challenge 1 - Setup

[Next Challenge>](./02-helm.md)

## Prerequisites

1. Your laptop: Windows/Linux/OSX
1. Bash Shell (e.g. WSL)
1. Your Azure Subscription


## Introduction 

The first challenge is to setup your local environment as well as the AKS cluster you will be running on.

## Description

Install each of the CLI tools and ensure you can login to each of the online services.  We will be using these later in the challenges

All challenges will be run using Bash.

## Challenge

1. Latest Azure CLI
    - Verified with 2.7.0
1. Install Docker
1. Install Helm 3
1. Create a Github Account
1. Create an ACR
1. Create an AKS cluster with the following:
    - System pool with 1 Standard_DS2_v2
    - User pool with 1 Standard_DS2_v2
    - Cluster Autoscaling enabled
    - Managed Identity enabled
1. Attach ACR to the AKS cluster
1. Install Curl
1. Install JQ
1. [OPTIONAL] Install kubectx/kubens/kube-aliases

## Success Criteria

1. Running `docker version` shows your Docker client and server version
1. Running `helm version` shows the Helm version
1. You have logged into Github
1. You have your own Docker Hub account
1. Running `kubectl get nodes` shows your AKS System and User pools
1. Running `az acr import  -n $ACR_NAME --source docker.io/library/nginx:latest --image nginx:v1` copies an image to your ACR instance
1. Running `curl -s https://api.github.com/users/octocat/repos | jq '.'`  shows you a pretty-printed JSON doc
1. [OPTIONAL] Running `kubectx` lets you switch between K8S clusters
1. [OPTIONAL] Running `kubens` lets you switch between namespaces
1. [OPTIONAL] Running `ksysgpo` shows all pods in your system namespace

## Hints

1. [AKS and ACR integration](https://docs.microsoft.com/en-us/azure/aks/cluster-container-registry-integration)
1. [kubectx and kubens](https://github.com/ahmetb/kubectx)
1. [kubectl aliases](https://github.com/ahmetb/kubectl-aliases)
1. [jq](https://stedolan.github.io/jq/)
