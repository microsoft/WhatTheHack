# Challenge 03 - Automate Order Processing- Coach's Guide 

[< Previous Solution](./Solution-02.md) - **[Home](./README.md)** - [Next Solution >](./Solution-04.md)

## Notes & Guidance

For this challenge, students will need to leverage the Change Feed again, this time though to continuously get any Order item. If they created a collection just for the Order items, they can simply get every document created with a status of `Pending Shipment`, add an item in the `Shipments` collection and update the item with a status of `Shipped`.

Example of a solution:
1. Create a new Azure Function (in the existing Function App or a new one):  
    - Name: `OrderProcessor` (for example)
    - Development environment: Develop in portal
    - Template: Azure Cosmos DB trigger
    - Set the correct Cosmos DB account connection, database name (`wth-cosmos`) and collection name (`orders`)
    - Set a name for the lease collection (default of `leases` is ok)
    - Enable the "Create lease collection if it does not exist" option
2. Disable the new Function (we will set the `StartFromBeginning` option)
3. Use the following code:
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

      public class Shipment: Document
      {
          [JsonProperty(PropertyName = "customerId")]
          public string CustomerId { get; set; }

          [JsonProperty(PropertyName = "storeId")]
          public int StoreId { get; set; }

          [JsonProperty(PropertyName = "orderId")]
          public string OrderId { get; set; }

          [JsonProperty(PropertyName = "shippedOn")]
          public DateTime ShippedOn { get; set; }

          [JsonProperty(PropertyName = "type")]
          public string Type => $"Shipment-{CustomerId}";
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

          public CustomerOrder() : base() {}
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

          public CustomerCart(): base() {}
      }

      public static async Task Run(IReadOnlyList<Document> input,
                                  IAsyncCollector<Shipment> shipmentDocument,
                                  DocumentClient client,
                                  ILogger log)
      {
          if (input != null && input.Count > 0)
          {
              foreach(var doc in input)
              {
                  var status = "";

                  try
                  {
                      status = doc.GetPropertyValue<string>("status");
                  }
                  catch(Exception ex){}

                  if(!String.IsNullOrWhiteSpace(status) || status == "Pending Shipment"){
                      log.LogInformation($"Processing order document");

                      // Add a new Shipment document
                      var shipment = new Shipment{
                          CustomerId = doc.GetPropertyValue<string>("customerId"),
                          StoreId = doc.GetPropertyValue<int>("storeId"),
                          OrderId = doc.GetPropertyValue<string>("id"),
                          ShippedOn = DateTime.Now
                      };

                      await shipmentDocument.AddAsync(shipment);

                      var id = doc.Id;

                      Uri collectionUri = UriFactory.CreateDocumentCollectionUri("wth-cosmos", "orders");
                      var orderItem = client.CreateDocumentQuery<CustomerOrder>(collectionUri)
                          .Where(p => p.Id == id && p.Type == $"CustomerOrder-{doc.GetPropertyValue<string>("customerId")}")
                          .AsEnumerable()
                          .SingleOrDefault();

                      if(orderItem != null)
                      {                    
                          orderItem.SetPropertyValue("status", "Shipped");
                          await client.ReplaceDocumentAsync(orderItem);
                      }
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
            "collectionName": "orders",
            "leaseCollectionName": "leases",
            "startFromBeginning": true,
            "createLeaseCollectionIfNotExists": true
          },
          {
            "name": "shipmentDocument",
            "databaseName": "wth-cosmos",
            "collectionName": "shipments",
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
            "collectionName": "orders",
            "connectionStringSetting": "<Connection string name>",
            "direction": "inout"
          }
        ]
      }
      ```
4. If the students now navigate to the `Shipments` page, they should see Shipments getting populated. Conversely, they should see the Status on the `Orders` page of each order changing to `Shipped` once the trigger fires.
