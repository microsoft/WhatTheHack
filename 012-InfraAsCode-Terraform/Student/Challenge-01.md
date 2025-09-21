# Challenge 1 - Basic Terraform

 [< Previous Challenge](./Challenge-00.md) - [Home](../README.md) - [Next Challenge >](./Challenge-02.md)

## Pre-requisites

Make sure your machine is set up with the proper tooling: [Prerequisites](./Challenge-00.md)

## Introduction

The goals for this challenge include understanding:

- Understanding Terraform basics:  init, plan, apply, and state
- Setting up Terraform authentication with Azure
- How to author Terraform manifests using HCL

In this challenge, you will create a simple Terraform manifest and deploy it to Azure.  You will save Terraform state in an Azure Storage account

## Description 

### Part 1: Prepare to store Terraform State in Azure Storage

Using the az cli, prepare an Azure storage account which will hold your terraform state

**Learning Resources**
* [Store Terraform state in Azure Storage](https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli) 

### Part 2: Author a Terraform manifest that creates an Azure Storage Account

Author a Terraform manifest that creates an Azure Storage Account, and returns the required outputs.  The manifest(s):

- Must save Terraform state in the storage account created in part 1
- Must take inputs 1) `location` (eg, Azure region) 2) Resource group name 3) unique storage account name
- Must supply the required inputs via a _tfvars_ file
- The output must return the storage account id

## Success Criteria

1. Must meet above requirements and be able to demonstrate a full Terraform plan/apply sequence

## Learning Resources

- [Maintaining state using the `azurerm` (Azure storage) backend](https://developer.hashicorp.com/terraform/language/settings/backends/azurerm)
- [Azurerm Documentation (from Hashicorp)](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Terraform on Azure (from Microsoft)](https://learn.microsoft.com/en-us/azure/developer/terraform/)
- [Authenticating using the Azure cli](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli)
- [Terraform Language Documentation](https://developer.hashicorp.com/terraform/language)
- [Terraform Variables](https://developer.hashicorp.com/terraform/language/values/variables)
