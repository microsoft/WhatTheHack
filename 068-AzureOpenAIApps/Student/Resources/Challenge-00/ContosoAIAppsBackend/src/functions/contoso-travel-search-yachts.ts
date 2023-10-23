import { app, HttpRequest, HttpResponseInit, InvocationContext } from '@azure/functions';
import { AzureKeyCredential, OpenAIClient } from '@azure/openai';
import { YachtWithEmbeddings } from '../../shared/models/yachts';
import { SearchClient, SearchOptions, Vector } from '@azure/search-documents';
import { CognitiveSearchQuery } from '../../shared/models/search-query';

export async function contosoTravelSearchYachts(request: HttpRequest, context: InvocationContext): Promise<HttpResponseInit> {
  context.log(`Http function processed request for url "${request.url}"`);

  const searchObject = (await request.json()) as CognitiveSearchQuery;
  const inputQuery = searchObject.query;
  const hybridSearch = searchObject.hybridSearch ? searchObject.hybridSearch : false;

  const openAPIKey = process.env['OPENAI_API_KEY'];
  const openAIEndpoint = process.env['OPENAI_API_BASE'];
  const openAIClient = new OpenAIClient(openAIEndpoint, new AzureKeyCredential(openAPIKey));

  const azureSearchKey = process.env['AZURE_SEARCH_KEY'];
  const endpoint = process.env['AZURE_SEARCH_ENDPOINT'];
  const indexName = 'yachts';
  const credential = new AzureKeyCredential(azureSearchKey);

  const client = new SearchClient<YachtWithEmbeddings>(endpoint, indexName, credential);

  const embeddingDeployment = process.env['OPENAI_EMBEDDINGS_DEPLOYMENT'];
  const embeddingModelName = process.env['OPENAI_EMBEDDINGS_MODEL_NAME'];

  const documentEmbeddings = await openAIClient.getEmbeddings(embeddingDeployment, [inputQuery]);

  const documentEmbedding = documentEmbeddings.data[0].embedding;

  const searchText = hybridSearch ? inputQuery : '';

  const embeddingFieldName = 'descriptionEmbedding';
  const k = 2;
  const filter = null;
  const vectorDefinition: Vector<YachtWithEmbeddings>[] = [
    {
      value: documentEmbedding, // embedding vector computed on input query using Azure OpenAI Embedding Service
      fields: [embeddingFieldName], // the name of the field storing the embedding vector for this document
      kNearestNeighborsCount: k, // how many approximate neighbors are we retrieving
    },
  ];
  const searchOptions: SearchOptions<YachtWithEmbeddings> = {
    filter: filter,
    top: k,
    vectors: vectorDefinition,
  };

  const finalResults: YachtWithEmbeddings[] = [];
  const searchDocumentsResults = await client.search(searchText, searchOptions);

  for await (const item of searchDocumentsResults.results) {
    const yachtItem: YachtWithEmbeddings = item.document;
    finalResults.push(yachtItem);
  }

  console.log(searchObject);
  console.log(searchText);
  console.log(searchOptions);
  console.log(finalResults);

  return { jsonBody: finalResults };
}

app.http('contoso-travel-search-yachts', {
  methods: ['POST'],
  authLevel: 'function',
  handler: contosoTravelSearchYachts,
});
