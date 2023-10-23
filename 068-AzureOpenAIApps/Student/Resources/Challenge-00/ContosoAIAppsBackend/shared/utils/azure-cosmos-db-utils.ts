import { CosmosClient, FeedOptions, SqlQuerySpec } from '@azure/cosmos';

export class AzureCosmosDbUtil<T> {
  private readonly client: CosmosClient;

  private readonly databaseName: string;

  private readonly containerName: string;
  public constructor(database: string, container: string) {
    const cosmosDBConnectionString = process.env['COSMOS_DB_CONNECTION'];
    this.client = new CosmosClient(cosmosDBConnectionString);
    this.databaseName = database;
    this.containerName = container;
  }

  private getDatabase(databaseName: string) {
    return this.client.database(databaseName);
  }

  private getContainer(containerName: string) {
    return this.getDatabase(this.databaseName).container(containerName);
  }
  public async getItem(id: string) {
    const container = this.getContainer(this.containerName);

    const result = await container.item(id).read<T>();

    return result;
  }

  public async createItem(item: T) {
    const container = this.getContainer(this.containerName);

    const response = await container.items.create(item);

    return response;
  }

  public async updateItem(id: string, item: T) {
    const container = this.getContainer(this.containerName);

    const response = await container.items.upsert(item);

    return response;
  }

  public async deleteItem(id: string) {
    const container = this.getContainer(this.containerName);

    const response = await container.item(id).delete();

    return response;
  }

  public async queryItems(sql: string | SqlQuerySpec) {
    const container = this.getContainer(this.containerName);
    const result = await container.items.query(sql).fetchAll();
    return result.resources as T[];
  }
}
