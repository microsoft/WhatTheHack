# Challenge 02 - Create a Hello World Function

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

Azure Functions are an integral part of a Serverless architecture.  Azure Functions allows you to run small pieces of code (called "functions") without worrying about application infrastructure. With Azure Functions, the cloud infrastructure provides all the up-to-date servers you need to keep your application running at scale.

## Description

- Create a "Hello World" Azure Function in Visual Studio Code that:
    - Takes a name as an input parameter.
    - Returns the name back to you as an output.
    - Use any programming language of your choice
- Deploy the function into a new Azure Function App
  
**NOTE:** The TollBooth application that you will work with for the rest of this hack uses C#. You may find it useful to understand how a basic "Hello World" Azure Function works in C# before you explore the TollBooth application's code. Optionally, you can also try a "Hello World" in JavaScript, which will be useful in Challenge 06.

**NOTE:** When using VS Code, the [Azure Functions extension for VS Code](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurefunctions&ssr=false#overview) can only work with one language stack at a time. IF you have Azure Functions authored in multiple languages, you will need to open a separate VS Code window to work with each language.

## Success Criteria

- Verify that you are able to open your function in a browser (you need the complete Function URL) and pass your name in the query string (i.e ?name=YourName). You should see a message like:
*`Hello, YourName. This HTTP triggered function executed successfully.`*
- Understand the basic parts of an Azure Function's code and how to publish it to an Azure Function App

## Learning Resources

- [Functions Overview](https://docs.microsoft.com/azure/azure-functions/functions-overview)
- [Quickstart: Create a C# function using Visual Studio Code](https://learn.microsoft.com/en-us/azure/azure-functions/create-first-function-vs-code-csharp#run-the-function-in-azure)
- [Quickstart: Create a JavaScript function using Visual Studio Code](https://learn.microsoft.com/en-us/azure/azure-functions/create-first-function-vs-code-node?pivots=nodejs-model-v4)
- Complete guide to develop functions on Visual Studio Code, [follow this advanced guide.](https://docs.microsoft.com/en-us/azure/azure-functions/functions-develop-vs-code?tabs=csharp)
- [How to get the Function URL via the Azure Portal](https://learn.microsoft.com/en-us/azure/azure-functions/functions-create-function-app-portal?pivots=programming-language-javascript#test-the-function)