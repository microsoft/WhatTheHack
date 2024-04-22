# Challenge 01 - Auto-Vectorization: Automatic Processing of Document Embeddings from Data Sources

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Pre-requisites (Optional)

This challenge assumes that all the dependencies in the Challenge 0 were deployed successfully.

## Introduction

In many organizations, the database used by the LLMs to provide data to the virtual assistants are not the original source of truth.

Hence the structured and unstructured databases must be synchronized with the vector stores using mechanisms available within the ecosystem.

Automatically detecting document changes in Azure Blob Store and Azure Cosmos DB is of paramount importance as it facilitates the continuous and real-time update of document representations through the Azure OpenAI embedding service. 

In an era where information is constantly evolving, staying up-to-date with document changes is crucial for accurate and relevant data analysis. By leveraging automated detection, organizations can ensure that their embedded document vectors remain synchronized with the most recent content, enabling better insights, search capabilities, and recommendation systems. 

This approach enhances the efficiency and effectiveness of various applications, from content recommendation engines to fraud detection, by providing accurate and timely representations of the documents in question, making it an indispensable component of modern data processing and analysis pipelines.

## Description

Contoso Yachts is a 40-person organization that specializes in booking tours in Contoso Islands.

There are documents (from the documents/contoso-islands folder in your Resources) that have been uploaded to the **government** container in the Azure Blob Storage account.

There are also some JSON documents (from the contoso-db/contoso-yachts and contoso-db/customers folders) that have been uploaded to the corresponding Azure **yachts** and **customers** Cosmos DB containers respectively.

Your task is to design a system that leverages Azure Function trigger to keep track of new documents and modification to existing documents.

This will make sure that any change that takes place in the Blob Store or Cosmos DB containers will be detected and processed.

The goal is to ensure that these documents are vectorized and stored in the appropriate vector store. Azure Cognitive Search is recommended but feel free to use any other vector database of your preference.

If everything works properly then the text files newly uploaded to modified in  the **government** container in Blob store should show up in the contoso documents AI Search index configured and defined in the **AZURE_AI_SEARCH_CONTOSO_DOCUMENTS_INDEX_NAME** application setting.

Likewise, updates to the **yachts** JSON records in Cosmos DB should automatically show up in the AI Search index defined in the **AZURE_AI_SEARCH_CONTOSO_YACHTS_INDEX_NAME** setting in your application settings.

## Success Criteria

To complete the challenge successfully, the solution should demonstrate the following:
- The Triggers for the Blob Store and Cosmos DB Container changes are detecting changes to new or modified records
- The embeddings for the documents in AI Search are updated when the text files are updated and when the description of the yacht is modified.
- Any new document or change to an existing document in Cosmos DB must be reflected in the vector store index
- Any new document uploaded into the Azure Blob Store container must be reflected in the vector store index.

## Learning Resources

Here is a list of resources that should assist you with completing this challenge:

*Sample resources:*

- [Vector Search with Azure Cognitive Search](https://learn.microsoft.com/en-us/azure/search/vector-search-overview)
- [Vector Similarity Search with Redis](https://techcommunity.microsoft.com/t5/azure-developer-community-blog/vector-similarity-search-with-azure-cache-for-redis-enterprise/ba-p/3822059)
- [Azure Function Triggers for Cosmos DB](https://learn.microsoft.com/en-us/azure/azure-functions/functions-bindings-cosmosdb-v2-trigger)
- [Azure Function Triggers for Azure Blob Store](https://learn.microsoft.com/en-us/azure/azure-functions/functions-bindings-storage-blob-trigger)

## Tips

*Sample tips:*

- Start up the function app first before loading the documents.
- Log changes to the console so that you can see if your changes are working.
- There are some example codes in the app for you to use to get started.
