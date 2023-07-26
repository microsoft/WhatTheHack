# Challenge 03 - Run the app on Azure

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Introduction

In a previous challenge, we updated the app to use an Azure SQL Database, but the app is still running locally. Now with this challenge you will provision an **Azure Web App for Containers** to host your **Rock Paper Scissors Boom** app.

![Run on Azure](../images/RunOnAzure.png)

## Description

> Note: You should use an Infrastructure as Code language (Azure CLI, Bicep, Terraform, etc) to provision your Azure services. You could also use the Azure Portal to provision your Azure services, but it's not recommended.

- Provision an Azure Container Registry (ACR) to push your container in it.
- Push your local Docker image to your ACR.
- Provision an Azure Web App Service for Containers & deploy the app in your Azure Web App Service for Containers by pulling the Docker image from your ACR previously created, test it as an end-user, and play a game once deployed there.

## Success Criteria

To complete this challenge successfully, you should be able to:

- Validate that you can create an Azure Container Registry (ACR)
- Validate that you can push your local Docker image to the ACR
- Validate that you can deploy the app in an Azure Web App for Containers.
- In your web browser, navigate to the app and play a game, make sure it's working without any error.

## Learning Resources

- [Web App for Containers](https://learn.microsoft.com/en-us/azure/app-service/tutorial-custom-container?tabs=azure-cli&pivots=container-linux)
- [Azure App Service diagnostics overview](https://docs.microsoft.com/en-us/azure/app-service/app-service-diagnostics)
- [Azure Web App Service CLI documentation](https://docs.microsoft.com/en-us/cli/azure/webapp)
- [Azure Container Registry CLI documentation](https://docs.microsoft.com/en-us/cli/azure/acr)
- [Authenticate with an Azure container registry](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-authentication?tabs=azure-cli)
- [Configure App Service environment variables to authenticate to Azure Container Registry](https://learn.microsoft.com/en-us/azure/app-service/configure-custom-container?tabs=debian&pivots=container-linux#configure-environment-variables)
- [Configure an App Service](https://learn.microsoft.com/en-us/azure/app-service/configure-common?tabs=portal)

## Tips

- You can either provision a managed identity & grant it RBAC access to the ACR or use the ACR admin credentials to pull the Docker image from the ACR into App Service.
  - Using a managed identity is the recommended approach in production, but is more complex to set up initially (since you must have **Owner** access to your Resource Group)
  - Use the ACR admin account & `DOCKER_REGISTRY_SERVER_*` environment variables to pull the Docker image from the ACR into App Service.
- Set environment variables in App Service to configure the app to connect to the Azure SQL Database (similar to what you did in the `docker-compose.yaml` file). Values you set in the App Service Configuration section will override the values from the `appsettings.json` file.
- You may have to enable Azure services to communicate with your Azure SQL database
  - [Azure SQL DB Network Access Controls](https://learn.microsoft.com/en-us/azure/azure-sql/database/network-access-controls-overview?view=azuresql-db)
