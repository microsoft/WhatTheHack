# Challenge 7 - Build a CI/CD pipeline with Azure DevOps

## Prerequisities

1. [Challenge 4 - Run the app on Azure](./RunOnAzure.md) should be done successfully.

## Introduction

In a previous challenge we manually deployed the app on Azure. Now with this challenge you will be able to build an entire CI/CD pipeline with Azure DevOps.

## Challenges

1. Create a Build definition with Azure Pipelines to build your Docker images and push it to your Azure Container Registry (ACR). Furthermore, enable the `Continuous Integration` feature for this Build definition.
1. Create a Release definition with Azure Pipelines to run your images on your Azure Web App Service for Containers previously provisionned. Furthermore, enable the `Continuous Devivery` feature for the Release definition.
1. Update one file on your `master` branch and commit this change, it should trigger automatically the Build and the Release definitions to deploy the new version of your app.
1. Once deployed, test the app as an end-user, and play a game once deployed there.

## Success criteria

1. In Azure Cloud Shell, make sure `az webapp list` is showing your Azure services properly.
1. In Azure Cloud Shell, make sure `az acr repository show-tags` is showing your new container image properly.
1. In your web browser, navigate to the app and play a game, make sure it's working without any error and that your update is here.
1. In Azure DevOps (Boards), from the Boards view, you could now drag and drop the user story associated to this Challenge to the `Resolved` or `Closed` column, congrats! ;)

## Tips

1. [Deploy to an Azure Web App for Containers - Define your CI build pipeline](https://docs.microsoft.com/en-us/azure/devops/pipelines/apps/cd/deploy-docker-webapp?view=vsts#define-your-ci-build-pipeline)
1. [Deploy to an Azure Web App for Containers - Create a release pipeline](https://docs.microsoft.com/en-us/azure/devops/pipelines/apps/cd/deploy-docker-webapp?view=vsts#create-a-release-pipeline) 

## Advanced challenges

Too comfortable? Eager to do more? Try this:

1. Instead of using the graphical definition of your Azure Pipelines (Builds), you could use the [YAML file definition](https://docs.microsoft.com/en-us/azure/devops/pipelines/yaml-schema?view=vsts).
1. Instead of building your containers images on the VSTS Hosted agent, you could use the [Azure Container Registry (ACR) Build Task feature](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-tasks-overview).
1. Instead of leveraging Azure Pipelines (Builds) for buidling your containers images, you could use [Jenkins and generate an artifact as input of the Azure Pipelines (Releases) definition](https://docs.microsoft.com/en-us/azure/devops/pipelines/release/artifacts?view=vsts#jenkins).

## Learning resources

- [Azure DevOps Pipelines](https://azure.microsoft.com/en-us/services/devops/pipelines/)
- [ACR Build task](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-tasks-overview)
- [Jenkins on Azure](https://docs.microsoft.com/en-us/azure/jenkins/)

[Next challenge (Implement Azure AD B2C) >](./ImplementAADB2C.md)