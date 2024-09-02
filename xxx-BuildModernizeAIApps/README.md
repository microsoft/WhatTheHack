# What The Hack - Build & Modernize AI Applications

## Introduction

CosmicWorks has big plans for their retail site. They're eager to launch a POC of a simple chat interface where users can interact with a virtual agent to find product and account information.

The scenario centers around a consumer retail "Intelligent Agent" that allows users to ask questions on vectorized product, customer and sales order data stored in a database. The data in this solution is the Cosmic Works sample for Azure Cosmos DB. This data is an adapted subset of the Adventure Works 2017 dataset for a retail Bike Shop that sells bicycles, biking accessories, components and clothing.

> BUT you can bring your own data instead.

## Learning Objectives

This hackathon will challenge you and your team to launch a POC of a chat interface where users can interact with a virtual agent to find product and account information. Through the course of the hackathon, you will modify an existing application to do the following:

- Store the chat messages in an Azure Cosmos DB database, grouped by chat sessions
- Use Azure OpenAI Service to create vector embeddings and chat completions
- Use Azure Cognitive Search as a vector database to search for product and account information by the vector embeddings
- Load up existing product and account information into Azure Cosmos DB and the Azure Cognitive Search vector index
- Create a process that manages the conversation flow, vectorization, search, data handling, and response generation
- Externally manage system prompts

## Challenges

- Challenge 00: **[Prerequisites - Ready, Set, GO!](Student/Challenge-00.md)**
	 - Prepare your workstation to work with Azure.
- Challenge 01: **[The Landing Before the Launch](Student/Challenge-01.md)**
	 - Deploy the solution cloud services in preparation for the launch of the POC.
- Challenge 02: **[Now We're Flying](Student/Challenge-02.md)**
	 - Experiment with system prompts.
- Challenge 03: **[What's Your Vector, Victor?](Student/Challenge-03.md)**
	 - Load new data and observe automatic vectorization.
- Challenge 04: **[It's All About the Payload, The Sequel](Student/Challenge-04.md)**
	 - Extend the solution to handle any type of JSON data.
- Challenge 05: **[The Colonel Needs a Promotion](Student/Challenge-05.md)**
	 - Add new capability by creating Semantic Kernel plugins.
- Challenge 06: **[Getting Into the Flow](Student/Challenge-06.md)**
	 - Use ML Prompt Flow to replace portions of the chat service.

## Prerequisites

- Attendees should have the “Azure account administrator” (or "Owner") role on the Azure subscription in order to authenticate, create and configure the resource group and necessary resources including:
  - Azure Cosmos DB with NoSQL API
  - Azure Container App with supporting services _or_ Azure Kubernetes Service (AKS)
  - Azure OpenAI
  - Azure AI Search
- Visual Studio Code
- Azure CLI

## Contributors

- [Mark J. Brown](https://github.com/markjbrown)
- [Ciprian Jichici](https://github.com/ciprianjichici)
- [Joel Hulen](https://github.com/joelhulen)
- [Matthew Alan Gray](https://github.com/hatboyzero)
