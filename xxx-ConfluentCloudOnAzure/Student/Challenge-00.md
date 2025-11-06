# Challenge 00 - Prerequisites, Sizing & Capacity Planning

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

Thank you for participating in the Confluent on Azure What The Hack. Before you can hack, you will need to set up some prerequisites.

## Common Prerequisites

We have compiled a list of common tools and software that will come in handy to complete most What The Hack Azure-based hacks!

You might not need all of them for the hack you are participating in. However, if you work with Azure on a regular basis, these are all things you should consider having in your toolbox.

- [Azure Subscription](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-subscription)
- [Azure Portal](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-portal)
- [Azure CLI](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cli)
- [Note for Windows Users](../../000-HowToHack/WTH-Common-Prerequisites.md#note-for-windows-users)
- [Azure PowerShell CmdLets](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-powershell-cmdlets)
- [Azure Cloud Shell](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cloud-shell)
- [Visual Studio Code](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code)
- [VS Code plugin for ARM Templates](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code-plugins-for-arm-templates)
- [Azure Storage Explorer](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-storage-explorer)

## Background Story
Contoso Retail is an online grocery platform that sells food that can be shipped to customers. Clients of Contoso Retail should be able to purchase the grocery items and also return items for any reason. Contoso Retail also works with suppliers that bring inventory daily for replenishment to the warehouse where customer orders are shipped from. The inventory is constantly been incremented or decremented from activities such as customer purchases, supplier replenishments and customer returns (if the item is still in good condition and can be resold).

One average, there are approximately 35,000 transactions every hour that gets generated across multiple orders. Each transaction generates about 500kB of data going into the Kafka cluster and these events have to be retained for at least 90 days as per department of commerce regulations.

The suppliers send notifications for inventory replenishments in various data formats including but not limited to CSV, JSON, Protobuf and Avro formats. The order database is a MySQL database that keeps track of all purchases and the returns databases is a Cosmos DB collection that tracks all the items returned.

## Description

Based on the background story, determine the appropriate Confluent Cloud cluster and SKU as well as the necessary Kafka components as well as the Azure resources that is necessary to support the workload necessary for the solution that Contoso Retail needs.

Deploy the ARM template for the Cosmos DB database, Data Generators and Azure functions and set up the initial Confluent Cloud Cluster. The Cosmos DB database contains collections for Users and Products

For this hack, we will need to deploy a Confluent Cloud on Azure instance as well as other Azure data stores and compute resources needed for the hack.

Now that you have the common pre-requisites installed on your workstation, there are prerequisites specific to this hack.

Your coach will provide you with a Resources.zip file that contains resources you will need to complete the hack. If you plan to work locally, you should unpack it on your workstation. If you plan to use the Azure Cloud Shell, you should upload it to the Cloud Shell and unpack it there.

Please install these additional tools:

- [Azure IoT Tools](https://marketplace.visualstudio.com/items?itemName=vsciot-vscode.azure-iot-tools) extension for Visual Studio Code
- .NET SDK 6.0 or later installed on your development machine. This can be downloaded from [here](https://www.microsoft.com/net/download/all) for multiple platforms.

In the `/Challenge00/` folder of the Resources.zip file, you will find an ARM template, `setupIoTEnvironment.json` that sets up the initial hack environment in Azure you will work with in subsequent challenges.

Please deploy the template by running the following Azure CLI commands from the location of the template file:
```
az group create --name myIoT-rg --location eastus
az group deployment create -g myIoT-rg --name HackEnvironment -f setupIoTEnvironment.json
```

## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify that you have a bash shell with the Azure CLI available.
- Verify that the ARM template has deployed the following resources in Azure:
  - Azure Function App
  - Virtual Network
  - Azure Cosmos DB Instance
- Verify that the Confluent Cloud on Azure instance has been deployed successfully

## Learning Resources

_Confluent and Azure resource links:_

- [Apache Kafka for Confluent Cloud on Azure](https://learn.microsoft.com/en-us/azure/partner-solutions/apache-kafka-confluent-cloud/overview)
- [Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/introduction)
- [Azure Function Premium Plan](https://learn.microsoft.com/en-us/azure/azure-functions/create-premium-plan-function-app-portal)
- [Confluent Developer Courses](https://developer.confluent.io/learn-kafka/)
