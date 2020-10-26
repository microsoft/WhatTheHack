# Coach's Guide: Challenge 4 - Index patient data for patient lookup

[< Previous Challenge](./Solution03.md) - **[Home](../readme.md)** - [Next Challenge>](./Solution05.md)

# Notes & Guidance

## Create a Azure Cognitive Search service
- **[Quickstart: Create an Azure Cognitive Search service in the portal](https://docs.microsoft.com/en-us/azure/search/search-create-service-portal)**
- Create your service
  - Provide instance details
    - URL
    - Location
    - Pricing tier
- Get a key and URL endpoint
  - Copy URL endpoint from Overview blade in portal
  - Copy Primary admin key from Settings-Keys blade in portal
- Scale your service
  - Go to Settings-Scale blade in portal
    - Sacle by Partitions
      - Allow your service to store and search through more documents
    - Scale by Replicas
      - Allow your service to handle a higher load of search queries

## Setup Cosmos DB indexer in Azure Cognitive Search to crawl Azure Cosmos DB items accessed through SQL API protocol
- Start Import data wizard in Azure Cognitive Search
  - Start the wizard from the command bar in the Azure Cognitive Search service page
  - or, if you're connecting to Cosmos DB SQL API you can click Add Azure Cognitive Search in the Settings section of your Cosmos DB account's left navigation pane
- Set the data source
  - Name of the data source object
  - Cosmos DB account
    - Use primary or secondary connection string from Cosmos DB
  - Database from account
  - Collection is a container of documents
  - Query if want to select a document subset; otherwise leave blank for all documents
- Set index attributes in the Index page
  - Select a series of checkboxes (below) in the list of fields with a data type to set index attributes
    - Retreivable
    - Filterable
    - Sortable
    - Facetable
    - Searchable
    - Analyzer (drop-down list)
- Create indexer to crawl an external data source for searchable content
  - Run the wizard and create all objects
  - The output of the Import data wizard is an indexer that crawls your Cosmos DB data source, extracts searchable content, and imports it into an index on Azure Cognitive Search

- Deploy new Azure Function triggered by Event Hub pushing data to CosmosDB

Alternatively, you can use REST APIs to index Azure Cosmos DB data
- **[Use REST APIs](https://docs.microsoft.com/en-us/azure/search/search-howto-index-cosmosdb#use-rest-apis)**

## Add search capability is through a REST API with execute queries operations
- Callling the API
  - All APIs must be issued over HTTPS (on the default port 443).
  - Your search service is uniquely identified by a fully-qualified domain name (for example: `mysearchservice.search.windows.net`).
  - All API requests must include an api-key that was generated for the search service you provisioned. Having a valid key establishes trust, on a per request basis, between the application sending the request and the service that handles it.
  - All API requests must include the api-version in the URI. Its value must be set to the version of the current service release, shown in the following example:
  - GET https://[search service name].search.windows.net/indexes?api-version=2020-06-30
  - All API requests can optionally set the Accept HTTP header. If the header is not set, the default is assumed to be application/json.
- Endpoint
  - The endpoint for service operations is the URL of the Azure Cognitive Search service you provisioned: https://<yourService>.search.windows.net.
- **[Authentication and Authorization](https://docs.microsoft.com/en-us/rest/api/searchservice/#authentication-and-authorization)**
  - Autentication
    - Admin Key
      - Grant full rights to all operations, including the ability to manage the service, get status and object definitions, and create and delete indexes, indexers, and data sources.
    - Query Key
      - Grant read-only access to content within an index (documents), and are typically distributed to client applications that issue search requests.
  - Authorization
    - Authorization is available for administrative operations via the role-based access controls (RBAC) provided in the Azure portal.
