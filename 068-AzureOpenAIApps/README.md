# What The Hack - Building AI Apps with OpenAI and the Azure Ecosystem

## Introduction

This hands-on set of challenges will provide participants with experience on how to integrate the Azure OpenAI offering with Microsoft Azure platform services.

Building AI applications on Microsoft Azure involves needing to know the following:

The language models that power the AI application needs the data it is using to make decisions to be in the right format so as to enable it respond appropriately to queries and requests from its users. Which LLM or SLM SKUs and versions do you need to use and why? What are the data pipelines necessary to automate this is crucial for the success of any AI application powered by small or large language models? How do you configure the LLM to respond correctly to user queries or requests? How do we get the data necessary to answer these questions? A lot of times the data is not readily consumable by the app and it needs to be digested, parsed and simplified to extract the data in the format that can be readily leveraged by the language model and this requires using resources such as Azure Document Intelligence, Azure AI Vision, Azure Custom Vision, Azure Video Indexer to mention just a few. In this hack, we focus on just one of these parsers - Azure Document Intelligence used to parse records uploaded to Azure Blob Store and Cosmos DB.

Furthermore, you need to understand the types of vector databases you need to power your application knowledge store depending on the use cases in your app such as vector embedding length, storage capacity, query throughput, latency requirements and query types.

The application also has to maintain state, control usage throughput and store the relevant metadata used to simplify the interaction between the users of the app and the virtual agents and this requires leveraging queuing mechanisms, key-value and document stores such as Azure Service Bus, Azure Redis Cache and Azure Cosmos DB. In this hack, you will be going through scenarios where this is necessary.

When it comes to the user experience, configuring the assistants with the appropriate system prompts and tools enables the language models to retrieve the relevant data from the knowledge stores while processing requests from the users. This hack will work you through how to configure the language models as well as the system prompts and tools necessary to direct the LLM while it provides responses to the users or even other application segments during automated tasks.

The goal of this hack is to get engineers and architects ready for building effective, scalable apps that will perform well in production scenarios.

## Learning Objectives

The objective of the hack is to make participants aware and comfortable with the different strategies and scenarios for integrating the Azure Open AI service with Azure Platform products necessary to build, deploy and maintain highly performant AI applications in production.

The participants will learn how to:
- Select different architectures to implement Open AI solutions on Azure based on the scenarios.
- Understand when to use Open AI products and when to leverage Cognitive Services or other solutions
- Provision and configure Azure Open AI resources.
- Understand the different libraries, frameworks, capabilities and tools available to implement intelligent AI apps.
- Implement Q&A virtual assistants using RAG architectures powered by vector stores, full text search and hybrid search.
- Understand techniques and options available on Azure for processing and storing data used for implementing RAG architectures.
- Perform capacity planning and quota enforcement for Open AI resources.
- Easily observe what is taking place inside the deployed applications
- Implement solutions for batch and near real-time use cases.

## Challenges

- Challenge 00: **[Pre-requisites - Ready, Set, GO!](Student/Challenge-00.md)**
	 - Prepare your workstation and environment to work with Azure. Deploy the dependencies to Azure.
- Challenge 01: **[Auto-Vectorization: Automatic Processing of Document Embeddings from Data Sources](Student/Challenge-01.md)**
	- Design and implement a pipeline that tracks changes to the document sources (object stores, relational databases, NoSQL databases) and automatically processes the embeddings for these documents (if necessary). 
    - The pipeline also stores these dense vectors in the appropriate vector databases for usage in vector, sparse and hybrid search.
- Challenge 02: **[Contoso Travel Assistant](Student/Challenge-02.md)**
	 - Design and implement a virtual assistant that responds to frequently asked questions about the economy, climate and government based on static data from the Contoso Islands documents stored in blob storage.
	 - Design and implement a virtual assistant that provides near real-time answers to Contoso Islands tourists that are looking to make a reservation for a Yacht tour for a specific date.
- Challenge 03: **[The Teacher's Assistant — Batch & Near Realtime Essay Grading](Student/Challenge-03.md)**
	 - Design and implement a pipeline that reads, analyzes and grades essays submitted in various file and image formats (PDF, JPEG/JPG, PNG, BMP, and TIFF) loaded from Azure Blob Storage.
- Challenge 04: **[Quota Monitoring and Enforcement](Student/Challenge-04.md)**
	 - Design and implement a solution to monitor the usage of OpenAI resources as well as the enforcement of quotas allocated to multiple users within an organization.
- Challenge 05: **[Performance and Cost and Optimizations](Student/Challenge-05.md)**
     - Design and implement a solution that optimizes the application performance and minimizes the operational costs of the OpenAI solutions.


## Prerequisites

- Access to an Azure subscription with Owner access
	- If you don’t have one, Sign Up for Azure [HERE](https://azure.microsoft.com/en-us/free/)
	- Familiarity with [Azure Cloud Shell](https://learn.microsoft.com/en-us/azure/cloud-shell/overview#multiple-access-points)
- Access to [Azure OpenAI Service](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/overview)
- An IDE: [Visual Studio Code](https://code.visualstudio.com/), [WebStorm](https://www.jetbrains.com/webstorm/download/), [PyCharm](https://www.jetbrains.com/pycharm/download/) or [IntelliJ](https://www.jetbrains.com/idea/download/)


## Contributors

We seize this opportunity to express our sincere gratitude to all our contributors that helped with the design and development of the content used for this hack.

We thank them for sharing their experience and creativity to design the scenarios and for taking the time to review the content that has been developed.

- [Alexis Joseph](https://github.com/alexistj)
- [Amanda Wong](https://github.com/wongamanda)
- [Charlotte Oickle](https://github.com/charlietfcgirl)
- [Devanshi Thakar](https://github.com/devanshithakar12)
- [George Luiz Bittencourt](https://github.com/glzbcrt)
- [Israel Ekpo](https://github.com/izzymsft)
- [Kevin M. Gates](https://github.com/kevinmgates)
- [Melody Yin](https://github.com/melody-N07)
- [Mike Richter](https://github.com/michaelsrichter)
- [Nikki Conley](https://github.com/nikkiconley)
- [Pete Rodriguez](https://github.com/perktime)
- [Peter Laudati](https://github.com/jrzyshr)
- [Sowmyan Soman Chullikkattil](https://github.com/sowsan)
- [Thomas Mathew](https://github.com/tmathew1000)
- [Wayne Smith](https://github.com/waynehsmith)
