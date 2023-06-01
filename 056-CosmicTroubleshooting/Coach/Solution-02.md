# Challenge 02 - Time to Fix Things - Coach's Guide 

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Notes & Guidance

- Based on their investigation, they should have developed a new data model for the purposes of the application. Since we are trying to optimize for point reads, every query should have a well defined id and partition key pair. A possible solution is:
    - New products collection:
        - Partition key: `/type`
        - Each document type id (ex. Product document has a `ProductId` field) should be copied over to the `/id` field
    - New orders collection:
        - Partition key: `/type`
        - Id should be the `OrderId` field (GUID).
    
  Since we would like to optimize for point reads, our data model stores `Product` documents with the `/id` field being the Product Id (which always know in our queries) and as the Partition key the `/type` field which in the Product case, holds the value "Product". The `CustomerCart` document will have as the `/id` field the Customer Id (which we always know in our queries) as well have in the `/type` field (partition key) the value of `"CustomerCart-\<CustomerId\>"`, which again we always know. In the previous solution, we stored a single `CustomerCart` document for each item we added to the cart, which created two problems: we needed an unique `/id` field for each document, as well as when we submitted the order, we needed to delete all of these documents. In our current solution, each item in the cart is appended to a single document.

  For the Order document, since we will have multiple `CustomerOrder` documents per customer and store, we opted to use a unique `/id` field (GUID) and set the partition key `/type` field to `"CustomerOrder-\<CustomerId\>"`. This gives us a small number of documents per partition that we would need to query, greatly reducing the amount of RU/s necessary to retrieve the orders of the customer. We could combine all orders in a single document but would potentially hit the max size of a single document in Azure Cosmos DB.
- They should leverage Change feed to move to a different (or more than one) collection(s). Please discourage them from creating new Azure Cosmos DB accounts - it will break the authentication of the Web App as it uses Azure AD authentication with Service Principals
    - They can of course do so but would need to give "Cosmos DB Built-in Data Contributor" role in the new account(s) to the MSI used by the Web App.
- For an easy way to leverage Change Feed for the migration:
    1. Create an Azure Function App
        - Runtime stack: .NET
        - Version: 6
        - Operating System: Windows
        - Plan type: Consumption (Serverless)
        - Enable Application Insights: Yes
    2. Once the Azure Function App is created, navigate to it and create a new Function:
        - Name: `ChangeFeed` (for example)
        - Development environment: Develop in portal
        - Template: Azure Cosmos DB trigger
        - Set the correct Cosmos DB account connection, database name and collection name
        - Set a name for the lease collection (default of leases is ok)
        - Enable the "Create lease collection if it does not exist" option
    3. Once created, disable the new function
    4. In the `ChangeFeed` function, navigate to Integration.
    5. Create a new Output binding. This will be for a new collection with a partition key of `type`:
        - Binding Type: Azure Cosmos DB
        - Select the existing Cosmos DB account connection (since we are targeting a collection in the same account)
        - Document parameter name: `productsnewDocument`
        - Database name: `wth-cosmos`
        - Collection name: `productsnew`
        - Check the checkbox to create the collection
        - Partition key: `/type`
    6. Create another Output binding:
        - Binding Type: Azure Cosmos DB
        - Select the existing Cosmos DB account connection (since we are targeting a collection in the same account)
        - Document parameter name: `ordersDocument`
        - Database name: `wth-cosmos`
        - Collection name: `orders`
        - Check the checkbox to create the collection
        - Partition key: `/type`
    7. Create another Output binding:
        - Binding Type: Azure Cosmos DB
        - Select the existing Cosmos DB account connection (since we are targeting a collection in the same account)
        - Document parameter name: `cartDocument`
        - Database name: `wth-cosmos`
        - Collection name: `productsnew`
        - Check the checkbox to create the collection
        - Partition key: `/type`
    8. In the Code + Test option of the Azure Function, add the following code in the respective files:
        - run.csx
            ```
            #r "Microsoft.Azure.DocumentDB.Core"
            #r "Newtonsoft.Json"
            using Microsoft.Azure.WebJobs;
            using Microsoft.Azure.WebJobs.Host;
            using Microsoft.Extensions.Logging;
            using Microsoft.Azure.Documents;
            using Microsoft.Azure.Documents.Client;
            using Microsoft.Azure.Documents.Linq;
            using System;
            using System.Threading.Tasks;
            using System.Collections.Generic;
            using Newtonsoft.Json;


            public class Product : Document
            {
                [JsonProperty("storeId")]
                public int StoreId { get; set; }
                [JsonProperty("name")]
                public string Name { get; set; }
                [JsonProperty("price")]
                public decimal Price { get; set; }
                [JsonProperty("imageURI")]
                public string ImageURI { get; set; }
                [JsonProperty("description")]
                public string Description { get; set; }
                [JsonProperty("type")]
                public string Type {get;set;}

                public Product(Document doc)
                {
                    this.Id = doc.GetPropertyValue<string>("itemId");
                    this.StoreId = doc.GetPropertyValue<int>("storeId");
                    this.Name = doc.GetPropertyValue<string>("name");
                    this.Price = doc.GetPropertyValue<decimal>("price");
                    this.ImageURI = doc.GetPropertyValue<string>("imageURI");
                    this.Description = doc.GetPropertyValue<string>("description");
                    this.Type = doc.GetPropertyValue<string>("type");
                }
            }

            public class CustomerCartNew : Document
            {
                [JsonProperty("customerId")]
                public string CustomerId { get; set; }

                [JsonProperty(PropertyName = "type")]
                public string Type => $"CustomerCart-{StoreId}";
                
                [JsonProperty(PropertyName = "storeId")]
                public int StoreId  { get; set; }

                [JsonProperty(PropertyName = "items")]
                public List<CustomerCartItem> Items { get; set; }

                public CustomerCartNew() : base() {}

                public CustomerCartNew(Document doc)
                {
                    this.Id = doc.GetPropertyValue<string>("customerId");
                    this.CustomerId = doc.GetPropertyValue<string>("customerId");
                    this.StoreId = doc.GetPropertyValue<int>("storeId");
                    this.Items = new List<CustomerCartItem>();
                    
                    this.Items.Add(
                        new CustomerCartItem {
                            ProductId = doc.GetPropertyValue<string>("productId"),
                            ProductName = doc.GetPropertyValue<string>("productName"),
                            ProductPrice = doc.GetPropertyValue<decimal>("productPrice"),
                            Quantity = doc.GetPropertyValue<int>("quantity")
                        }
                    );
                }
            }

            public class CustomerCartItem {

                [JsonProperty(PropertyName = "productId")]
                public string ProductId { get; set; }

                [JsonProperty(PropertyName = "productName")]
                public string ProductName { get; set; }

                [JsonProperty(PropertyName = "productPrice")]
                public decimal ProductPrice { get; set; }

                [JsonProperty(PropertyName = "quantity")]
                public int Quantity { get; set; }

                public CustomerCartItem(){}
            }

            public class CustomerCart : Document
            {
                [JsonProperty("customerId")]
                public string CustomerId { get; set; }
                [JsonProperty("productId")]
                public string ProductId { get; set; }
                [JsonProperty("storeId")]
                public int StoreId { get; set; }
                [JsonProperty("productName")]
                public string ProductName { get; set; }
                [JsonProperty("productPrice")]
                public decimal ProductPrice { get; set; }
                [JsonProperty("quantity")]
                public int Quantity { get; set; }
                [JsonProperty("type")]
                public string Type {get;set;}

                public CustomerCart() : base()
                {

                }

                public CustomerCart(Document doc)
                {
                    this.Id = doc.GetPropertyValue<string>("id");
                    this.CustomerId = doc.GetPropertyValue<string>("customerId");
                    this.ProductId = doc.GetPropertyValue<string>("productId");
                    this.StoreId = doc.GetPropertyValue<int>("storeId");
                    this.ProductName = doc.GetPropertyValue<string>("productName");
                    this.ProductPrice = doc.GetPropertyValue<decimal>("productPrice");
                    this.Quantity = doc.GetPropertyValue<int>("quantity");
                    this.Type = $"{doc.GetPropertyValue<string>("type")}-{doc.GetPropertyValue<string>("customerId")}";
                }
            }

            public class CustomerOrder : Document
            {
                [JsonProperty("customerId")]
                public string CustomerId { get; set; }
                [JsonProperty("storeId")]
                public int StoreId { get; set; }
                [JsonProperty("orderedItems")]
                public IEnumerable<CustomerCart> OrderedItems { get; set; }
                [JsonProperty("type")]
                public string Type {get;set;}
                [JsonProperty(PropertyName = "status")]
                public string Status { get; set; }

                public CustomerOrder(Document doc)
                {

                    this.Id = doc.GetPropertyValue<string>("id");
                    this.CustomerId = doc.GetPropertyValue<string>("customerId");
                    this.StoreId = doc.GetPropertyValue<int>("storeId");
                    this.Type = $"{doc.GetPropertyValue<string>("type")}-{doc.GetPropertyValue<string>("customerId")}";
                    this.OrderedItems = doc.GetPropertyValue<IEnumerable<CustomerCart>>("orderedItems");
                    this.Status = doc.GetPropertyValue<string>("status");
                }
            }



            public static async Task Run(IReadOnlyList<Document> input,
                                        IAsyncCollector<Product> productsnewDocument,
                                        IAsyncCollector<CustomerOrder> ordersDocument,
                                        IAsyncCollector<CustomerCartNew> cartDocument,
                                        DocumentClient client,
                                        ILogger log)
            {
                if (input != null && input.Count > 0)
                {
                    foreach(var doc in input)
                    {
                        log.LogInformation($"Processing document type: {doc.GetPropertyValue<string>("type")}");
                        switch(doc.GetPropertyValue<string>("type"))
                        {
                            case "Product":
                                await productsnewDocument.AddAsync(new Product(doc));
                                break;
                            case "CustomerOrder":
                                await ordersDocument.AddAsync(new CustomerOrder(doc));
                                break;
                            case "CustomerCart":
                                // Check if we already have a CustomerCart item for that store in the target collection
                                var customerId = doc.GetPropertyValue<string>("customerId");
                                var storeId = doc.GetPropertyValue<int>("storeId");
                                
                                Uri collectionUri = UriFactory.CreateDocumentCollectionUri("wth-cosmos", "productsnew");
                                var cartItem = client.CreateDocumentQuery<CustomerCartNew>(collectionUri)
                                    .Where(p => p.Id == customerId && p.Type == $"CustomerCart-{storeId}")
                                    .AsEnumerable()
                                    .SingleOrDefault();

                                if(cartItem != null){
                                    log.LogInformation($"Found existing Cart Item with {cartItem.Items.Count()} items. Updating.");

                                    var items = cartItem.Items;

                                    items.Add(
                                        new CustomerCartItem {
                                            ProductId = doc.GetPropertyValue<string>("productId"),
                                            ProductName = doc.GetPropertyValue<string>("productName"),
                                            ProductPrice = doc.GetPropertyValue<decimal>("productPrice"),
                                            Quantity = doc.GetPropertyValue<int>("quantity")
                                        }
                                    );
                                    
                                    cartItem.SetPropertyValue("items", items);
                                    await client.ReplaceDocumentAsync(cartItem);
                                    log.LogInformation($"Updated Cart Item. Now has {cartItem.Items.Count()} items.");
                                }
                                else{
                                    log.LogInformation("Creating new cart item.");
                                    await cartDocument.AddAsync(new CustomerCartNew(doc));
                                }
                                
                                break;
                            default:
                                log.LogInformation($"Found an unknown document type: {doc.GetPropertyValue<string>("type")}");
                                break;
                        }
                    }
                }
            }
            ```
        - function.json
            ```
            {
                "bindings": [
                    {
                    "type": "cosmosDBTrigger",
                    "name": "input",
                    "direction": "in",
                    "connectionStringSetting": "<Connection string name>",
                    "databaseName": "wth-cosmos",
                    "collectionName": "products",
                    "leaseCollectionName": "leases",
                    "startFromBeginning": true,
                    "createLeaseCollectionIfNotExists": true
                    },
                    {
                    "name": "cartDocument",
                    "databaseName": "wth-cosmos",
                    "collectionName": "productsnew",
                    "createIfNotExists": true,
                    "connectionStringSetting": "<Connection string name>",
                    "partitionKey": "/type",
                    "direction": "out",
                    "type": "cosmosDB"
                    },
                    {
                    "name": "productsnewDocument",
                    "databaseName": "wth-cosmos",
                    "collectionName": "productsnew",
                    "createIfNotExists": true,
                    "connectionStringSetting": "<Connection string name>",
                    "partitionKey": "/type",
                    "direction": "out",
                    "type": "cosmosDB"
                    },
                    {
                    "name": "ordersDocument",
                    "databaseName": "wth-cosmos",
                    "collectionName": "orders",
                    "createIfNotExists": true,
                    "connectionStringSetting": "<Connection string name>",
                    "partitionKey": "/type",
                    "direction": "out",
                    "type": "cosmosDB"
                    },
                    {
                    "type": "cosmosDB",
                    "name": "client",
                    "databaseName": "wth-cosmos",
                    "collectionName": "productsnew",
                    "connectionStringSetting": "<Connection string name>",
                    "direction": "inout"
                    }
                ]
            }
            ```
    9. We will now enable the function. Before doing so:
        - **Please delete** the `leases` collection that was already created. If we don't delete this, the Change Feed trigger will only get new documents and we want to get all documents (hence the `startFromBeginning: true` property in our trigger binding).
        - Once deleted, enable the function. You should now see the two new collections (`productsnew` and `orders`) getting populated with data.
- The students will need to change the queries in each page of the web application. A sample of what would be a correct application is included in the Coaches resources for Challenge 02 (although other potential solutions are also acceptable). As a suggestion, the application should be deployed in another slot. A sample script to do is included in the `/Coach/Solutions/Challenge02` folder, named `deploy.ps1` (PowerShell) or `deploy.sh` (Bash/Azure CLI). This will deploy an updated application in a new slot called `Secondary`.
- After changes are implemented and they switch to the new collection(s), they should re-run the load test in Azure Load Testing and compare the new results to the former results.
    - Prior to re-running the Load Test, please ask the students to scale their new Cosmos DB containers (assuming they came to a similar solution) to 1000 RU/s for the `orders` collection and 2000 RU/s for the `productsnew` collection.
- If they have used Deployment Slots, they should Swap the deployment slots and clean-up their existing Cosmos DB account (delete the old `products` container and the `leases` container) as well as delete the `Secondary` deployment slot. They can also delete the `ChangeFeed` Function (not the Function App as we will be using it in the next Challenge).
