# Challenge 0: Pre-requisites - Ready, Set, GO

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

A smart cloud architect always has the right tools in their toolbox.

## Description

In this challenge, we'll be setting up all the tools we will need to complete our challenges.

**Part 1: Pre-requisites**
- Install the recommended toolset:
  - An [Azure Subscription](https://azure.microsoft.com/free/)
  - _optional and not required_ [Windows Subsystem for Linux (Windows only)](https://learn.microsoft.com/windows/wsl/install)
  - [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
  - [Terraform](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/install-cli)
  - [Visual Studio Code](https://code.visualstudio.com/)
      - [Hashicorp Terraform extension for VS Code](https://marketplace.visualstudio.com/items?itemName=hashicorp.terraform)
      - [Azure Terraform extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azureterraform)


**Part 2: Hello World**

1. Start VSCode and open a terminal window.  Create a folder called 'hello-world' and cd into that folder.
2. Run `az login` to login to your Azure subscription.  You might be prompted to open a browser window to complete the login process.
3. Open a new window in VSCode, and paste the following code into it:  _(We're not going to explain this code yet, but we will in the next challenge.  The purpose of this exercise is to validate that your tools are all working)_
  
  ```hcl
  terraform {
    required_providers {
      azurerm = {
        source  = "hashicorp/azurerm"
        version = ">=3.0.0"
      }
    }
  }
  provider "azurerm" {
    features {}
  }
  resource "azurerm_resource_group" "rg" {
    name     = "hello-world" // change this if needed
    location = "eastus"
  }
  ```
4. Save the file as `main.tf` in the `hello-world` folder.
5. In the terminal window, run `terraform init` to initialize the Terraform environment.
6. Run `terraform plan` to see what Terraform will do.
7. Run `terraform apply` to apply the changes.  You will be prompted to confirm the changes.  Type `yes` and press enter.
8. Run `terraform show` to see the resources that were created.
9. Run `terraform destroy` to destroy the resources.  You will be prompted to confirm the changes.  Type `yes` and press enter.

## Success Criteria

1. Your 'hello-world' deployment is successful.
2. Visual Studio Code extensions are installed.
