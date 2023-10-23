import { OpenAIClient, AzureKeyCredential } from '@azure/openai';

export class OpenAIUtils {
  public static getOpenAIClient() {
    const openAPIKey = process.env['OPENAI_API_KEY'];
    const openAIEndpoint = process.env['OPENAI_API_BASE'];
    const openAIClient = new OpenAIClient(openAIEndpoint, new AzureKeyCredential(openAPIKey));

    return openAIClient;
  }
}
export class EmbeddingUtils {
  private static getEmbeddingDeployment() {
    const embeddingDeployment = process.env['OPENAI_EMBEDDINGS_DEPLOYMENT'];
    return embeddingDeployment;
  }
  public static async getEmbeddings(inputs: string[]) {
    const client = OpenAIUtils.getOpenAIClient();
    const documentEmbeddings = await client.getEmbeddings(EmbeddingUtils.getEmbeddingDeployment(), inputs);
    return documentEmbeddings;
  }

  public static async getSingleEmbedding(input: string) {
    const inputs: string[] = [input];

    const embeddingResults = await EmbeddingUtils.getEmbeddings(inputs);

    return embeddingResults.data[0].embedding;
  }
}
