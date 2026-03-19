### Uploading Cosmos DB Contents

We can use the following steps to upload the Cosmos DB container contents. First you will need to login to the Azure CLI.

````bash

az login

````

#### Batch Document Uploads

We can upload the departments, product_pricing and product_skus datasets to Cosmos DB using the Azure CLI commands. The script `azure_cosmos_upload.sh` automates this process.

Make sure you have set the required environment variables:
- `AZURE_COSMOS_DB_ACCOUNT_NAME`: The name of your Cosmos DB account
- `AZURE_COSMOS_DB_DATABASE_NAME`: The name of your Cosmos DB database (typically "retailstore")

Then run:

````bash
./azure_cosmos_upload.sh
````