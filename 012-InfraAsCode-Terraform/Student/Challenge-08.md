# Challenge 8 - Advanced Azure Container Apps (ACA)

[< Previous Challenge](./Challenge-07.md) - [Home](../README.md) 

## Introduction
In the prior challenge, we ran a very simple example of using ACA to host a hello-world app.

In this challenge, we will expand on what we learned, and host a more complex three-tier application, exploring more capabilities of Azure Container Apps as well as Azure Container registry.  This will mimic a real-world scenario where you are converting an imperative deployment script using the az cli to a set of declarative Terraform manifests.

We will also explore the Terraform concept of "layered state files", where shared infrastructure components are deployed and managed separately from your application workloads

## Description

**Part 1**:  In this first part of this challenge, we are going to deploy an Azure Container Registry (ACR) and import some images to it.  This ACR will be governed using a separate state file from the one we've been using for our other resources.  This is a common pattern in Terraform, where you have shared infrastructure components that are deployed and managed separately from your application workloads.

First, create a new sub-folder within your working directory (e.g., `acr`) and cd into it.  This will be used to host the code for your ACR definition.

Next, within this folder, create the appropriate Terraform manifest definitions to deploy an [Azure Container Registry (ACR)](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry).
+ Deploy this to a different state file!  You can use the existing Storage Account and Blob Container, but use a (new) different key from your existing state file.  This will allow you to manage the ACR separately from the rest of your resources.
+ Be sure to enable the Admin user on the ACR.  You will need this for part 2.

We also need to import two container images into our ACR.  There's no "official" way to do this using the standard Terraform `azurerm` provider, so we are providing you a pre-authored module to use in your manifest.  Add the following code to your manifest:


```hcl
variable "imagenames" {
  type = list(string)
  default = [ "erjosito/yadaweb:1.0", "erjosito/yadaapi:1.0" ]
}
module "importimage" {
  count = length(var.imagenames)
  source = "github.com/microsoft/WhatTheHack/012-InfraAsCode-Terraform/modules/importimage"

  imagename = var.imagenames[count.index]
  acrid = azurerm_container_registry.acr.id // replace this with a reference to your ACR definition
}
```

***Success Criteria***:  Verify that the ACR is deployed and that the images are imported.  You can do this by logging into the Azure Portal and navigating to the ACR resource.  You should see the images listed under the Repositories section.

**Part 2**:  Next, we will deploy a two-tier application to Azure Container Apps.  This application will consist of a frontend web application, a backend API, and a SQL database.  The application can be found in [this Github repo](https://github.com/microsoft/YADA).  Specifically, there is already a script, available [here](https://github.com/microsoft/YADA/blob/main/deploy/ACA.md), that will deploy the application to Azure Container Apps.  Your job is to take this example script and create a set of Terraform deployment manifests to deploy the application to your ACA environment.

![Topology](https://github.com/microsoft/YADA/raw/main/web/app_arch.orig.png)

Steps / Hints / Things to be aware of: 

+ Be sure you are using a different Terraform state file than you used in Part 1. Be sure you have cd'd out of the `acr` folder and are back in the root of your current working directory.
+ Similar to the previous challenge (07), you'll need to create an [Azure Container Apps Environment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_environment) using Terraform (and don't forget to deploy a Log Analytics Workspace to support this ACA Environment)
+ Deploy two [Azure Container Apps](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app) from the container registry you created in the previous step.  
    - You will need to configure an ingress to be able to access the web app from the Internet
    - The API app should not be accessible from outside of the environment.
    - You will need to appropriately set the environment variables for each app.  Be sure to review the existing script to understand which variables need to be defined and be sure to review the hint below for the syntax of how to define environment variables in Terraform.  Also, review the readme page for each of the apps:
      - [YADA Web](https://github.com/microsoft/YADA/blob/main/web/README.md)
      - [YADA API](https://github.com/microsoft/YADA/blob/main/api/README.md)
    - For your ACA app to be able to pull the images from your ACR, you will need to reference the ACR's adminuser & password in your container app definition.  To do this, you will need to define the ACR as a Terraform `data` source.  See [this example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/container_registry) for more details.

+ Deploy an  [Azure SQL Server and an Azure SQL Database](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database) to support the application.
    - Use the Terraform Random Password provider to generate a password for the SQL Server.
    - Be sure to configure a set of firewall rules to allow access from the ACA Environment.  _Hint: You'll need to reference the outbound ip address of your API app_


Hint:  To define environment variables within the ACA definition in Terraform, you can use the following syntax:  _(The Terraform docs are not very clear on how to use multiple env variables, so we are providing this hint to help you)_

```hcl
  template {
    container {
      env {
        name  = "variable1"
        value = "value1"
      }
      env {
        name  = "variable2"
        value = "value2"
      }
      [...]
    }
  }
```

## Success Criteria

1. You can use your browser to access the web application.
2. The web application can successfully connect to the API.  You can verify this by ensuring that the first block of text shows:
  - Healthcheck: OK
  - Shows the SQL version, eg `SQL Server version: Microsoft SQL Azure (RTM) - 12.0.2000.8 Mar 8 2023 17:58:50 Copyright (C) 2022 Microsoft Corporation`
  - Shows connectivity info for application tier
3. API tier is not accessible from the Internet.

Note that the links under `Direct Access to API` will not work. You would need to deploy an App Gateway to route those URIs properly.


