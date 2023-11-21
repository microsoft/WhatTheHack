# Challenge 01 - ARO Cluster Deployment - Coach's Guide 

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Notes & Guidance
- Creating an ARO cluster takes a long time, so consider having the students create a cluster before you present the challenge lecture
  - Example: Go through lecture slides 1-2, then have the students create a cluster, and when they have started their cluster deployment, complete the remaining lecture slides

## Create an Azure Red Hat Openshift cluster

- Follow the steps in the Microsoft documentation to create a ARO cluster: [Tutorial: Create an Azure Red Hat OpenShift 4 cluster](https://docs.microsoft.com/en-us/azure/openshift/tutorial-create-cluster)
  - **NOTE:** Make sure the students use the flag `--pull-secret @pull-secret.txt` when creating their cluster and replace `@pull-secret.txt` with their pull secret file. IF they do not do this, they will have to redeploy their cluster in later challenges!
  - **NOTE:** It normally takes about 35-45 minutes to create a cluster

## Login to the ARO Web Console

- Find the login credentials for the web console using the command `az aro list-credentials --name $CLUSTER --resource-group $RESOURCEGROUP`
- Find the web console URL using the command `az aro show --name $CLUSTER --resource-group $RESOURCEGROUP --query "consoleProfile.url" -o tsv` which will look like https://console-openshift-console.apps.[random].[region].aroapp.io/
- Open the URL in a web browser and login using your login credentials found using `az aro list-credentials` command

## Connect to an ARO cluster

- In the ARO web console, click on the username on the top right, then click Copy login command
- Open the Shell you are using and paste the login command
- Verify they are connected to cluster by using the command `oc projects`. If you get an error `Error from server (Forbidden)` that means the user has not connected to the cluster

## Helpful Links

- [Tutorial: Create an Azure Red Hat OpenShift 4 cluster](https://docs.microsoft.com/en-us/azure/openshift/tutorial-create-cluster)
- [Tutorial: Connect to an Azure Red Hat OpenShift 4 cluster](https://docs.microsoft.com/en-us/azure/openshift/tutorial-connect-cluster)
