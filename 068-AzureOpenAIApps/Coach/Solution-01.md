# Challenge 01 - Auto-Vectorization: Automatic Processing of Document Embeddings from Data Sources - Coach's Guide 

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Notes & Guidance

The purpose of this challenge is to enable data to flow through the system using the data sources that are supplied and to have them put into the vector stores. 

Once this is done, starting up the backend using the following command should trigger the data flow if all the Cosmos Db documents for the yachts and the Azure Blob store files from Challenge 0 have already been uploaded.

The student/participant should be able to see the documents in the Azure AI Search Index

This should successfully conclude the challenge. 

The architecture diagram below illustrates how the data is expected to flow from the blob store to the Azure AI Search indices for the following AI Search indices

- `contoso_yachts`
- `contoso_documents` 

The student should also verify that subsequent modifications of the yacht records in Cosmos DB or uploads of additional documents or modification of existing documents by the student will trigger updates to the AI Search indices

If the student gets a `429 Too Many Requests error` in the terminal window where they ran `func start`, they may need to increase the quota for their subscription for the model (e.g. `text-embedding-ada-002`). They may also need to upload the documents again to trigger the indexing. 

The number of indexed documents in the Azure AI Search Service may not always reflect recent changes to the index. If you do a search, you can manually scroll to see if the embeddings have been calculated. 

**NOTE:** There is a known issue where when modifications to any document are indexed by Azure AI Search, the previous embeddings are not removed from the index.  Students may see the modified and original embeddings be returned when querying Azure AI Search.
