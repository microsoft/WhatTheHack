# Challenge 7 - Azure Container Apps (ACA) - Getting started

[< Previous Challenge](./Challenge-06.md) - [Home](../README.md) - [Next Challenge>](./Challenge-08.md)

## Introduction

In this challenge, you will work with [Azure Container Apps (ACA)](https://learn.microsoft.com/en-us/azure/container-apps/overview), which is a fully managed environment that enables you to run microservices and containerized applications.

Similar to Azure App Service, you will be deploying two components:

- A *Container Apps Environment*, which is the "plan" or "hosting" component of the service
- An *Azure Container App*, which is the application itself

It is recommended that you start fresh for this challenge and use a new set of Terraform resources (i.e., new folder) and also use a new Terraform state file (i.e., a new key)

## Description

In this challenge, you will accomplish the following tasks:

+ Deploy an [Azure Container Apps Environment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_environment) using Terraform.
    - You will be required to deploy a Log Analytics Workspace to support this ACA Environment
+ Deploy an [Azure Container App](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app) based on the "hello-world" container `mcr.microsoft.com/azuredocs/containerapps-helloworld:latest`
    - You will need to configure an ingress to be able to access this app from the outside (eg, Internet)
+ Define a Terraform output that shows the Container FQDN.

## Success Criteria

1. Verify you can view the web page hosted by the Azure Container App

