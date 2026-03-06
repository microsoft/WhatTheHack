# Challenge 00 - Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

In this challenge, you will provision all required infrastructure for the hackathon—both in Azure and Confluent Cloud—using automated Terraform modules. The focus of this challenge is to set up the cloud resources needed for data ingestion, streaming, schema validation, and AI search.

By the end of this challenge, you should have:

- Confluent Cloud configured with Kafka topics, Schema Registry, and Source/Sink Connectors
- Azure resources deployed, including Cosmos DB, Azure Storage, Azure OpenAI, Redis Cache, and Azure AI Search
- MCP-powered AI agents running and able to communicate with the deployed infrastructure.

## Common Prerequisites

We have compiled a list of common tools and software that you will need to complete this hack and deploy the Terraform-based infrastructure to Azure and Confluent Cloud.

You may not need all of them outside this challenge. However, if you work with Azure or Confluent Cloud on a regular basis, these are essential components for your development toolkit.

- [Azure Subscription](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-subscription)
- [Managing Cloud Resources](../../000-HowToHack/WTH-Common-Prerequisites.md#managing-cloud-resources)
  - [Azure Portal](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-portal)
  - [Azure CLI](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cli)
    - [Note for Windows Users](../../000-HowToHack/WTH-Common-Prerequisites.md#note-for-windows-users)
- [Visual Studio Code](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code)
- [Azure Storage Explorer](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-storage-explorer)

In addition to the common prerequisites above, you will need the following tools specific to this hack:

* **[Terraform CLI](https://developer.hashicorp.com/terraform/downloads)**
  - Required to deploy infrastructure modules for Azure and Confluent Cloud
  - After installation, verify by running: `terraform init`

* **[Confluent Cloud CLI](https://docs.confluent.io/confluent-cli/current/install.html)**
  - Required to authenticate to Confluent Cloud and interact with Kafka topics and connectors
  - After installation, verify by running: `confluent --help`


## Description

Your coach will provide you with a Resources.zip file (or access to a Codespaces environment) that contains the Terraform modules and configuration files needed to complete this challenge. If you plan to work locally, unpack the Resources.zip file on your workstation. If using Codespaces, the devcontainer will have the necessary dependencies pre-installed.

In this challenge, you will:

1. **Locate the Terraform modules** in the Resources folder (provided via Resources.zip or Codespaces)
2. **Update Terraform variables** with your Azure subscription ID, principal IDs, and Confluent API keys
3. **Run Terraform** to provision the infrastructure
4. **Confirm data flows through connectors**

### What the Terraform automation will create

| Platform            | Resource Provisioned                                                                                       |
| ------------------- | ---------------------------------------------------------------------------------------------------------- |
| **Azure**           | Azure OpenAI, Cosmos DB, Azure AI Search, Azure Redis Cache, Azure Storage Account                         |
| **Confluent Cloud** | Kafka Cluster, Schema Registry, Kafka topics, Cosmos DB & Blob Source connectors, AI Search Sink connector |
| **AI Agents / MCP** | Deployment of microservices + MCP servers that expose capabilities to agents                               |

## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify Terraform deploys successfully and resources appear in Azure Portal and Confluent Cloud
- Verify source connectors are live and pushing data from Cosmos DB and Blob Storage into Kafka topics
- Verify sink connector is pushing data into Azure AI Search (net sales + net inventory count topics)
- Demonstrate the MCP-powered AI agent can:
  - Respond when prompted
  - State its name
  - List all eight departments in the grocery store

## Learning Resources


* **Install Azure CLI:**
  [Azure CLI Installation Guide](https://learn.microsoft.com/cli/azure/install-azure-cli)

* **Install Terraform CLI:**
  [Terraform CLI Downloads](https://developer.hashicorp.com/terraform/downloads)

* **Install Confluent CLI:**
  [Confluent CLI Installation Guide](https://docs.confluent.io/confluent-cli/current/install.html)

* **Azure Service Principal authentication:**
  [Azure Service Principal Setup](https://learn.microsoft.com/azure/active-directory/develop/howto-create-service-principal-portal)

* **Confluent Cloud getting started:**
  [Confluent Cloud on Azure](https://docs.confluent.io/cloud/current/get-started/index.html)

* **Confluent Connector Hub:**
  [Azure Connectors for Confluent](https://www.confluent.io/hub/plugins?query=azure)
  
* **Confluent Source & Sink Connectors:**
  [Kafka Connectors from Confluent](https://docs.confluent.io/cloud/current/connectors/index.html)

* **Azure AI Search documentation:**
  [Azure AI Search Docs](https://learn.microsoft.com/azure/search/search-what-is-azure-search)

* **Azure Cosmos DB documentation:**
  [Azure Cosmos DB Docs](https://learn.microsoft.com/azure/cosmos-db/introduction)

