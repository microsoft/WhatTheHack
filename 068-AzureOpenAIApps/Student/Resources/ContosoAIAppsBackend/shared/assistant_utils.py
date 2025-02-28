from __future__ import annotations

import json
import os
import time
from typing import Iterable, Any

from openai import AzureOpenAI as AIFluencyAzureOpenAI
from openai.resources import Files
from openai.types.beta import CodeInterpreterToolParam, FunctionToolParam
from openai.types.beta.threads import Run

from shared.redis_utils import RedisUtil


class AssistantUtil:
    # Class Variables
    OPEN_AI_THREADS_LOOKUP_KEY = 'openai_assistant_threads'

    def __init__(self, thread_id=None, assistant_id=None):
        """Constructor for AssistantUtil class"""

        # Instance variables
        self.run = None
        self.thread_id = thread_id
        self.assistant_id = assistant_id
        self.function_mapping = {}
        self.tool_definitions = []

        # Retrieving environment variables
        azure_open_api_key = os.environ.get('AZURE_OPENAI_API_KEY')
        azure_open_api_version_number = os.environ.get('AZURE_OPENAI_VERSION_NUMBER')
        azure_open_api_endpoint = os.environ.get('AZURE_OPENAI_ENDPOINT')

        # Create a client property
        self.client = AIFluencyAzureOpenAI(
            api_key=azure_open_api_key,
            api_version=azure_open_api_version_number,
            azure_endpoint=azure_open_api_endpoint)

        # Create the Redis Util
        self.redis_util = RedisUtil()

    def list_threads(self):
        """Azure OpenAI clients have no means of tracking the threads, so we need to track it with Redis Cache"""
        return self.redis_util.l_range(AssistantUtil.OPEN_AI_THREADS_LOOKUP_KEY, 0, -1)

    def list_assistants(self):
        """Returns a list of all the solutions"""
        assistants = self.client.beta.assistants.list()
        results = []

        for assistant in assistants:
            results.append(assistant)

        return results

    def list_files(self) -> Files:
        """Returns a list of files uploaded to OpenAI"""
        return self.client.files.list()

    def list_messages(self):
        current_thread_identifier = self.thread_id
        messages = self.client.beta.threads.messages.list(thread_id=current_thread_identifier)
        return messages

    def initialize_thread(self) -> str:
        """Creates a new Thread from the current client"""

        # create a thread_id property
        thread = self.client.beta.threads.create()
        self.thread_id = thread.id

        self.redis_util.l_push(AssistantUtil.OPEN_AI_THREADS_LOOKUP_KEY, self.thread_id)
        # returns the thread identifier
        return self.thread_id

    def initialize_assistant(self, assistant_name: str, description: str) -> str:
        """Creates a new Assistant from the current client"""
        # You must configure this environment variable  with the deployment name for your model.
        model_deployment_name = os.environ.get('AZURE_OPENAI_MODEL_DEPLOYMENT_NAME')

        # set up the assistant object property
        assistant = self.client.beta.assistants.create(
            name=assistant_name,
            description=description,
            model=model_deployment_name
        )

        self.assistant_id = assistant.id
        return self.assistant_id

    def load_assistant_tools(self, instructions: str):
        """Updates the assistant with the tools previously registered with the assistant utility"""

        assistant_id = self.assistant_id
        assistant_tools = self.tool_definitions
        files = ["'assistant-sXr1hAkT4j3z1fkk0Ahlsmk9"]
        assistant = self.client.beta.assistants.update(assistant_id=assistant_id, file_ids=files,
                                                       instructions=instructions, tools=[{"type": "retrieval"}])

        return assistant.id

    def add_user_message(self, user_message):
        """Adds a message to the thread"""
        # Add a user question to the thread
        message = self.client.beta.threads.messages.create(
            thread_id=self.thread_id,
            role="user",
            content=user_message
        )

    def run_thread(self):
        """Creates a run for the current thread id and assistant id"""
        current_thread_identifier = self.thread_id
        current_assistant_identifier = self.assistant_id

        # Run the thread for the assistant id for the most recent message
        self.run = self.client.beta.threads.runs.create(thread_id=current_thread_identifier,
                                                        assistant_id=current_assistant_identifier)

    def retrieve_run_status(self):
        """Retrieves the run status"""
        current_thread_identifier = self.thread_id
        current_run_identifier = self.run.id

        # Retrieve the status of the run
        self.run = self.client.beta.threads.runs.retrieve(
            thread_id=current_thread_identifier,
            run_id=current_run_identifier
        )

        status = self.run.status

        # ["queued", "in_progress", "requires_action", "cancelling", "cancelled", "failed", "completed", "expired"]
        # Wait till the assistant has responded
        while status not in ["completed", "cancelled", "expired", "failed"]:

            azure_openai_run_delay = int(os.environ.get('AZURE_OPENAI_RUN_RETRIEVAL_DELAY_SECONDS', "5"))
            time.sleep(azure_openai_run_delay)

            self.run = self.client.beta.threads.runs.retrieve(thread_id=current_thread_identifier, run_id=self.run.id)
            status = self.run.status

            if status == "requires_action":
                current_tool_outputs = self.__read_functions_and_execute_functions(self.run)
                self.run = self.client.beta.threads.runs.submit_tool_outputs(thread_id=current_thread_identifier,
                                                                             run_id=self.run.id,
                                                                             tool_outputs=current_tool_outputs)
                status = self.run.status

        return status

    def __read_functions_and_execute_functions(self, run: Run):
        """A private method used internally to read and execute the functions """
        # list of dictionaries with the fields tool_call_id and output string values
        tool_outputs = []
        tool_calls = run.required_action.submit_tool_outputs.tool_calls

        for tool_call in tool_calls:
            tool_call_id = tool_call.id
            function_name = tool_call.function.name
            function_arguments_string = tool_call.function.arguments
            function_arguments_object = json.loads(function_arguments_string)

            function_to_call = self.function_mapping[function_name]

            # compute the function result from the function map
            function_response = function_to_call(**function_arguments_object)

            # append the result to the list of results
            tool_outputs.append({"tool_call_id": tool_call_id, "output": function_response})

        return tool_outputs

    def register_tool_and_function_definitions(self, function_name: str,
                                               tool_definition: CodeInterpreterToolParam | FunctionToolParam,
                                               function_definition: Any = None):

        self.tool_definitions.append(tool_definition)

        if function_definition:  # if the callable function has been defined, then register it in the dictionary
            self.function_mapping[function_name] = function_definition

        return self

    def register_file_bytes(self, file_content_bytes: bytes) -> str:
        result = self.client.files.create(file=file_content_bytes, purpose="assistants")
        return result.id

    def register_file_string(self, file_content_string):
        return self.register_file_bytes(str.encode(file_content_string))

    def attach_file_to_assistant(self, file_id: str):
        assistant_identifier = self.assistant_id
        file_identifier = file_id
        file_response = self.client.beta.assistants.files.create(assistant_identifier, file_id=file_identifier)
        return file_response.id

    def detach_file_from_assistant(self, file_id: str):
        assistant_identifier = self.assistant_id
        file_identifier = file_id
        file_response = self.client.beta.assistants.files.delete(file_identifier, assistant_id=assistant_identifier)
        return file_response.id