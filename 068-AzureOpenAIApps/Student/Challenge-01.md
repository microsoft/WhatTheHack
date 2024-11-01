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

There are documents (from the **artifacts/documents/contoso-islands** folder in your Resources) that needs to be uploaded to the **government** container in the Azure Blob Storage account.

There are also some JSON documents (from the **artifacts/cosmos-db/contoso-yachts** that needs to be uploaded to the corresponding Azure **yachts** Cosmos DB containers respectively.

You can use the **az storage blob upload** command examples below to upload the document to Azure Blob Storage.

For Cosmos DB, you can upload the JSON documents using the REST API client file **rest-api-yachts-management.http**. Note: this file uses the `humao.rest-client` VSCode extension which should already be installed if you are using GitHub Codespaces for this hack. If you are running the hack with a local setup, you will need to add the extension to VSCode. 

![Auto Vectorization](../images/auto-vectorization-1.drawio.svg)

In the diagram above, the following sequence of activities are taking place:
- step 1: the newly inserted or modified documents in Azure Blob Store and Cosmos DB are triggering Azure functions
- step 2 and 3: the azure function is determining if it needs to compute the embeddings for the new/modified record from the data sources
- steps 4 and 5: if necessary, the embeddings are computed by communicating with the embedding API for the correct embeddings for each document chunk
- step 6: the vectors are now sent to the vector database (AI Search)


Your task is to configure the Backend application Azure Function triggers to keep track of new documents and modification to existing documents from Azure Blob Store and Cosmos DB to ensure that the vector store and database used to power the language models is kept fresh and up-to-date so that the LLM can provide accurate answers to queries.

This will make sure that any change that takes place in the Blob Store or Cosmos DB containers will be detected and processed.

The goal is to ensure that these documents are vectorized and stored in the appropriate vector store. Azure AI Search is recommended but feel free to use any other vector database of your preference.

If everything works properly then the text files newly uploaded to modified in  the **government** container in Blob store should show up in the contoso documents AI Search index configured and defined in the **AZURE_AI_SEARCH_CONTOSO_DOCUMENTS_INDEX_NAME** application setting.

Likewise, updates to the **yachts** JSON records in Cosmos DB should automatically show up in the AI Search index defined in the **AZURE_AI_SEARCH_CONTOSO_YACHTS_INDEX_NAME** setting in your application settings.

We need to upload documents to Azure Blob Store and Cosmos DB.

### Uploading Documents to Azure Blob Store
To successfully upload the documents to blob store, you can navigate to the following folder and use the Azure CLI to upload the files. You may upload the files individually or in bulk. Here is some sample code to help you. 

````bash
# Use this command to login if you have a regular subscription
az login --use-device-code

# OR 

# Use this command to login if you are on an FPDO susbcription
az login --service-principal -u <app-id> -p <password-or-cert> --tenant <tenant>

# navigate to document directory
cd artifacts/documents/contoso-islands

````

Use these commands to upload the file to Azure blob storage individually.

````bash
# upload single documents one at a time
az storage blob upload --account-name {mystorageaccountname}  -f {filenameToUpload} -c {destinationContainer} --overwrite

az storage blob upload --account-name contosoizzy1storage  -f climate.txt -c government --overwrite

````

Use these commands to upload multiple files simultaneously

````bash

# upload all files simultaneously from the current directory
az storage blob upload-batch --account-name {myStorageAccountName} -d {myStorageContainer} -s {sourceDirectory}

az storage blob upload-batch --account-name contosopeterod1storage -d government -s .

````




### Uploading Documents to Azure Cosmos DB

The contents of the Yacht details are stored in the directory **artifacts/cosmos-db/contoso-yachts**

Make sure you manually copy and paste the JSON contents of each JSON file in this location and use the REST client in **rest-api-yachts-management.http** to send each document via the REST API to Cosmos DB. There are five JSON files. 

To successfully upload the documents to Cosmos DB, please use the REST Client in VSCode and execute the appropriate commands from the **rest-api-yachts-management.http** script in your Backend folder. This commands allows you to upload each yacht record individually to the database.

Simply Click on "Send Request" for each command to execute and upload each Yacht individually to the database.

Each request should return a 200 HTTP status code.

This shows how to create or update existing yacht records in the database via the REST API

![How to Create Yacht records](../images/humao-rest-client-create-yachts.png)

This shows how to retrieve existing yacht records from the database via the REST API

![How to Retrieve Yacht records](../images/humao-rest-client-retrieve-yachts.png)

This shows how to remove existing yacht records from the database via the REST API

![How to delete/remove yacht records](../images/humao-rest-client-delete-yachts.png)

There are in-file variables that you may have to edit to control the destination and contents of the HTTP requests you are making to the back end service

![HTTP Request Variables](../images/humao-rest-client-in-file-variables.png)

The api_endpoint controls the destination of the http request, the conversation_id variable is used to keep track of different requests to the back end and the yacht_id specifies the specific yacht record we are targeting

````bash
@api_endpoint = http://localhost:7072
@conversation_id = 22334567
@yacht_id = "100"
````

The application has Azure Functions that watch the Cosmos DB database collections as well as the Azure Blob Store containers for changes. Each file upload to Azure Blob Store (new or modified) should trigger the Azure Function for you to see in the Terminal Console and the change triggering the Azure Functions. You should also see the document chunks uploaded to the AI Search Index.

Each JSON request submission to the Yacht management REST API should also trigger the Azure function that processes the embeddings for the Yacht contents. You should also see these changes reflected in the Azure Search Index.

You should be able to search for the documents in Azure AI Search

![HTTP Request Variables](../images/contoso_yachts_index_search.png)

You should then make a small change to one of the JSON files by changing some text in the description and then upload the file again. You should then be able to see the change reflected in the Azure AI Search index. Change the file back to how it was originally and upload the file again because it will be used in later challenges. 

## Success Criteria

To complete the challenge successfully, the solution should demonstrate the following:
- The Triggers for the Blob Store and Cosmos DB Container changes are detecting changes to new or modified records in your VSCode.
- Any new document or change to an existing document in Cosmos DB must be reflected in the vector store index
- Any new document uploaded into the Azure Blob Store container must be reflected in the vector store index.

## Learning Resources

Here is a list of resources that should assist you with completing this challenge:

*Sample resources:*

- [Vector Search with Azure AI Search](https://learn.microsoft.com/en-us/azure/search/vector-search-overview)
- [Vector Similarity Search with Redis](https://techcommunity.microsoft.com/t5/azure-developer-community-blog/vector-similarity-search-with-azure-cache-for-redis-enterprise/ba-p/3822059)
- [Azure Function Triggers for Cosmos DB](https://learn.microsoft.com/en-us/azure/azure-functions/functions-bindings-cosmosdb-v2-trigger)
- [Azure Function Triggers for Azure Blob Store](https://learn.microsoft.com/en-us/azure/azure-functions/functions-bindings-storage-blob-trigger)

## Tips

*Sample tips:*

- Start up the function app first before loading the documents.
- Log changes to the console so that you can see if your changes are working.
- There are some example codes in the app for you to use to get started.
