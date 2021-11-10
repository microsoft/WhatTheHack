# Challenge 2 - Build and Deploy API Website - Coach's Guide

[< Previous Challenge](./Challenge01.md) - **[Home](README.md)** - [Next Challenge >](./Challenge03.md)

## Notes & Guidance

### Import Sql Database using bacpac file provided
- You can import a SQL Server database into Azure SQL Database or SQL Managed Instance using a BACPAC file. You can import the data from a BACPAC file stored in Azure Blob storage (standard storage only) or from local storage in an on-premises location. To maximize import speed by providing more and faster resources, scale your database to a higher service tier and compute size during the import process. You can then scale down after the import is successful.
  - [Steps for SQL Database import ](https://docs.microsoft.com/en-us/azure/azure-sql/database/database-import)


### Github Action for Azure Webapp


- Setup Dotnet build using Github Action [Dotnet build steps ](https://github.com/actions/setup-dotnet) 
- With the Azure App Service Actions for GitHub, you can automate your workflow to deploy [Azure Web Apps](https://azure.microsoft.com/services/app-service/web/)
- [Azure Web Apps for Containers](https://azure.microsoft.com/services/app-service/containers/) using GitHub Actions.
- GitHub Action for Azure WebApp to deploy to an Azure WebApp (Windows or Linux). The action supports deploying *\*.jar*, *\*.war*, and \**.zip* files, or a folder. You can also use this GitHub Action to deploy your customized image into an Azure WebApps container.
- For deploying container images to Kubernetes, consider using [Kubernetes deploy](https://github.com/Azure/k8s-deploy) action. This action requires that the cluster context be set earlier in the workflow by using either the [Azure/aks-set-context](https://github.com/Azure/aks-set-context/tree/releases/v1) action or the [Azure/k8s-set-context](https://github.com/Azure/k8s-set-context/tree/releases/v1) action.

## Solution 
- [Navigate to Solution for Challenge 02](./Solution/Challenge%2002/Solution02.yml)
