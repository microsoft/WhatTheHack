import { app, HttpRequest, HttpResponseInit, InvocationContext } from '@azure/functions';
import { ChatMessage, FunctionDefinition, GetChatCompletionsOptions } from '@azure/openai';
import { ChatMessageInput, ChatReply } from '../../shared/models/chat';
import { OpenAIUtils } from '../../shared/utils/openai-utils';

export interface LimoReservation {
  reservationDate: string;
  numberOfPassengers: number;
}

export interface AvailabilitySearch {
  searchDate: string;
}
export function getAvailableDates() {
  const availableDates: string[] = ['2023-12-01', '2023-12-02', '2023-12-03', '2023-12-04', '2023-12-15', '2023-12-16', '2023-12-17', '2023-12-22'];
  return availableDates;
}

export function isAvailableDate(search: AvailabilitySearch) {
  const dates = getAvailableDates();
  return dates.includes(search.searchDate);
}

export function getExistingReservations() {
  const reservations: LimoReservation[] = [
    {
      reservationDate: '2023-12-02',
      numberOfPassengers: 4,
    },
    {
      reservationDate: '2023-12-07',
      numberOfPassengers: 8,
    },
    {
      reservationDate: '2023-12-19',
      numberOfPassengers: 7,
    },
  ];

  return reservations;
}

export function makeReservation(request: LimoReservation) {
  const reservationDate = request.reservationDate;
  const passengerCount = request.numberOfPassengers;
  const reservation: LimoReservation = { reservationDate: reservationDate, numberOfPassengers: passengerCount };
  return reservation;
}

export function cancelReservation(request: AvailabilitySearch) {
  const reservationDate = request.searchDate;
  const passengerCount = 0;
  const reservation: LimoReservation = { reservationDate: reservationDate, numberOfPassengers: passengerCount };
  return reservation;
}

export function getFunctionDefinitions() {
  const functionDefinitions: FunctionDefinition[] = [
    {
      name: 'getAvailableDates',
      description: 'Returns the list of available dates for limousine reservations.',
      parameters: {
        type: 'object',
        properties: {},
      },
    },
    {
      name: 'getExistingReservations',
      description: 'Returns the list of reservations the customer has already made.',
      parameters: {
        type: 'object',
        properties: {},
      },
    },
    {
      name: 'isAvailableDate',
      description: 'Returns a boolean indicating if the specified reservationDate is available for a reservation.',
      parameters: {
        type: 'object',
        properties: {
          searchDate: {
            type: 'string',
            description: 'The reservationDate the customer is interested in making a reservation',
          },
        },
        required: ['searchDate'],
      },
    },
    {
      name: 'cancelReservation',
      description: 'Cancels a pre-existing reservation for the specified reservation date',
      parameters: {
        type: 'object',
        properties: {
          searchDate: {
            type: 'string',
            description: 'The reservationDate the customer is interested in cancelling an existing reservation. Do not assume, ask the customer for which date they would like to cancel',
          },
        },
        required: ['searchDate'],
      },
    },
    {
      name: 'makeReservation',
      description: 'Creates or makes a new reservation for the specified date and number of passengers',
      parameters: {
        type: 'object',
        properties: {
          reservationDate: {
            type: 'string',
            description: 'The date of reservation in YYYY-MM-DD format. Ask the user if not obtained. Dont assume',
          },
          numberOfPassengers: {
            type: 'number',
            description: 'The total number of passengers for the reservation',
          },
        },
        required: ['reservationDate', 'numberOfPassengers'],
      },
    },
  ];
  return functionDefinitions;
}

export function getFunctionMap() {
  const funcMap = {
    getAvailableDates: getAvailableDates,
    makeReservation: makeReservation,
    getExistingReservations: getExistingReservations,
    isAvailableDate: isAvailableDate,
    cancelReservation: cancelReservation,
  };

  return funcMap;
}

export async function contosoLimos(request: HttpRequest, context: InvocationContext): Promise<HttpResponseInit> {
  const requestBody = (await request.json()) as ChatMessageInput;

  const { message } = requestBody;

  const openai = OpenAIUtils.getOpenAIClient();
  const deploymentName = process.env['OPENAI_MODEL_DEPLOYMENT'];

  const systemMessage: ChatMessage = {
    role: 'system',
    content:
      'You are smart assistant named Amina that helps customers to search for availability, make reservations and also cancel existing reservations for limousines. Please use the appropriate function to fetch the answers to the questions or take action.',
  };

  const userMessage: ChatMessage = {
    role: 'user',
    content: message,
  };

  const messages: ChatMessage[] = [systemMessage];
  messages.push(userMessage);

  const functionList = getFunctionDefinitions();
  const chatCompletionOptions: GetChatCompletionsOptions = { functions: functionList, functionCall: 'auto', temperature: 0 };

  const firstResponse = await openai.getChatCompletions(deploymentName, messages, chatCompletionOptions);

  const firstResponseMessage: ChatMessage = firstResponse.choices[0].message;

  const availableFunctions = getFunctionMap();

  if (firstResponseMessage.functionCall) {
    const functionName = firstResponseMessage.functionCall.name;
    const functionToCall = availableFunctions[functionName];
    const functionArgumentsString = firstResponseMessage.functionCall.arguments;
    const functionArgument = functionArgumentsString ? JSON.parse(functionArgumentsString) : null;

    const functionResponse = functionArgumentsString ? functionToCall(functionArgument) : functionToCall();

    const functionResponseString: string = JSON.stringify(functionResponse);

    console.log('Calling Function: ' + functionName);
    console.log('Function Arguments: ' + functionArgumentsString);
    console.log('Function Response: ' + functionResponse);

    // Adding function response to messages
    const firstResponseRole = firstResponseMessage.role;
    const firstResponseM1: ChatMessage = { role: firstResponseRole, functionCall: { name: functionName, arguments: functionArgumentsString }, content: '' };
    const firstResponseM2: ChatMessage = { role: 'function', name: functionName, content: functionResponseString };

    messages.push(firstResponseM1);
    messages.push(firstResponseM2);

    const secondResponse = await openai.getChatCompletions(deploymentName, messages, chatCompletionOptions);
    const reply = secondResponse.choices[0].message.content;

    const responseBody: ChatReply = { reply };

    console.log(messages);

    return { jsonBody: responseBody };
  }

  const reply = firstResponseMessage.content;

  const responseBody: ChatReply = { reply };

  console.log(messages);
  return { jsonBody: responseBody };
}

app.http('contoso-limos-chatbot', {
  methods: ['POST'],
  authLevel: 'function',
  handler: contosoLimos,
});
