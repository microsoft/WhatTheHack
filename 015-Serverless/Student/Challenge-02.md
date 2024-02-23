# Challenge 02 - Create a Hello World Function

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

Azure Functions are an integral part of a Serverless architecture.  Azure Functions allows you to run small pieces of code (called "functions") without worrying about application infrastructure. With Azure Functions, the cloud infrastructure provides all the up-to-date servers you need to keep your application running at scale.

## Description

- Create a "Hello World" Azure Function in Visual Studio Code that:
    - Takes a name as an input parameter.
    - Returns the name back to you as an output.
    - Use any programming language of your choice
  
**NOTE:** The TollBooth application that you will work with for the rest of this hack uses C#. You may find it useful to understand how a basic "Hello World" Azure Function works in C# before you explore the TollBooth application's code.

## Success Criteria

1. Verify that you are able to open your function in a browser and pass your name in the query string.  You should see a message like:
*`Hello, YourName. This HTTP triggered function executed successfully.`*
1. Understand the basic parts of an Azure Function's code and how to publish it to Azure

## Learning Resources

- [Functions Overview](https://docs.microsoft.com/azure/azure-functions/functions-overview)
- To setup Azure Functions on Visual Studio Code, [follow this guide.](https://docs.microsoft.com/en-us/azure/azure-functions/functions-develop-vs-code?tabs=csharp)
