# What The Hack - Solution Guide - Azure Arc enabled Kubernetes Hack

## Challenge 2 – Deploy Kubernetes cluster locally
[Back](challenge01.md) - [Home](../readme.md) - [Next](challenge03.md)
### Solution

Estimated Time to Complete: **30 mins**

Once the GKE cluster is deployed, in this challenge we will add complexity by adding another Kubernetes cluster in the local environment using minikube.

 ![](../../img/image4.png)

To install a minikube cluster follow the [documentation](https://kubernetes.io/docs/tasks/tools/install-minikube/) on the official site. Note the instructions change according to the local OS. Once the cluster is installed ensure the local config file is set appropriately to ensure Arc enablement of the cluster happens correctly.

[Back](challenge01.md) - [Home](../readme.md) - [Next](challenge03.md)
