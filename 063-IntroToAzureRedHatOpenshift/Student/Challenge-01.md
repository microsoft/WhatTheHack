# Challenge 01 - ARO Cluster Deployment

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Introduction

Red Hat OpenShift is an enterprise-ready Kubernetes container platform with full-stack automated operations to manage hybrid and multi-cloud deployments often referred to as “Enterprise Kubernetes”​. It is jointly engineered, operated, and supported by both ​Microsoft and Red Hat with an integrated support experience​.

There are differences between Kubernetes and ARO:
- **Ease of deployment:** ARO automates the heavy lifting and backend work, so you only need to create a project and upload code​
- **Security:** Included security features, so ARO handles things like name-spacing and creating different security policies​
- **Day to day operations:**  Cluster provisioning, scaling, and upgrade operations are automated and managed by the platform

Now that we got that down, it's time to deploy the Azure Red Hat OpenShift cluster we'll be using for this hack! You'll learn how to deploy a cluster, how to access the web console, and how to connect to the ARO cluster.

## Description

In this challenge we will deploy our first Azure Red Hat OpenShift cluster. This will give us an opportunity to learn how to use the `oc` OpenShift CLI, the Azure CLI to issue OpenShift commands, as well as how to access the ARO Web Console.

- Deploy an Azure Red Hat OpenShift cluster with your Red Hat pull secret 
  - **NOTE:** Use the flag `--pull-secret @pull-secret.txt` when creating your cluster and replace `@pull-secret.txt` with your pull secret file
  - **NOTE:** If you are deploying using the portal, under the domain field, You can either specify a domain name (like example.com) or you can specify a prefix (say `pkn`) that will be used as part of the auto generated DNS name for Openshift console and API servers
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
- [Tutorial: Create an Azure Red Hat OpenShift 4 cluster](https://learn.microsoft.com/en-us/azure/openshift/tutorial-create-cluster)
- [Quickstart: Deploy an Azure Red Hat OpenShift cluster using the Azure portal](https://learn.microsoft.com/en-us/azure/openshift/quickstart-portal)
- [Tutorial: Connect to an Azure Red Hat OpenShift 4 cluster](https://docs.microsoft.com/en-us/azure/openshift/tutorial-connect-cluster)