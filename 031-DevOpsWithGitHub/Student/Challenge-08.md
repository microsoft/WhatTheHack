# Challenge 08 – Continuous Delivery (CD)

[< Previous Challenge](Challenge-07.md) - [Home](../README.md) - [Next Challenge >](Challenge-09.md)

## Introduction

In DevOps after we automate our build process, we want to automate our release process, we do this with a technique called Continuous Delivery (CD). Please take a moment to review this brief article talking about why this is important. 

- [What is Continuous Delivery?](https://docs.microsoft.com/en-us/azure/devops/learn/what-is-continuous-delivery)

## Description

In this challenge, we will use GitHub Actions to deploy our container image to the dev environment. 

**OPTIONAL**: Use your code editor (VS Code) to update your workflow file locally on your machine. Remember to commit and push any changes.

Extend the workflow you created in Challenge #7 to:

- Configure your `dev` environment to pull the latest container image from ACR. 
   - Login to Azure using your service principal, if needed ([hint](https://docs.microsoft.com/en-us/azure/app-service/deploy-container-github-action?tabs=service-principal#tabpanel_CeZOj-G++Q-3_service-principal))
   - Use the `Azure/webapps-deploy@v2` [action](https://github.com/Azure/webapps-deploy) to update the Web App to pull the latest image from ACR. Key parameters to configure:
      - `app-name` - the name of the wep app instance to target
      - `images` - the path to the image you pushed to ACR

- Make a small change to your application  (i.e.,`/Application/aspnet-core-dotnet-core/Views/Home/Index.cshtml`), commit, push, monitor the workflow and see if the change shows up on the dev instance of the website.

- Configure your workflow to deploy to your `test` and `prod` environments and after a manual approval for *each* environment.

## Success Criteria

1. A small change to `/Application/aspnet-core-dotnet-core/Views/Home/Index.cshtml` automatically shows up on the website running in the `dev` environment (i.e., `<prefix>devops-dev`.azurewebsites.net).
2. Manual approval is required to deploy to the `test` and `prod` environments.

## Learning Resources

- [Deploy a custom container to App Service using GitHub Actions](https://docs.microsoft.com/en-us/azure/app-service/deploy-container-github-action?tabs=service-principal#tabpanel_CeZOj-G++Q-3_service-principal)
- [Using environments for deployment](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment)

[< Previous Challenge](Challenge-07.md) - [Home](../README.md) - [Next Challenge >](Challenge-09.md)
