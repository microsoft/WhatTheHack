# Challenge \#0 - Prepare Your Environment for B2C

**[Home](../README.md)** - [Next Challenge>](./01-provision-b2c.md)

## Introduction

A smart cloud solution architect always has the right tools in their toolbox.

## Description

In this challenge we'll be setting up all the tools we will need to complete our challenges.

- If applicable, make sure that you have joined the Teams group for this track. The first person on your team at your table should create a new channel in this Team with your team name.
- Install the recommended toolset:
  - [Azure Subscription](#azure-subscription)
  - [Visual Studio Code](#visual-studio-code)
    - [Visual Studio Code plugins for B2C](#visual-studio-code-plugins-for-arm-templates)
  - [.NET Core 3.1 SDK](https://dotnet.microsoft.com/download/dotnet/3.1)
  - [Managing Cloud Resources](#managing-cloud-resources)
    - [Azure Portal](#azure-portal)
- Locate and download the `Resources.zip` file found in the Files tab of your Teams channel. There are four folders in the zip file, each containing different resources that you will use in various challenges:
  - `/HarnessApp` contains an ASPNETCORE MVC application that will be used to test our various User Flows and Custom Policies. You will need this starting in Challenge 4.
  - `/MSGraphApp` contains a DOTNETCORE Console application that will be used to query your B2C tenant. You will need this in Challenge 7.
  - `/PageTemplates` contains various HTML/CSS/JS files that you will use to customize your Sign Up, Sign In, and Edit Profile User Flows. You will use these in Challenge 4.
  - `/Verify-inator` contains an ASPNETCORE Web Api application that will be used to validate user attributes from your Sign Up User Flow. You will need this in Challenge 5.

## Azure Subscription

You will need an Azure subscription to complete this hackathon. If you don't have one...

[Sign Up for Azure HERE](https://azure.microsoft.com/en-us/free/)

Our goal in the hackathon is limiting the cost of using Azure services.

If you've never used Azure, you will get:

- \$200 free credits for use for up to 30 days
- 12 months of popular free services (includes storage, Linux VMs)
- Then there are services that are free up to a certain quota

Details can be found here on [free services](https://azure.microsoft.com/en-us/free/).

If you have used Azure before, we will still try to limit cost of services by suspending, shutting down services, or destroy services before end of the hackathon. You will still be able to use the free services (up to their quotas) like App Service, or Functions.

## Visual Studio Code

Visual Studio Code is a lightweight but powerful source code editor which runs on your desktop and is available for Windows, macOS and Linux. It comes with built-in support for JavaScript, TypeScript and Node.js and has a rich ecosystem of extensions for other languages (such as C++, C#, Java, Python, PHP, Go) and runtimes (such as .NET and Unity).

[Install Visual Studio Code](https://code.visualstudio.com/)

VS Code runs on Windows, Mac, and Linux. It's a quick install, NOT a 2 hour install like its namesake full-fledged IDE on Windows.

### Visual Studio Code plugin for B2C

The Azure AD B2C extension for VS Code lets you quickly navigate through Azure AD B2C custom policies. Create elements like technical profiles and claim definitions. For more information, see Get started with custom policies.

[B2C Tools Plugin](https://marketplace.visualstudio.com/items?itemName=AzureADB2CTools.aadb2c)

## Managing Cloud Resources

We can manage cloud resources via the following ways:

- Web Interface/Dashboard
  - [Azure Portal](https://portal.azure.com/)

### Azure Portal

Build, manage, and monitor everything from simple web apps to complex cloud applications in a single, unified console.

Manage your resources via a web interface (i.e. GUI) at [https://portal.azure.com/](https://portal.azure.com/)

The Azure Portal is a great tool for quick prototyping, proof of concepts, and testing things out in Azure by deploying resources manually. However, when deploying production resources to Azure, it is highly recommended that you use an automation tool, templates, or scripts instead of the portal.
