# Challenge 3 - Build and Deploy Frontend Website - Coach's Guide

[< Previous Challenge](./Challenge02.md) - **[Home](README.md)** - [Next Challenge >](./Challenge04.md)

## Notes & Guidance

### Github Action for Azure Webapp


- Setup Dotnet build using Github Action [Dotnet build steps ](https://github.com/actions/setup-dotnet) 
- With the Azure App Service Actions for GitHub, you can automate your workflow to deploy [Azure Web Apps](https://azure.microsoft.com/services/app-service/web/)
- [Azure Web Apps for Containers](https://azure.microsoft.com/services/app-service/containers/) using GitHub Actions.
- GitHub Action for Azure WebApp to deploy to an Azure WebApp (Windows or Linux). The action supports deploying *\*.jar*, *\*.war*, and \**.zip* files, or a folder. You can also use this GitHub Action to deploy your customized image into an Azure WebApps container.
- For deploying container images to Kubernetes, consider using [Kubernetes deploy](https://github.com/Azure/k8s-deploy) action. This action requires that the cluster context be set earlier in the workflow by using either the [Azure/aks-set-context](https://github.com/Azure/aks-set-context/tree/releases/v1) action or the [Azure/k8s-set-context](https://github.com/Azure/k8s-set-context/tree/releases/v1) action.

## Solution 
- [Navigate to Solution for Challenge 03](./Solution/Challenge%2003/Solution03.yml)
