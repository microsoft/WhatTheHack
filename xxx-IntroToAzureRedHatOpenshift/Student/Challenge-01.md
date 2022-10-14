# Challenge 01 - ARO Cluster Deployment

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Introduction

It's time to deploy the Azure Red Hat OpenShift cluster we'll be using for this hack! You'll learn how to deploy a cluster, how to access the web console, and how to connect to the ARO cluster.

## Description

In this challenge we will deploy our first Azure Red Hat OpenShift cluster. This will give us an opportunity to learn how to use the `oc` OpenShift CLI, the Azure CLI to issue OpenShift commands, as well as how to access the ARO Web Console.

- Deploy an Azure Red Hat OpenShift cluster with your Red Hat pull secret 
  - **NOTE:** Use the flag `--pull-secret @pull-secret.txt` when creating your cluster and replace `@pull-secret.txt` with your pull secret file
- Access the ARO Web Console and retrieve a login command
- Connect to the ARO cluster using the OpenShift CLI
- Explore the ARO Web Console

## Success Criteria

To complete this challenge successfully, you should be able to:
- Verify that the ARO cluster has been created using the command `az aro list -o table`
- Demonstrate that you can login to the ARO Web Console
- Demonstrate that you are connected to the ARO cluster using the command `oc projects` you should see a list of projects if you are connected
- Verify the cluster nodes are running using the command `oc get nodes`

## Learning Resources

- [What is Azure Red Hat OpenShift?](https://docs.microsoft.com/en-us/azure/openshift/intro-openshift)
- [Tutorial: Connect to an Azure Red Hat OpenShift 4 cluster](https://docs.microsoft.com/en-us/azure/openshift/tutorial-connect-cluster)