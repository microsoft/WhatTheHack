# What The Hack - Building AI Apps with OpenAI and the Azure Ecosystem

## Introduction

This hands-on set of challenges will provide participants with experience on how to integrate the Azure Open AI offering with Microsoft Azure platform services.

## Learning Objectives

The objective of the hack is to make participants aware and comfortable with the different strategies and scenarios for integrating the Azure Open AI service with Azure Platform products including but not limited to Azure Cognitive Services, Partner offerings on Microsoft and Open-Source projects.

### Exit Competencies: 
The participants will learn how to:
- Select different architectures to implement Open AI solutions on Azure based on the scenarios.
- Understand when to use Open AI products and when to leverage Cognitive Services or other solutions
- Provision and configure Azure Open AI resources.
- Understand the different libraries, frameworks, capabilities and tools available to implement intelligent AI apps.
- Implement Q&A virtual assistants using RAG architectures powered by vector stores, full text search and hybrid search.
- Understand techniques and options available on Azure for processing and storing data used for implementing RAG architectures.
- Secure access to Azure Open AI Resources.
- Integrate Azure Private Virtual Networks with Azure Open AI.
- Perform capacity planning and quota enforcement for Open AI resources.
- Manage availability, business continuity and disaster recovery.
- Implement solutions for batch and near real-time use cases.

## Challenges

- Challenge 00: **[Pre-requisites - Ready, Set, GO!](Student/Challenge-00.md)**
	 - Prepare your workstation and environment to work with Azure. Deploy the dependencies to Azure.
- Challenge 01: **[Auto-Vectorization: Automatic Processing of Document Embeddings from Data Sources](Student/Challenge-01.md)**
	- Design and implement a pipeline that tracks changes to the document sources (object stores, relational databases, NoSQL databases) and automatically processes the embeddings for these documents (if necessary) and stores these dense vectors in the appropriate vector databases for usage in vector, sparse and hybrid search. This challenge covers vector store selection based on performance, capacity, available algorithms etc.
- Challenge 02: **[Contoso Travel Assistant](Student/Challenge-02.md)**
	 - Design and implement a virtual assistant that responds to frequently asked questions about the economy, climate and government based on static data from the Contoso Islands documents stored in blob storage.
	 - Design and implement a virtual assistant that provides near real-time answers to Contoso Islands tourists that are looking to make a reservation for a Yacht tour for a specific date.
- Challenge 03: **[The Teacher's Assistant—Batch & Near Realtime Essay Grading](Student/Challenge-03.md)**
	 - Design and implement a pipeline that reads, analyzes and grades a bulk of essays submitted in various file and image formats loaded from Azure Blob Storage. Also design and implement a pipeline that reads, analyzes and instantly grades user-submitted essays in various file and image formats.
- Challenge 04: **[Securing Resources, Quota Monitoring and Enforcement](Student/Challenge-04.md)**
	 - Design and implement a solution to monitor the usage of OpenAI resources as well as the enforcement of quotas allocated at multiple layers/levels/tiers.
	 - Design and implement a solution that ensures that credentials to OpenAI resources are not in environment variables or configuration files while leveraging Azure Virtual Networks ensure that the OpenAI endpoints are only reachable from specific networks.
- Challenge 05: **[Performance and Cost and Optimizations](Student/Challenge-05.md)**
     - Design and implement a solution that optimizes the application performance and minimizes the operational costs of the OpenAI solutions.


## Prerequisites

- Access to an Azure subscription with Owner access
	- If you don’t have one, Sign Up for Azure [HERE](https://azure.microsoft.com/en-us/free/)
	- Familiarity with [Azure Cloud Shell](https://learn.microsoft.com/en-us/azure/cloud-shell/overview#multiple-access-points)
- Access to [Azure OpenAI Service](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/overview)
- An IDE: [Visual Studio Code](https://code.visualstudio.com/), [WebStorm](https://www.jetbrains.com/webstorm/download/), [PyCharm](https://www.jetbrains.com/pycharm/download/) or [IntelliJ](https://www.jetbrains.com/idea/download/)


## Contributors

- [Israel Ekpo](https://github.com/izzymsft)
- [Ellie Nosrat](https://github.com/ellienosrat)
- [Shiva Chittamuru](https://github.com/shivachittamuru)
- [Mike Richter](https://github.com/michaelsrichter)
- [Sowmyan Soman Chullikkattil](https://github.com/sowsan)
- [Amanda Wong](https://github.com/wongamanda)
- [Devanshi Thakar](https://github.com/devanshithakar12)
- [Alexis Joseph](https://github.com/alexistj)
- [Melody Yin](https://github.com/melody-N07)
