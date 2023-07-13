# Challenge 03 - Run the app on Azure

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Introduction

In a previous challenge we deployed the app on Azure but into an Azure Docker-machine playing the role of your local machine. Now with this challenge you will be able to provision an Azure Web App Service for Containers to host your "Rock Paper Scissors Boom" app.

![Run on Azure](../images/RunOnAzure.png)

## Description

> Note: You should use an Infrastructure as Code language (Azure CLI, Bicep, Terraform, etc) to provision your Azure services. You could also use the Azure Portal to provision your Azure services, but it's not recommended.

- Provision an Azure Container Registry (ACR) to push your container in it.
- Push your local Docker image to your ACR.
- Provision an Azure Web App Service for Containers & deploy the app in your Azure Web App Service for Containers by pulling the Docker image from your ACR previously created, test it as an end-user, and play a game once deployed there.

## Success Criteria

To complete this challenge successfully, you should be able to:

- Deploy an Azure Container Registry, push your local Docker image to it & deploy the app in an Azure Web App Service for Containers.
- In your web browser, navigate to the app and play a game, make sure it's working without any error.
- In Azure DevOps (Boards), from the Boards view, you could now drag and drop the user story associated to this Challenge to the `Resolved` or `Closed` column, congrats! ;)

## Learning Resources

- [Containers hosting options in Azure](https://azure.microsoft.com/en-us/overview/containers/)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure)
- [Terraform for Azure](https://docs.microsoft.com/en-us/azure/terraform/)
- [Azure App Service diagnostics overview](https://docs.microsoft.com/en-us/azure/app-service/app-service-diagnostics)
- [Azure Web App Service CLI documentation](https://docs.microsoft.com/en-us/cli/azure/webapp)
- [Azure Container Registry CLI documentation](https://docs.microsoft.com/en-us/cli/azure/acr)

## Tips

- To use a custom Docker image for Web App for Containers, [here you are](https://docs.microsoft.com/en-us/azure/app-service/containers/tutorial-custom-docker-image)! The "Use a Docker image from any private registry" section is specifically what you are looking for.
- You can either provision a managed identity & grant it RBAC access to the ACR or use the ACR admin credentials to pull the Docker image from the ACR into App Service.
