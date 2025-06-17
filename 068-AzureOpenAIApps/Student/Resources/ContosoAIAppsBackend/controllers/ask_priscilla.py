import json
import logging

import azure.functions as func
from azure.functions import AuthLevel

from application_settings import ApplicationSettings, AssistantConfig, AssistantName
from shared.assistant_tools import get_current_unix_timestamp
from shared.assistant_tools_priscilla import v_list_available_activities, v_guest_has_activity_preferences_and_requests, \
    v_retrieve_guest_activity_preferences_and_requests
from shared.function_utils import APISuccessOK
from shared.tool_utils import ToolUtils

ask_priscilla_controller = func.Blueprint()


@ask_priscilla_controller.function_name("ask_priscilla_assistant")
@ask_priscilla_controller.route(route="assistants-ask-priscilla", methods=["POST"],
                                auth_level=AuthLevel.ANONYMOUS)
def ask_priscilla(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    headers = req.headers
    body = req.get_json()
    conversation_id = headers.get("x-conversation-id", "223319")
    user_question = body['message']

    settings = ApplicationSettings()
    assistant_config: AssistantConfig = settings.get_assistant_config(assistant_name=AssistantName.PRISCILLA)

    system_message = assistant_config["system_message"]
    tools_configuration = assistant_config["tools"]

    util = ToolUtils(AssistantName.PRISCILLA, system_message, tools_configuration, conversation_id)

    util.register_tool_mapping("list_available_activities",
                               v_list_available_activities)
    util.register_tool_mapping("guest_has_activity_preferences_and_requests",
                               v_guest_has_activity_preferences_and_requests)
    util.register_tool_mapping("retrieve_guest_activity_preferences_and_requests",
                               v_retrieve_guest_activity_preferences_and_requests)

    results = util.run_conversation(user_question)

    assistant_response = results.content

    chat_response = {"reply": assistant_response, "query": user_question}

    json_string = json.dumps(chat_response)

    current_timestamp = get_current_unix_timestamp()
    api_response = APISuccessOK(json_string)

    final_response = (api_response.add_response_header("x-assistant-name", AssistantName.PRISCILLA)
                      .add_response_header("x-conversation-id", conversation_id)
                      .add_response_header("x-response-id", current_timestamp))

    return final_response.build_response()

