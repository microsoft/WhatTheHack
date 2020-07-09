# What the Hack: DevOps 

## Challenge 3 - Azure Repos: Introduction
[Back](challenge02.md) - [Home](../readme.md) - [Next](challenge04.md)

### Introduction

Historically version control has been the first component that teams have implemented, it is one of the oldest and most well understood components of DevOps. Please take a moment to review the basics of version control, specially focusing on the distributed version control technology, Git.

1. [What is version control?](https://docs.microsoft.com/en-us/azure/devops/learn/git/what-is-version-control)
2. [What is Git?](https://docs.microsoft.com/en-us/azure/devops/learn/git/what-is-git)

### Challenge

Now that we have a basic understanding of version control and Git, lets get some code checked into source control. Since the language you use for development doesn’t have much of an impact on how we do DevOps we have provided you a simple ASP.NET Core C# web application to use. 

1. When you created your project in Azure DevOps, it created a default repository for you in Azure Repos. Clone this repo to your local computer ([hint](https://code.visualstudio.com/Docs/editor/versioncontrol#_cloning-a-repository)).
2. Download the code for the application [here](https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/Microsoft/WhatTheHack/tree/master/010-AzureDevOps/Student/Resources/Code&fileName=AzureDevOpsWhatTheHack&rootDirectory=AzureDevOpsWhatTheHack).
3. Unzip the download. You should see 2 folders. One containing the application and the other containing our Infrastructure as Code Azure Resource Manager (ARM) template. Copy both of these folders into the root of your cloned repository. 
4. Commit and Push the files into Azure Repos using VS Code or your favorite Git client ([hint](https://docs.microsoft.com/en-us/azure/devops/user-guide/code-with-git?view=azure-devops)). **Be sure to include a # sign followed by the work item number for this challenge to the Git commit message.** For example: lets say you want to use the checkin comment `my first checkin` and your work item number is 55 your, you can  check in message should look like this  `my first checkin #55`.

### Success Criteria

1. You should be able to go to the Azure DevOps site and under Azure Repos see your code. 
2. You should be able to go to the Azure DevOps site and under Azure Boards and when you open your work item you should see your code associated to it. HINT: look in the "development" section on the work item. Why would it be important to be able to link a code change to the work item that it addresses? 

[Back](challenge02.md) - [Home](../readme.md) - [Next](challenge04.md)