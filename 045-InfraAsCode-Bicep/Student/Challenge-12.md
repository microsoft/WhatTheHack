# Challenge 12 - Deploy an Azure App Service

[< Previous Challenge](./Challenge-11.md) - [Home](../README.md) - [Next Challenge >](./Challenge-13.md)

## Introduction

The goals of this challenge include understanding:

- How to deploy Azure App Service plan and App Service website using Bicep.
- How to leverage Azure App Service source code integration to automatically deploy a sample app from GitHub.

## Description

This challenge is all about [Azure App Service](https://learn.microsoft.com/azure/app-service/overview). During the challenge, you will use Bicep to create an Azure App Service Plan and App Service website.

- Provision an Azure App Service, using a Linux web app with `linuxFxVersion` set to `NODE|14-LTS`
- Within the App Service, deploy the application found at the url `https://github.com/Azure-Samples/nodejs-docs-hello-world`
  - _hint: use this with the `repoUrl` parameter_

## Success Criteria

- Demonstrate that your application is running by launching the website in your browser
  - show `https://<sitename>`
  - show `https://<sitename>/api`
  - show `https://<sitename>/api/accounts/jondoe`

## Learning Resources

- Bicep resource definitions:
  - [Microsoft.Web serverfarms](https://learn.microsoft.com/azure/templates/microsoft.web/serverfarms?pivots=deployment-language-bicep)
  - [Microsoft.Web sites](https://learn.microsoft.com/azure/templates/microsoft.web/sites?pivots=deployment-language-bicep)
  - [Microsoft.Web sites/sourcecontrols](https://learn.microsoft.com/azure/templates/microsoft.web/sites/sourcecontrols?pivots=deployment-language-bicep)
