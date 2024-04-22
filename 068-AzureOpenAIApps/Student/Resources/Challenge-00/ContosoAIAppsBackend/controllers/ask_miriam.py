import logging

import azure.functions as func
from azure.functions import AuthLevel
import json

from application_settings import ApplicationSettings, AssistantConfig, AssistantName
from shared.assistant_tools_miriam import v_get_yacht_details
from shared.function_utils import APISuccessOK
from shared.tool_utils import ToolUtils
from shared.assistant_tools import get_contoso_document_vector_store, contoso_document_retrieval_hybrid, \
    get_contoso_information, get_current_unix_timestamp

ask_miriam_controller = func.Blueprint()


@ask_miriam_controller.function_name("ask_miriam_assistant")
@ask_miriam_controller.route(route="assistants-ask-miriam", methods=["POST"],
                             auth_level=AuthLevel.ANONYMOUS)
def ask_miriam(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    headers = req.headers
    body = req.get_json()
    conversation_id = headers.get("x-conversation-id", "223319")
    user_question = body['message']

    settings = ApplicationSettings()
    assistant_config: AssistantConfig = settings.get_assistant_config(assistant_name=AssistantName.MIRIAM)

    system_message1 = assistant_config["system_message"]
    tools_config1 = assistant_config["tools"]

    util = ToolUtils(AssistantName.MIRIAM, system_message1, tools_config1, conversation_id)

    util.register_tool_mapping("get_yacht_details", v_get_yacht_details)

    results = util.run_conversation(user_question)

    assistant_response = results.content

    chat_response = {"reply": assistant_response, "query": user_question}

    json_string = json.dumps(chat_response)

    current_timestamp = get_current_unix_timestamp()
    api_response = APISuccessOK(json_string)

    final_response = (api_response.add_response_header("x-assistant-name", AssistantName.MIRIAM)
                      .add_response_header("x-conversation-id", conversation_id)
                      .add_response_header("x-response-id", current_timestamp))

    return final_response.build_response()

