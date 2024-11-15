import os
from typing import Callable, Any

from openai import AzureOpenAI
import json

from openai.types.chat import ChatCompletionToolParam, ChatCompletion, ChatCompletionMessageParam, \
    ChatCompletionFunctionMessageParam, ChatCompletionToolMessageParam, ChatCompletionAssistantMessageParam, \
    ChatCompletionSystemMessageParam, ChatCompletionUserMessageParam, ChatCompletionMessage
from openai.types.chat.completion_create_params import ResponseFormat

from application_settings import AssistantName
from shared.redis_utils import RedisUtil


class ToolUtils:

    def __init__(self, assistant_name: AssistantName, system_message: str, tools: list[ChatCompletionToolParam],
                 conversation_id: str):
        azure_openai_endpoint = os.environ.get('AZURE_OPENAI_ENDPOINT')
        azure_openai_api_key = os.environ.get('AZURE_OPENAI_API_KEY')
        azure_openai_api_version = os.environ.get('AZURE_OPENAI_VERSION_NUMBER')
        azure_openai_model_deployment_name = os.environ.get('AZURE_OPENAI_MODEL_DEPLOYMENT_NAME')

        self.client = AzureOpenAI(
            azure_endpoint=azure_openai_endpoint,
            api_key=azure_openai_api_key,
            api_version=azure_openai_api_version,
        )

        self.model_deployment_name = azure_openai_model_deployment_name

        self.system_message = system_message
        self.tools = tools
        self.tool_mappings: dict[str, Callable[..., str]] = {}
        self.response_format: ResponseFormat = {"type": "text"}

        self.assistant_name = "assistant_{}".format(assistant_name)
        self.conversation_id = conversation_id

    def set_response_format_text(self):
        self.response_format: ResponseFormat = {"type": "text"}
        return self

    def set_response_format_json(self):
        self.response_format: ResponseFormat = {"type": "json_object"}
        return self

    def register_tool_mapping(self, tool_name: str, tool_definition: Callable[..., str]):
        """"""
        self.tool_mappings[tool_name] = tool_definition
        return self

    def _prepare_lookup_key(self) -> str:
        lookup_key = self.assistant_name + "_chat_messages_" + self.conversation_id
        return lookup_key

    def retrieve_previous_messages(self):
        lookup_key = self._prepare_lookup_key()

        redis_util = RedisUtil()
        messages = redis_util.l_range_json_all(lookup_key)
        return messages

    def append_new_message(self, message: ChatCompletionUserMessageParam | ChatCompletionAssistantMessageParam):
        lookup_key = self._prepare_lookup_key()
        redis_util = RedisUtil()
        redis_util.r_push_json(lookup_key, message)

    def run_conversation(self, user_message: str) -> ChatCompletionMessage:

        previous_messages = self.retrieve_previous_messages()

        print(previous_messages)

        defined_tools: list[ChatCompletionToolParam] = self.tools

        user_message_object: ChatCompletionUserMessageParam = {"role": "user", "content": user_message}

        latest_messages = [
            {"role": "system", "content": self.system_message},
            user_message_object
        ]

        self.append_new_message(user_message_object)

        messages: list[ChatCompletionMessage | ChatCompletionSystemMessageParam | ChatCompletionUserMessageParam |
                       ChatCompletionAssistantMessageParam | ChatCompletionToolMessageParam |
                       ChatCompletionFunctionMessageParam] = []

        if previous_messages and len(previous_messages) > 0:
            messages = previous_messages + latest_messages
        else:
            messages = latest_messages

        response: ChatCompletion = self.client.chat.completions.create(
            model=self.model_deployment_name,
            messages=messages,
            tools=defined_tools,
            tool_choice="auto",  # auto is default, but we'll be explicit,
            response_format=self.response_format,
            temperature=0.0
        )

        response_message: ChatCompletionMessage = response.choices[0].message

        final_answer = response_message

        tool_calls = response_message.tool_calls

        if tool_calls:
            available_functions = self.tool_mappings
            messages.append(response_message)  # extend conversation with assistant's reply
            for tool_call in tool_calls:
                function_name = tool_call.function.name
                function_to_call = available_functions[function_name]
                function_args = json.loads(tool_call.function.arguments)
                function_response = function_to_call(**function_args)

                messages.append(
                    {
                        "tool_call_id": tool_call.id,
                        "role": "tool",
                        "name": function_name,
                        "content": function_response,
                    }
                )
            # end of loop [ for tool_call in tool_calls: ]

            # extend conversation with function response
            second_response: ChatCompletion = self.client.chat.completions.create(
                model=self.model_deployment_name,
                messages=messages,
                response_format=self.response_format,
                temperature=0.0
            )  # get a new response from the model where it can see the function response

            second_answer: ChatCompletionMessage = second_response.choices[0].message

            final_answer = second_answer

        content_string = final_answer.content
        content_to_save : ChatCompletionAssistantMessageParam = {"role": "assistant", "content": content_string}

        self.append_new_message(content_to_save)
        return final_answer
