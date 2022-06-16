# Challenge 06 - Azure Pipelines: Continuous Delivery

[< Previous Challenge](./Challenge-05.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-07.md)

## Introduction

In DevOps after we automate our build process, we want to automate our release process, we do this with a technique called Continuous Delivery. Please take a moment to review this brief article talking about why this is important. 

1. [What is Continuous Delivery?](https://docs.microsoft.com/en-us/azure/devops/learn/what-is-continuous-delivery)

## Description

In Azure DevOps we use an Azure Pipeline to release our software. In this challenge we will deploy our container out to our dev, test, and prod environments. 

- Create a new Release Pipeline using the Azure App Service Deployment Template
- To start off our deployment will only have one stage, lets call it `dev`
- The output of our CI Build pipeline will be the input artifact to our CD Release pipeline, add it. 
- Enable Continuous deployment so that each time the CI pipeline finishes successfully, this pipeline will start. 
- If you look at the tasks for our `dev` stage you will see a single `Deploy Azure App Service` task, we just need to configure it. 
   - Select your subscription, a app service type of `Web App for Containers (Linux)`, point it at your dev instance, enter your registry name `<prefix>devopsreg.azurecr.io` (NOTE: here we need to fully qualify it), your image/repository name `<prefix>devopsimage`, and your tag `$(Build.BuildId)` (NOTE: here we are dynamically pulling the build number from Azure DevOps at run time)
- Manually kick off a release and check that your application got deployed to your dev instance. 
- If everything worked, go ahead and clone the `dev` stage two more times for `test` and `prod`.
   - The only change you need to make in the `test` and `prod` stages is pointing to the `test` and `prod` respectively. 
- For the test and prod stages, set a pre-deployment condition so that one of your teammates has to approve any deployment before it goes to production. 

## Success Criteria

1. Make a small change to your code (for example: update some fo the HTML on the Index page `/Application/aspnet-core-dotnet-core/Views/Home/Index.cshtml`), it should automatically trigger a build and release to your `dev` environment. If the change looks good, get your teammate to approve it to release to `test`. Repeat again for `prod`.
   
