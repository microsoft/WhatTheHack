import { app, HttpRequest, HttpResponseInit, InvocationContext } from '@azure/functions';
import { OpenAIUtils } from '../../shared/utils/openai-utils';
import { ChatMessageInput } from '../../shared/models/chat';
import { ChatMessage } from '@azure/openai';

export async function openaiChatbot(request: HttpRequest, context: InvocationContext): Promise<HttpResponseInit> {
  context.log(`Http function processed request for url "${request.url}"`);

  const requestBody = (await request.json()) as ChatMessageInput;

  const { message } = requestBody;

  const openai = OpenAIUtils.getOpenAIClient();
  const deploymentName = process.env['OPENAI_MODEL_DEPLOYMENT'];

  const messages: ChatMessage[] = [
    { role: 'system', content: 'You are a helpful assistant named Pedro.' },
    { role: 'user', content: message },
  ];

  const completion = await openai.getChatCompletions(deploymentName, messages);

  const reply = completion.choices[0].message.content;

  const responseBody = { reply };

  return { jsonBody: responseBody };
}

app.http('openai-chatbot', {
  methods: ['POST'],
  authLevel: 'function',
  handler: openaiChatbot,
});
