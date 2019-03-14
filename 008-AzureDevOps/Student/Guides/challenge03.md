# What the Hack: DevOps 

## Challenge 3 - Azure Repos: Introduction
[Back](challenge02.md) - [Home](../../readme.md) - [Next](challenge04.md)

### Introduction

1. [What is version control?](https://docs.microsoft.com/en-us/azure/devops/learn/git/what-is-version-control)
2. [What is Git?](https://docs.microsoft.com/en-us/azure/devops/learn/git/what-is-git)

### Challenge

1. When you created your project in Azure DevOps, it created a default repository for you in Azure Repos. Clone this repo to your local computer ([hint](https://code.visualstudio.com/Docs/editor/versioncontrol#_cloning-a-repository)).
2. Download the code for the applicaiton [here](https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/Microsoft/devops-project-samples/tree/master/dotnet/aspnetcore/containerWithTests&fileName=AzureDevOpsWhatTheHack&rootDirectory=AzureDevOpsWhatTheHack).
3. Unzip the download. You should see 2 folders. One containing the application and the other containing our Infrastructure as Code Azure Resource Manager (ARM) templates. Copy both of these folders into the root of your cloned repository. 
4. Check the files into Azure Repos using VS Code or your favorite Git client. **Be sure to include a # sign followed by the work item number for this challenge to the Git commit message.** For example: if you work item number is 55 your check in message should look like this  `init #55`



### Success Criteria

1. You should be able to go to the Azure DevOps site and under Azure Repos see your code. 
2. You should be able to go to the Azure DevOps site and under Azure Boards and when you open your work item you should see your code associated to it. 