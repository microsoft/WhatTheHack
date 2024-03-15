# Challenge 02 - Create a Hello World Function

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

Azure Functions are an integral part of a Serverless architecture.  Azure Functions allows you to run small pieces of code (called "functions") without worrying about application infrastructure. With Azure Functions, the cloud infrastructure provides all the up-to-date servers you need to keep your application running at scale.

The goals of this challenge are to get you familiar with the both the developer tools experience for creating a function, and the Azure Portal experience managing how that function is deployed in Azure.

## Description

You can develop, test, and debug an Azure Function using developer tools that simulate the Azure hosting environment on your workstation (or GitHub Codespace). Once a function's code has been developed and tested locally, it can be published to Azure in a compute resource called a "Function App".  A "Function App" in Azure is a hosting environment where your function code will be published to and made available to be invoked by other processes.

- Create a "Hello World" Azure Function in Visual Studio Code that:
    - Uses an HTTP Trigger
    - Returns "`Hello <YourName>!`" as an output (with your actual name in place of `<YourName>`)
    - Use any programming language of your choice.
- Build & Test your sample application locally (or in your GitHub Codespace) by invoking it from a web browser
- Deploy the function into a new Azure Function App in Azure and test it using its public URL
  
**NOTE:** The TollBooth application that you will work with for the rest of this hack uses C#. You may find it useful to understand how a basic "Hello World" Azure Function works in C# before you explore the TollBooth application's code. Optionally, you can also try a "Hello World" in JavaScript, which will be useful in Challenge 06.

**NOTE:** It is easier to create & manage Azure Functions if you have VS Code "Open Folder" to the folder where you want to the code to live. This is because when using VS Code, the [Azure Functions extension for VS Code](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurefunctions&ssr=false#overview) can only work with one language stack at a time. If you have Azure Functions authored in multiple languages and/or folders, you will need to open a separate VS Code window to the individual folder to work with each language.

**NOTE:** An empty folder "`HelloWorld`" is provided with the Resources package (and GitHub Codespace), you can use it to create your new Functions project workspace, or create a new empty folder.

### Navigating Folders with VS Code on GitHub Codespaces

When using VS Code in GitHub Codespaces, you can navigate to other folders and open them by:
- Selecting `Open Folder` from the "hamburger menu" in the upper left corner of the VS Code window.
- Navigate to the folder from the drop down that appears at the top of the VS Code window and click "OK".
- The Codespace will re-load in the browser, with VS Code opened to the folder you chose.

## Success Criteria

- Verify that you are able to open your function in a browser (you need the complete Function URL). You should see a message like:
*`Hello, YourName!`*
- Understand the basic parts of an Azure Function's code and how to publish it to an Azure Function App in Azure

## Learning Resources

- [Functions Overview](https://docs.microsoft.com/azure/azure-functions/functions-overview)
- [Quickstart: Create a C# function using Visual Studio Code](https://learn.microsoft.com/en-us/azure/azure-functions/create-first-function-vs-code-csharp)
- [Quickstart: Create a JavaScript function using Visual Studio Code](https://learn.microsoft.com/en-us/azure/azure-functions/create-first-function-vs-code-node?pivots=nodejs-model-v4)
- Complete guide to develop functions on Visual Studio Code, [follow this advanced guide.](https://docs.microsoft.com/en-us/azure/azure-functions/functions-develop-vs-code?tabs=csharp)
- [How to get the Function URL via the Azure Portal](https://learn.microsoft.com/en-us/azure/azure-functions/functions-create-function-app-portal?pivots=programming-language-javascript#test-the-function)
