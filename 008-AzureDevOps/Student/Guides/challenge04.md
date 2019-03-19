# What the Hack: DevOps 

## Challenge 4 – Azure Pipelines: Continuous Integration
[Back](challenge03.md) - [Home](../../readme.md) - [Next](challenge05.md)

### Introduction

1. [What is Continuous Integration?](https://docs.microsoft.com/en-us/azure/devops/learn/what-is-continuous-integration)


### Challenge

The build process will not only compile our .NET Core applicaiton, it should package it into a Docker Container and publish the container to Azure Container Registry.

1. Create a build pipeline using the **ASP.NET Core** template ([hint](https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started-designer?view=azure-devops&tabs=new-nav#create-a-build-pipeline))
2. Enable continous intergration on your build pipeline ([hint](https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started-designer?view=azure-devops&tabs=new-nav#enable-continuous-integration-ci))
3. In our ArmTemplates folder you will find an templated called `containerRegistry-template.json`. Examine this file in VS Code. What does it do? What parameters does the template expect?
4. Add a **Azure Resource Group Deployment** task as the first step in your pipeline to execute this ARM template and configure its properties.
5. Review the 4 .NET Core build tasks that were added to our build pipeline by default. These are the 4 major steps to building a .NET Core applicaiton ([Hint](https://docs.microsoft.com/en-us/azure/devops/pipelines/languages/dotnet-core?view=azure-devops&tabs=designer)).
   1. First we call the `restore` command, this will get all the dependencies that our .net core applicaiton needs to compile
   2. Next we call the `build` command, this will actually compile our code
   3. Next we call the `test` command, this should execute all our unit tests in the `**/*UnitTests/*.csproj` folder path. HINT: the template links this task setting to a pipeline setting that will need to be updated to mach the folder structure of our code.
   4. The last .NET Core build task in the template is to `publish` the .net core app. The template publishes the application to a zip file, we dont want it zipped so undo this setting. Additionally, change the output argument to here `$(System.DefaultWorkingDirectory)/PublishedWebApp` 
6. Now that our .NET core applicaiton is compiled and all the unit tests have been run, we need to package it into a Docker Container and publish the container to Azure Container Registry, to do this we are going to add 2 docker tasks to our build pipeline, before we publish the build artifiact.
   1. Build the Docker Image ([Hint](https://docs.microsoft.com/en-us/azure/devops/pipelines/languages/docker?view=azure-devops&tabs=designer#build-an-image)).
      1. You named your Azure Container Registry in a parameter you sent to the ARM template earlier, however this time fully qualify it by adding `.azurecr.io` to the end.
      2. You did not build your app into the default build context, you did it here `$(System.DefaultWorkingDirectory)/PublishedWebApp`
   2. Push the Docker Image ([Hint](https://docs.microsoft.com/en-us/azure/devops/pipelines/languages/docker?view=azure-devops&tabs=designer#push-an-image))
      1. In the last step you just put the fully qualified name of your Azure Container Registry, in this step you will need is full locaiton, not just its name. However since it has not been created yet, since we have not executed our ARM template yet, you cannot use the designer to look it up. Use this string, replacing values as approperate `{"loginServer":"<<your ACR>>.azurecr.io", "id" : "/subscriptions/<<the GUID of your subscription>>/resourceGroups/<<the name of the resource group your ACR is in>>/Microsoft.ContainerRegistry/registries/<<your ACR>>"}`
7. Last thing we need to add before we publish, is to copy our ArmTemplates to the `$(build.artifactstagingdirectory)` directory using a `copy files` task, this will ensure that our Continuous Delivery pipeline.


### Success Criteria

1. Your build should complete without any errors.
2. Review the test results genterated by your build. HINT: look in the logs from your build to find where the test run was published. 
3. Using the Auzre Portal or CLI you should see your container in your Azure Container Registry Repository

[Back](challenge03.md) - [Home](../../readme.md) - [Next](challenge05.md)
