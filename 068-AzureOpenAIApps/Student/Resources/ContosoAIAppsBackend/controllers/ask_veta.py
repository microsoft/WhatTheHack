import logging

import azure.functions as func
from azure.functions import AuthLevel
import json

from application_settings import ApplicationSettings, AssistantConfig, AssistantName
from shared.assistant_tools_common import v_check_if_customer_account_exists
from shared.assistant_tools_veta import v_get_yacht_details, v_bank_account_balance_is_sufficient, \
    v_calculate_reservation_grand_total_amount, v_get_bank_account_balance, \
    v_yacht_travel_party_size_within_capacity, v_get_valid_reservation_search_dates, v_yacht_is_available_for_date, \
    v_is_valid_search_date, v_get_yacht_availability_by_id, v_get_yacht_availability_by_date, \
    v_yacht_reservation_exists, v_get_reservation_details, v_cancel_yacht_reservation, \
    v_get_customer_yacht_reservations, v_create_yacht_reservation
from shared.function_utils import APISuccessOK
from shared.tool_utils import ToolUtils
from shared.assistant_tools import get_contoso_document_vector_store, contoso_document_retrieval_hybrid, \
    get_contoso_information, get_current_unix_timestamp

ask_veta_controller = func.Blueprint()


@ask_veta_controller.function_name("ask_veta_assistant")
@ask_veta_controller.route(route="assistants-ask-veta", methods=["POST"],
                             auth_level=AuthLevel.ANONYMOUS)
def ask_veta(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    headers = req.headers
    body = req.get_json()
    conversation_id = headers.get("x-conversation-id", "223319")
    user_question = body['message']

    settings = ApplicationSettings()
    assistant_config: AssistantConfig = settings.get_assistant_config(assistant_name=AssistantName.VETA)

    system_message1 = assistant_config["system_message"]
    tools_config1 = assistant_config["tools"]

    util = ToolUtils(AssistantName.VETA, system_message1, tools_config1, conversation_id)

    util.register_tool_mapping("check_if_customer_account_exists", v_check_if_customer_account_exists)
    util.register_tool_mapping("get_yacht_details", v_get_yacht_details)
    util.register_tool_mapping("calculate_reservation_grand_total_amount", v_calculate_reservation_grand_total_amount)
    util.register_tool_mapping("yacht_travel_party_size_within_capacity", v_yacht_travel_party_size_within_capacity)
    util.register_tool_mapping("get_bank_account_balance", v_get_bank_account_balance)
    util.register_tool_mapping("bank_account_balance_is_sufficient", v_bank_account_balance_is_sufficient)
    util.register_tool_mapping("get_valid_reservation_search_dates", v_get_valid_reservation_search_dates)
    util.register_tool_mapping("yacht_is_available_for_date", v_yacht_is_available_for_date)
    util.register_tool_mapping("is_valid_search_date", v_is_valid_search_date)
    util.register_tool_mapping("get_yacht_availability_by_id", v_get_yacht_availability_by_id)
    util.register_tool_mapping("get_yacht_availability_by_date", v_get_yacht_availability_by_date)
    util.register_tool_mapping("yacht_reservation_exists", v_yacht_reservation_exists)
    util.register_tool_mapping("get_reservation_details", v_get_reservation_details)
    util.register_tool_mapping("cancel_yacht_reservation", v_cancel_yacht_reservation)
    util.register_tool_mapping("get_customer_yacht_reservations", v_get_customer_yacht_reservations)
    util.register_tool_mapping("create_yacht_reservation", v_create_yacht_reservation)

    results = util.run_conversation(user_question)

    assistant_response = results.content

    chat_response = {"reply": assistant_response, "query": user_question}

    json_string = json.dumps(chat_response)

    current_timestamp = get_current_unix_timestamp()
    api_response = APISuccessOK(json_string)

    final_response = (api_response.add_response_header("x-assistant-name", AssistantName.VETA)
                      .add_response_header("x-conversation-id", conversation_id)
                      .add_response_header("x-response-id", current_timestamp))

    return final_response.build_response()

