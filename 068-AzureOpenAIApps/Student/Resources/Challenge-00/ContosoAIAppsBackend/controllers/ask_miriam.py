import logging

import azure.functions as func
from azure.functions import AuthLevel
import json

from application_settings import ApplicationSettings, AssistantConfig, AssistantName
from shared.function_utils import APISuccessOK
from shared.tool_utils import ToolUtils
from shared.virtual_assistant_tools import get_contoso_document_vector_store, contoso_document_retrieval_hybrid, \
    get_contoso_information

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
    assistant_config: AssistantConfig = settings.get_assistant_config(assistant_name=AssistantName.ELIZABETH)

    system_message1 = assistant_config["system_message"]
    tools_config1 = assistant_config["tools"]

    util = ToolUtils(system_message1, tools_config1, conversation_id)

    util.register_tool_mapping("get_information", get_contoso_information)

    results = util.run_conversation(user_question)

    assistant_response = results.content

    chat_response = {"reply": assistant_response, "query": user_question}

    json_string = json.dumps(chat_response)

    return APISuccessOK(json_string).build_response()

