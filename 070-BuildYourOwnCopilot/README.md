# What The Hack - Build Your Own Copilot

## Introduction

CosmicWorks has big plans for their retail site. They're eager to launch a POC of a simple chat interface where users can interact with a virtual agent to find product and account information.

The scenario centers around a consumer retail "Intelligent Agent" that allows users to ask questions on vectorized product, customer and sales order data stored in a database. The data in this solution is the CosmicWorks sample for Azure Cosmos DB. This data is an adapted subset of the Adventure Works 2017 dataset for a retail Bike Shop that sells bicycles, biking accessories, components and clothing.

> BUT you can bring your own data instead.

## Learning Objectives

This hackathon helps you expand your knowledge about the Generative AI patterns used in the [Build Your Own Copilot with Azure Cosmos DB solution accelerator](https://github.com/Azure/BuildYourOwnCopilot). The solution accelerator demonstrates how to design and implement a Generative AI solution that incorporates Azure Cosmos DB with the Azure OpenAI Service along with other key Azure services, to build an AI assistant user interface.

## Challenges

- Challenge 00: **[Prerequisites - The landing before the launch](Student/Challenge-00.md)**
	 - Prepare your workstation to work with Azure and deploy the required services.
- Challenge 01: **[Finding the kernel of truth](Student/Challenge-01.md)**
	 - Learn about the basics of Semantic Kernel, a Large Language Model (LLM) orchestrator that powers the solution accelerator.
- Challenge 02: **[It has no filter](Student/Challenge-02.md)**
	 - Learn about intercepting and using key assets from Semantic Kernel's inner workings - prompt and function calling data.
- Challenge 03: **[Always prompt, never tardy](Student/Challenge-03.md)**
	 - Learn how prompts are used in the solution accelerator and experiment with changes to the prompts.
- Challenge 04: **[Cache it away for a rainy day](Student/Challenge-04.md)**
	 - Learn about the inner workings and applications of semantic caching in the solution accelerator.
- Challenge 05: **[Do as the Colonel commands](Student/Challenge-05.md)**
	 - Learn about implementing system commands based on user input in the solution accelerator.

## Prerequisites

- Attendees should have the “Azure account administrator” (or "Owner") role on the Azure subscription in order to authenticate, create and configure the resource group and necessary resources including:
  - Azure Cosmos DB for NoSQL
  - Azure Container App with supporting services _or_ Azure Kubernetes Service (AKS)
  - Azure OpenAI
  - Azure Managed Identity
  - Azure Key Vault
  - Visual Studio Code or Visual Studio 2022 (if running on local machine)
  - Azure Developer CLI (`azd`)

## Contributors

- [Mark J. Brown](https://github.com/markjbrown)
- [Ciprian Jichici](https://github.com/ciprianjichici)
- [Joel Hulen](https://github.com/joelhulen)
- [Matthew Alan Gray](https://github.com/hatboyzero)
