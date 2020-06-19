# Challenge 2 - Deploy a Virtual Network

[< Previous Challenge](./ARM-Challenge-01.md) - [Home](../readme.md) - [Next Challenge>](./ARM-Challenge-03.md)

## Introduction

This challenge has you add to the "hello world" template you created in the previous challenge. The goals for this challenge include understanding:
   + Parameters and Parameter Files
   + How to find syntax for an Azure resource and add it to the template

## Description

+	Extend the ARM template to provision a VNET w/one subnet 
    +	The template should take the following inputs: 
        +	Virtual Network Name and Address Prefix
        +	Subnet Name and Address Prefix
    +   Use a parameter file to pass in parameter values 

## Success Criteria

1. Verify that Virtual Network has been deployed in the portal
1. Verify that the Virtual Network is configured as per the parameter values passed in to the ARM template from the parameter file

## Learning Resources

Learn how to "fish" for ARM template resource syntax:

- [ARM Tools VS Code Extention](https://marketplace.visualstudio.com/items?itemName=msazurermtools.azurerm-vscode-tools)
- [ARM Template Reference docs](https://docs.microsoft.com/en-us/azure/templates)
- Export template from Azure Portal before resource creation
- Export template from Azure Portal of existing Resource Group deployment
- [Azure Quickstart Templates on GitHub](https://github.com/Azure/azure-quickstart-templates)