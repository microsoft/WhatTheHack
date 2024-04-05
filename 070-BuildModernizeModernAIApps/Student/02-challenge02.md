# Challenge 2: It's All About the Payload

CosmicWorks has years of product, customer, and sales data that they exported to an Azure storage account. They want to load this data into the Azure Cosmos DB account for a future migration of their e-Commerce site to Azure, but also for the POC of the chat interface. They also want to load the data into Azure Cognitive Search so that they can search for product and account information by the vector embeddings.

One critical component of the magic that makes the CosmicWorks chat interface work is the ability to search for products and accounts by their vector embeddings. When a user types a question into the chat interface, we need to create a vector embedding for the question, then search for the most similar vector embeddings of products and accounts, and then return those similar documents. The vector embeddings for products and accounts are stored in a vector database, allowing us to return relevant context documents that get sent to Azure OpenAI's completions endpoint.

CosmicWorks has done some research, and they would like to use Microsoft Semantic Kernel as the framework the code uses to orchestrate calls to the Azure OpenAI embeddings and completions endpoints. They've provided some incomplete starter code to give you an idea of what they are looking for.

## Challenge

Your team must:

1. Implement an efficient and repeatable way to load product and customer data from the storage account into Cosmos DB. For this exercise, you only need to load the data once, but CosmicWorks wants to be able to repeat the process in the future with new data. Cosmicworks has provided the data for you to start with, listed in the resources below.
2. Create a vector index in Azure Cognitive Search. They had some ideas on this that they provided in the starter project.
3. Create a process to index product and customer data from Cosmos DB using the change feed to load the documents into an Azure Cognitive Search vector index. They have provided a starter template for you that they had created for another effort.
4. Verify that the data was loaded into Cosmos DB and Cognitive Search.


### Hints

- CosmicWorks suggest using the Azure Cosmos DB Desktop Data Migration Tool to load their sample files from their Azure Storage into your instance of Cosmos DB. They suggest you do a "Quick Install" of the tool. They have provided the `migrationsettings.template.json` in the root of the starter repo that contains the parameters you should use with this tool. You need to replace the `{{cosmosConnectionString}}` instances in the JSON file with the connection string to your deployed instance of Cosmos DB.
  - When you run the tool, you may encounter rate-limiting errors (429) as it attempts to quickly load data into Azure Cosmos DB. To prevent this, increase the throughput (RU/s) on the Cosmos DB container to a higher value. After the data has been loaded, you can decrease the throughput to a lower value to save costs.
- Search thru the solution for the `TODO: Challenge 2` comments and follow the instructions provided.
- Think about how you can use the Cosmos DB Change Feed to trigger the creation of vector embeddings for new/updated products and customers.
- Think about how you build the logic for accessing the Azure OpenAI service to perform the vector embeddings of the product and customer documents. You will use this same logic layer to perform other Azure OpenAI tasks in later challenges.

### Success Criteria

To complete this challenge successfully, you must:

- Demonstrate to your coach that you can load the data from the storage account into Cosmos DB using a method that can be repeated in the future.
- Perform a document count on each container in Cosmos DB and verify that the counts match the number of documents in the storage account.
- Generate vector embeddings of a sufficiently high dimensionality that is supported by the Azure OpenAI service as well as your vector database.
- Encapsulate the embedding logic within a service layer that can be used by other components of the CosmicWorks chat interface, as well as a future REST API service.
- Create a process that automatically generates vector embeddings for all of the products and customers in the Cosmos DB database and stores them in the vector database.
- Demonstrate to your coach a successful search for products and customers by vector embeddings. This does not necessarily have to originate from the chat interface at this point.

### Resources

- [Sample Customer Data](https://cosmosdbcosmicworks.blob.core.windows.net/cosmic-works-small/customer.json)
- [Sample Product Data](https://cosmosdbcosmicworks.blob.core.windows.net/cosmic-works-small/product.json)
- [Azure Cosmos DB Desktop Data Migration Tool](https://github.com/AzureCosmosDB/data-migration-desktop-tool)
- [Query Azure Search using Search Explorer](https://learn.microsoft.com/azure/search/search-explorer)
- [Work with data using Azure Cosmos DB Explorer](https://learn.microsoft.com/en-us/azure/cosmos-db/data-explorer)

## Explore Further

- [Understanding embeddings](https://learn.microsoft.com/azure/cognitive-services/openai/concepts/understand-embeddings)
- [Semantic Kernel](https://learn.microsoft.com/semantic-kernel/overview/)
