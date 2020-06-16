# Challenge 9: Helm

[< Previous Challenge](./08-storage.md)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next Challenge >](./10-networking.md)

## Introduction

There are many ways to make dinner... you can buy fresh vegetables and meat, combine it with eggs and water, season it with herbs and spices and mix it all together with cooking utensils into pots and pans and cook it in your stove, range or grill.

**OR**

You can buy a microwave dinner, peel back the foil, heat it up for 5 minutes in the microwave and start eating.

Helm is the microwave dinner of the Kubernetes world, allowing you to package entire deployments that can be installed with a single command.

## Description

In this challenge you will be installing Helm locally and in your cluster and then creating Helm "Charts" and pushing to your container registry.

## Challenge

- Fetch the script for installing Helm to the local machine where you will be using Helm
	- `curl -fsSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 -o get_helm.sh`
- Set permissions that will make the script executable on the machine
	- `chmod 700 get_helm.sh`
- Install Helm client locally
	- `./get_helm.sh`
- Creating a Helm Chart from a local package
	- Deploy the application for this challenge using the yaml files provided in your Challenge 9 Resources folder. You will have to install the namespace, deployment and service yaml in that sequence.
		- `helm-webapp-namespace.yml`
		- `helm-webapp-deployment.yml`
		- `helm-webapp-service.yml`
	- Verify that the app has been deployed successfully by browsing the web app via the LoadBalancer IP address at port 80. 
	- Redeploy the app to use v2 of the image and verify that the update is visible in the web app. Repeat these steps with v3 and v4 of the container image.
	- Convert these yaml files that were just used to deploy the app into a Helm chart using v1 of the container image.
	- Create a Helm package on the local machine for each version of the web app.
	- Remove the previously deployed app by deleting the namespace that was created via the yaml file
	- Deploy the helm chart with v1 of the image you just created. 
	- Verify that the app has been deployed successfully
	- Make a note of the difference in number of steps involved in the deployment using individual yaml files vs the Helm chart
- Deploying helm charts from a remote container registry
	- Push the Helm chart you just packaged to an Azure Container Registry (ACR)
	- Remove the package locally
	- Uninstall the app and redeploy it using the Helm chart from the ACR repo
	- Verify that the app has been deployed successfully

## Success Criteria

1. `helm version` shows that you have it installed locally.
1. You've created a Chart to install the application.
1. The application installs and runs correctly.
1. You're able to push the Chart to a container registry and install it from there.