# Challenge 01 - Basic Bicep

 [< Previous Challenge](./Challenge-00.md) - [Home](../README.md) - [Next Challenge >](./Challenge-02.md)

## Pre-requisites

Make sure your machine is set up with the proper tooling as defined in [Challenge 00](./Challenge-00.md)

## Introduction

The goals for this challenge include understanding:

- Why Bicep is an improvement over the older JSON ARM template language
- How Bicep works
- How to write Bicep ARM templates

ARM templates using JSON are very powerful and provide a lot of functionality. However, they can be hard to learn and can be difficult to work with.

Bicep is the newest language for authoring infrastructure-as-code templates for Azure. Unlike JSON, it's not a general-purpose file format. It's designed specifically for deploying resources into Azure. Its goal is to be a clean, readable language.

Bicep templates are transpiled into standard JSON ARM templates in a similar way to how TypeScript is transpiled into JavaScript. This conversion happens automatically when using the Azure CLI, but it can also be called directly using the Bicep CLI.

Your first challenge is to create a simple Bicep file that takes an input storage account name to create an Azure Storage Account and returns an output storage account id. The goals here are to understand:

- Core elements of a Bicep file and different ways to deploy it.
- How and where to see and troubleshoot deployments in the Portal.

## Description

Develop a simple Bicep file that takes inputs to create an Azure Storage Account and returns an output.

- Create a simple Bicep file
- The file must take inputs: location and a unique storage account name
- The output must return a storage account id
- Deploy it using the Azure CLI _and/or_ Deploy it using the Azure PowerShell Cmdlets
- Observe the deployment in the Azure Portal

## Success Criteria

1. You can deploy Bicep file using the Az CLI and/or PowerShell
1. You can view the deployment in the Azure Portal and view the inputs and outputs

## Learning Resources

- [Bicep Definitions for a Storage Account](https://learn.microsoft.com/en-us/azure/templates/microsoft.storage/storageaccounts?pivots=deployment-language-bicep)
