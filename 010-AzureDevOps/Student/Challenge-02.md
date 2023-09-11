# Challenge 02 - Azure Repos: Introduction

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

Historically version control has been the first component that teams have implemented, it is one of the oldest and most well understood components of DevOps. Please take a moment to review the basics of version control, specially focusing on the distributed version control technology, Git.

1. [What is version control?](https://docs.microsoft.com/en-us/azure/devops/learn/git/what-is-version-control)
2. [What is Git?](https://docs.microsoft.com/en-us/azure/devops/learn/git/what-is-git)

## Description

Now that we have a basic understanding of version control and Git, let's get some code checked into source control. Since the language you use for development doesn’t have much of an impact on how we do DevOps we have provided you a simple ASP.NET Core C# web application to use. 

- When you created your project in Azure DevOps, it created a default repository for you in Azure Repos. Clone this repo to your local computer ([hint](https://code.visualstudio.com/Docs/editor/versioncontrol#_cloning-a-repository)).
- Your coach will provide you with a `Resources.zip` file that contains the code and ARM templates for the application.
- Unzip the `Resources.zip` file provided to you by your coach. You should see 2 folders: one containing the application and the other containing our Infrastructure as Code Azure Resource Manager (ARM) template. Copy both of these folders into the root of your cloned repository. 
- Commit and Push the files into Azure Repos using VS Code or your favorite Git client ([hint](https://docs.microsoft.com/en-us/azure/devops/user-guide/code-with-git?view=azure-devops)). **Be sure to include a # sign followed by the work item number for this challenge to the Git commit message.** For example: let's say you want to use the checkin comment `my first checkin` and your work item number is 55, your check in message should look like this  `my first checkin #55`.

## Success Criteria

1. You should be able to go to the Azure DevOps site and under Azure Repos see your code. 
2. You should be able to go to the Azure DevOps site and under Azure Boards and when you open your work item you should see your code associated to it. HINT: look in the "development" section on the work item. Why would it be important to be able to link a code change to the work item that it addresses? 
