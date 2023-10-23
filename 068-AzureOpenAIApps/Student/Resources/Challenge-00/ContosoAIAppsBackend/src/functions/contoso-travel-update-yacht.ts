import { app, HttpRequest, HttpResponseInit, InvocationContext } from '@azure/functions';
import { AzureKeyCredential } from '@azure/core-auth';
import { Yacht, YachtWithEmbeddings } from '../../shared/models/yachts';
import { SearchClient } from '@azure/search-documents';
import { OpenAIClient } from '@azure/openai';

export async function contosoTravelUpdateYacht(request: HttpRequest, context: InvocationContext): Promise<HttpResponseInit> {
  context.log(`Http function processed request for url "${request.url}"`);

  const openAPIKey = process.env['OPENAI_API_KEY'];
  const openAIEndpoint = process.env['OPENAI_API_BASE'];
  const openAIClient = new OpenAIClient(openAIEndpoint, new AzureKeyCredential(openAPIKey));

  const azureSearchKey = process.env['AZURE_SEARCH_KEY'];
  const endpoint = process.env['AZURE_SEARCH_ENDPOINT'];
  const indexName = 'yachts';
  const credential = new AzureKeyCredential(azureSearchKey);

  const requestBody = (await request.json()) as Yacht;

  const client = new SearchClient<YachtWithEmbeddings>(endpoint, indexName, credential);

  const embeddingDeployment = process.env['OPENAI_EMBEDDINGS_DEPLOYMENT'];
  const embeddingModelName = process.env['OPENAI_EMBEDDINGS_MODEL_NAME'];

  const documentEmbeddings = await openAIClient.getEmbeddings(embeddingDeployment, [requestBody.description]);

  const documentEmbedding = documentEmbeddings.data[0].embedding;

  const yachtDocument: YachtWithEmbeddings = { descriptionEmbedding: documentEmbedding, ...requestBody };

  const documentsToUpload = [yachtDocument];

  const result = await client.mergeOrUploadDocuments(documentsToUpload);

  return { jsonBody: result };
}

app.http('contoso-travel-update-yacht', {
  methods: ['PUT'],
  authLevel: 'function',
  handler: contosoTravelUpdateYacht,
});
