# Challenge 06 - Build a CI/CD pipeline with Azure DevOps

[< Previous Challenge](./Challenge-05.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-07.md)

## Introduction

In a previous challenge we manually deployed the app on Azure. Now with this challenge you will be able to build an entire CI/CD pipeline with Azure DevOps.

## Description

- Create a Build definition with Azure Pipelines to build your Docker images and push it to your Azure Container Registry (ACR). Furthermore, enable the `Continuous Integration` feature for this Build definition.
- Create a Release definition with Azure Pipelines to run your images on your Azure Web App Service for Containers previously provisionned. Furthermore, enable the `Continuous Devivery` feature for the Release definition.
- Update one file on your `master` branch and commit this change, it should trigger automatically the Build and the Release definitions to deploy the new version of your app.
- Once deployed, test the app as an end-user, and play a game once deployed there.

## Success Criteria

To complete this challenge successfully, you should be able to:

- In Azure Cloud Shell, make sure `az webapp list` is showing your Azure services properly.
- In Azure Cloud Shell, make sure `az acr repository show-tags` is showing your new container image properly.
- In your web browser, navigate to the app and play a game, make sure it's working without any error and that your update is here.
- In Azure DevOps (Boards), from the Boards view, you could now drag and drop the user story associated to this Challenge to the `Resolved` or `Closed` column, congrats! ;)

## Learning Resources

- [Azure DevOps Pipelines](https://azure.microsoft.com/en-us/services/devops/pipelines/)
- [ACR Build task](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-tasks-overview)
- [Jenkins on Azure](https://docs.microsoft.com/en-us/azure/jenkins/)

## Tips

- [Deploy to an Azure Web App for Containers - Define your CI build pipeline](https://docs.microsoft.com/en-us/azure/devops/pipelines/apps/cd/deploy-docker-webapp?view=vsts#define-your-ci-build-pipeline)
- [Deploy to an Azure Web App for Containers - Create a release pipeline](https://docs.microsoft.com/en-us/azure/devops/pipelines/apps/cd/deploy-docker-webapp?view=vsts#create-a-release-pipeline)
