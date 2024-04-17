# Challenge 01 - Auto-Vectorization: Automatic Processing of Document Embeddings from Data Sources - Coach's Guide 

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Notes & Guidance

The purpose of this challenge is to enable data to flow through.From the data sources into the vector stores. The student must ensure that all the configurations in the application settings (local.settings.json) have been completely filled out by copying out all the values from the azure portal into the settings for your environment.

Once this is done, starting up the backend using the following command should trigger the data flow if all the cosmos db documents for the yachts and the blob store files from challenge 0 have already been uploaded.

The student/participant should be able to see the documents in the Azure AI Search Index

This should successfully conclude the challenge

The architecture diagram below illustrates how the data is expected to flow from the blob store to the Azure AI Search indices for the following AI Search indices

- contoso_yachts
- contoso_documents 

The student should also verify that subsequent modifications of the yacht records in Cosmos DB or uploads of additional documents or modification of existing documents by the student will trigger updates to the AI Search indices

