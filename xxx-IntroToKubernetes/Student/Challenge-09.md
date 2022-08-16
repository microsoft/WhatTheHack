# Challenge 09 - Helm

[< Previous Challenge](./Challenge-08.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-10.md)

## Introduction

There are many ways to make dinner... you can buy fresh vegetables and meat, combine it with eggs and water, season it with herbs and spices and mix it all together with cooking utensils into pots and pans and cook it in your stove, range or grill.

**OR**

You can buy a microwave dinner, peel back the foil, heat it up for 5 minutes in the microwave and start eating.

Helm is the microwave dinner of the Kubernetes world, allowing you to package entire deployments that can be installed with a single command.

## Description

In this challenge you will be installing Helm locally and then creating a Helm "Chart" for the Language Facts application and then using helm to quickly deploy different version of that application.

### Deploy Without Helm
- Deploy the Language Facts application for this challenge using the yaml files provided in the `/Challenge-09` folder of the `Resources.zip` package. You will have to install the namespace, deployment, and service yaml in that sequence.
	- `helm-webapp-namespace.yml`
	- `helm-webapp-deployment.yml`
	- `helm-webapp-service.yml`
- Verify that the app has been deployed successfully by browsing the web app via the LoadBalancer IP address at port 80. 
- Redeploy the app to use v2 of the image and verify that the update is visible in the web app. Repeat these steps with v3 and v4 of the container image.

### Install Helm on Your Workstation
If you do not have Helm installed on your local workstation, you can do so with the following steps:
- Fetch the script for installing Helm to the local machine where you will be using Helm
	- `curl -fsSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 -o get_helm.sh`
- Set permissions that will make the script executable on the machine
	- `chmod 700 get_helm.sh`
- Install Helm client locally
	- `./get_helm.sh`

If you are using the Azure Cloud Shell, the Helm CLI is already installed and you can continue with the tasks below.

### Deploy With Helm

- Creating a Helm Chart from a local package
	- **NOTE:** You will need to create the expected namespace on the CLI when you run the `helm install` command (it is a parameter). You'll need to use the namespace found in this file that you used above 
		- `helm-webapp-namespace.yml`
		- **Hint:** The namespace will NOT be a part of your Chart but must be specified when installing the chart.
	- Convert these yaml files that were just used to deploy the app into a Helm chart using v1 of the container image.
		- You should parameterize the following values in the deployment YAML file (`helm-webapp-deployment.yml`):
			- container image name
			- container image version 
	- Create a Helm package on the local machine for each version of the web app.
		- **Hint:** If you parameterize things properly, you'll be able to write ONE helm chart that takes the version as an input.
	- Remove the previously deployed app by deleting the namespace that was created via the yaml file
	- Deploy the helm chart with v1 of the image you just created. 
	- Verify that the app has been deployed successfully
	- Make a note of the difference in number of steps involved in the deployment using individual yaml files vs the Helm chart
- Deploying helm charts from a remote container registry
	- **NOTE:** You will need an Azure Container Registry for this part. If you did Challenge 2 you'll already have one, otherwise you can create one if you have permissions or skip this part of the challenge.
	- Push the Helm chart you just packaged to an Azure Container Registry (ACR)
	- Remove the package locally
	- Uninstall the app and redeploy it using the Helm chart from the ACR repo
	- Verify that the app has been deployed successfully

## Success Criteria

1. Verify that `helm version` shows that you have it installed locally.
1. Show that you have created a Chart to install the application.
1. Verify that the application installs and runs correctly.
1. Demonstrate that you are able to push the Chart to a container registry and install it from there.

## Learning Resources

- [An Introduction to Helm, the Package Manager for Kubernetes](https://www.digitalocean.com/community/tutorials/an-introduction-to-helm-the-package-manager-for-kubernetes)
- [Quickstart: Develop on Azure Kubernetes Service (AKS) with Helm](https://docs.microsoft.com/en-us/azure/aks/quickstart-helm)
- [Helm: The package manager for Kubernetes](https://helm.sh/)
- [Installing Helm](https://helm.sh/docs/intro/install/)
- [Install existing applications with Helm in Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/kubernetes-helm)
- [Integrate with Kubernetes Deployment using Helm](https://docs.microsoft.com/en-us/azure/azure-app-configuration/integrate-kubernetes-deployment-helm)
