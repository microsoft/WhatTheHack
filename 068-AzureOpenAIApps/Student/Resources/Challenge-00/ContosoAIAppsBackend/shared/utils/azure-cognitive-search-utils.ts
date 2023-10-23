import { AzureKeyCredential } from '@azure/core-auth';
import { SearchClient, SearchOptions, Vector } from '@azure/search-documents';
import { YachtWithEmbeddings } from '../models/yachts';

export class AzureCognitiveSearchUtil<T extends YachtWithEmbeddings> {
  private readonly client: SearchClient<T>;
  public constructor(index: string) {
    const azureSearchKey = process.env['AZURE_SEARCH_KEY'];
    const endpoint = process.env['AZURE_SEARCH_ENDPOINT'];
    const credential = new AzureKeyCredential(azureSearchKey);

    this.client = new SearchClient<T>(endpoint, index, credential);
  }

  public async mergeOrUploadDocument(documentsToUpload: T[]) {
    const result = await this.client.mergeOrUploadDocuments(documentsToUpload);
    return result;
  }

  public async vectorSearch(queryVector: number[], vectorFieldName: string, k: number, filter: string) {
    return await this.queryWithVectorSearch('', queryVector, vectorFieldName, k, filter);
  }

  public async hybridSearch(query: string, queryVector: number[], vectorFieldName: string, k: number, filter: string) {
    return await this.queryWithVectorSearch(query, queryVector, vectorFieldName, k, filter);
  }

  private async queryWithVectorSearch(query: string, queryVector: number[], vectorFieldName: string, k: number, filter: string) {
    const vectorDefinition: Vector<object>[] = [
      {
        value: queryVector, // embedding vector computed on input query using Azure OpenAI Embedding Service
        fields: [vectorFieldName], // the name of the field storing the embedding vector for this document
        kNearestNeighborsCount: k, // how many approximate neighbors are we retrieving
      },
    ];
    const searchOptions: SearchOptions<T> = {
      filter: filter,
      top: k,
      vectors: vectorDefinition,
    } as unknown as SearchOptions<T>;

    const finalResults: T[] = [];
    const searchDocumentsResults = await this.client.search(query, searchOptions);

    for await (const item of searchDocumentsResults.results) {
      const yachtItem: T = item.document;
      finalResults.push(yachtItem);
    }
  }
}
