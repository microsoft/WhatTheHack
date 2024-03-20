from __future__ import annotations

import redis
import json
import os
import time
from typing import Iterable, Any

from openai import AzureOpenAI
from openai.resources import Files
from openai.types.beta import CodeInterpreterToolParam, RetrievalToolParam, FunctionToolParam
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
        self.client = AzureOpenAI(
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
        return self.client.files

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

    def initialize_assistant(self, assistant_name: str,
                             assistant_instructions: str,
                             assistant_tools: Iterable[
                                 CodeInterpreterToolParam | RetrievalToolParam | FunctionToolParam]) -> str:
        """Creates a new Assistant from the current client"""
        # You must configure this environment variable  with the deployment name for your model.
        model_deployment_name = os.environ.get('AZURE_OPENAI_MODEL_DEPLOYMENT_NAME')

        # set up the assistant object property
        assistant = self.client.beta.assistants.create(
            name=assistant_name,
            instructions=assistant_instructions,
            tools=assistant_tools,
            model=model_deployment_name
        )

        self.assistant_id = assistant.id
        return self.assistant_id

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

            azure_openai_run_delay = os.environ.get('AZURE_OPENAI_RUN_RETRIEVAL_DELAY_SECONDS', 5)
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

    def register_function_definition(self, function_name: str, function_definition: Any, tool_definition: Any):
        self.function_mapping[function_name] = function_definition
        self.tool_definitions.append(tool_definition)

        return self

    def register_file_bytes(self, file_content_bytes: bytes):
        result = self.client.files.create(file=file_content_bytes, purpose="assistants")
        return result

    def register_file_string(self, file_content_string: str):
        self.client.files.create(file=str.encode(file_content_string), purpose="assistants")
