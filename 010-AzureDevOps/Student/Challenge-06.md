# Challenge 06 - Azure Pipelines: Continuous Delivery

[< Previous Challenge](./Challenge-05.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-07.md)

## Introduction

In DevOps after we automate our build process, we want to automate our release process, we do this with a technique called Continuous Delivery. Please take a moment to review this brief article talking about why this is important. 

1. [What is Continuous Delivery?](https://docs.microsoft.com/en-us/azure/devops/learn/what-is-continuous-delivery)

## Description

In Azure DevOps we use an Azure Pipeline to release our software. In this challenge we will deploy our container out to our dev, test, and prod environments. 

- Continue using our CI Build pipeline, we will add our release to this pipeline.
- Leverage the Azure App Service Deploy task in the assistant to deploy your application.  We will be deploying our application using the images we pushed to the Azure Container Registry.
- If your deployment look good, go ahead and create the deployment for test and prod as well.
- For the test and prod stages, set a pre-deployment condition so that one of your teammates has to approve any deployment before it goes to production. 

## Success Criteria

1. Make a small change to your code (for example: update some of the HTML on the Index page `/Application/aspnet-core-dotnet-core/Views/Home/Index.cshtml`), it should automatically trigger a build and release to your `dev` environment. If the change looks good, get your teammate to approve it to release to `test`. Repeat again for `prod`.
   
### Learning Resources

1. [Azure DevOps Stages](https://learn.microsoft.com/en-us/azure/devops/pipelines/process/stages?view=azure-devops&tabs=yaml)
1. [Azure DevOps Environments](https://learn.microsoft.com/en-us/azure/devops/pipelines/process/environments?view=azure-devops)
