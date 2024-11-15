import json
import logging

import azure.functions as func
from azure.functions import AuthLevel

from application_settings import ApplicationSettings, AssistantConfig, AssistantName
from shared.assistant_tools import get_current_unix_timestamp
from shared.assistant_tools_common import v_check_if_customer_account_exists, v_get_customer_account_details
from shared.assistant_tools_callum import v_create_customer_account, v_get_customer_account_balance, \
    v_make_bank_account_deposit, v_make_bank_account_withdrawal
from shared.function_utils import APISuccessOK
from shared.tool_utils import ToolUtils

ask_callum_controller = func.Blueprint()


@ask_callum_controller.function_name("ask_callum_assistant")
@ask_callum_controller.route(route="assistants-ask-callum", methods=["POST"],
                             auth_level=AuthLevel.ANONYMOUS)
def ask_callum(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    headers = req.headers
    body = req.get_json()
    conversation_id = headers.get("x-conversation-id", "223319")
    user_question = body['message']

    settings = ApplicationSettings()
    assistant_config: AssistantConfig = settings.get_assistant_config(assistant_name=AssistantName.CALLUM)

    system_message = assistant_config["system_message"]
    tools_config = assistant_config["tools"]

    util = ToolUtils(AssistantName.CALLUM, system_message, tools_config, conversation_id)

    util.register_tool_mapping("check_if_customer_account_exists", v_check_if_customer_account_exists)
    util.register_tool_mapping("get_customer_account_details", v_get_customer_account_details)
    util.register_tool_mapping("create_customer_account", v_create_customer_account)
    util.register_tool_mapping("get_customer_account_balance", v_get_customer_account_balance)
    util.register_tool_mapping("make_bank_account_deposit", v_make_bank_account_deposit)
    util.register_tool_mapping("make_bank_account_withdrawal", v_make_bank_account_withdrawal)

    results = util.run_conversation(user_question)

    assistant_response = results.content

    chat_response = {"reply": assistant_response, "query": user_question}

    json_string = json.dumps(chat_response)

    current_timestamp = get_current_unix_timestamp()
    api_response = APISuccessOK(json_string)

    final_response = (api_response.add_response_header("x-assistant-name", AssistantName.CALLUM)
                      .add_response_header("x-conversation-id", conversation_id)
                      .add_response_header("x-response-id", current_timestamp))

    return final_response.build_response()

