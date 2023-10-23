import { app, CosmosDBFunctionOptions, CosmosDBv4FunctionOptions, InvocationContext } from '@azure/functions';
import { Yacht } from '../../shared/models/yachts';

export async function azureCosmosDBMonitor(documents: Yacht[], context: InvocationContext): Promise<void> {
  context.log(`Cosmos DB function processed ${documents.length} documents`);

  for await (const currentDoc of documents) {
    console.log('Current Document is displayed');
    console.log(currentDoc);
  }
}

const options: CosmosDBv4FunctionOptions = {
  connection: 'COSMOS_DB_CONNECTION',
  databaseName: 'contosodb',
  containerName: 'yachts',
  createLeaseContainerIfNotExists: true,
  handler: azureCosmosDBMonitor,
};

app.cosmosDB('azure-cosmos-db-monitor', options);
