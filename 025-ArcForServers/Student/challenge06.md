# What the Hack: DevOps 

## Challenge 6 – Azure Pipelines: Continuous Delivery
[Back](challenge05.md) - [Home](../readme.md) - [Next](challenge07.md)

### Introduction

In DevOps after we automate our build process, we want to automate our release process, we do this with a technique called Continuous Delivery. Please take a moment to review this brief article talking about why this is important. 

1. [What is Continuous Delivery?](https://docs.microsoft.com/en-us/azure/devops/learn/what-is-continuous-delivery)

### Challenge

In Azure DevOps we use an Azure Pipeline to release our software. In this challenge we will deploy our container out to our dev, test, and prod environments. 

1. Create a new Release Pipeline using the Azure App Service Deployment Template
2. To start off our deployment will only have one stage, lets call it `dev`
3. The output of our CI Build pipeline will be the input artifact to our CD Release pipeline, add it. 
4. Enable Continuous deployment so that each time the CI pipeline finishes successfully, this pipeline will start. 
5. If you look at the tasks for our `dev` stage you will see a single `Deploy Azure App Service` task, we just need to configure it. 
   1. Select your subscription, a app service type of `Web App for Containers (Linux)`, point it at your dev instance, enter your registry name `<prefix>devopsreg.azurecr.io` (NOTE: here we need to fully qualify it), your image/repository name `<prefix>devopsimage`, and your tag `$(Build.BuildId)` (NOTE: here we are dynamically pulling the build number from Azure DevOps at run time)
6. Manually kick off a release and check that your application got deployed to your dev instance. 
7. If everything worked, go ahead and clone the `dev` stage two more times for `test` and `prod`.
   1. The only change you need to make in the `test` and `prod` stages is pointing to the `test` and `prod` respectively. 
8. For the test and prod stages, set a pre-deployment condition so that one of your teammates has to approve any deployment before it goes to production. 

### Success Criteria

1. Make a small change to your code (for example: update some fo the HTML on the Index page `/Application/aspnet-core-dotnet-core/Views/Home/Index.cshtml`), it should automatically trigger a build and release to your `dev` environment. If the change looks good, get your teammate to approve it to release to `test`. Repeat again for `prod`.
   
[Back](challenge05.md) - [Home](../readme.md) - [Next](challenge07.md)
