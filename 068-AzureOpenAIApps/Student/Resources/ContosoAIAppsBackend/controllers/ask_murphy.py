import json
import logging

import azure.functions as func
from azure.functions import AuthLevel

from application_settings import ApplicationSettings, AssistantConfig, AssistantName
from shared.assistant_tools import get_current_unix_timestamp
from shared.assistant_tools_priscilla import v_list_available_activities, v_guest_has_activity_preferences_and_requests, \
    v_retrieve_guest_activity_preferences_and_requests
from shared.assistant_tools_murphy import v_is_registered_student, v_get_student_submissions, \
    v_get_student_submissions_by_date, v_get_student_submissions_by_exam_id, v_get_student_grades, \
    v_get_submission_details, v_get_submission_grade_details, v_student_has_exam_submissions, v_student_has_exam_grades
from shared.function_utils import APISuccessOK
from shared.tool_utils import ToolUtils

ask_murphy_controller = func.Blueprint()


@ask_murphy_controller.function_name("ask_murphy_assistant")
@ask_murphy_controller.route(route="assistants-ask-murphy", methods=["POST"],
                            auth_level=AuthLevel.ANONYMOUS)
def ask_murphy(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    headers = req.headers
    body = req.get_json()
    conversation_id = headers.get("x-conversation-id", "223319")
    user_question = body['message']

    settings = ApplicationSettings()
    assistant_config: AssistantConfig = settings.get_assistant_config(assistant_name=AssistantName.MURPHY)

    system_message = assistant_config["system_message"]
    tools_configuration = assistant_config["tools"]

    util = ToolUtils(AssistantName.MURPHY, system_message, tools_configuration, conversation_id)

    util.register_tool_mapping("is_registered_student",
                               v_is_registered_student)
    util.register_tool_mapping("student_has_exam_submissions",
                               v_student_has_exam_submissions)
    util.register_tool_mapping("student_has_exam_grades",
                               v_student_has_exam_grades)

    util.register_tool_mapping("get_student_submissions",
                               v_get_student_submissions)
    util.register_tool_mapping("get_student_submissions_by_date",
                               v_get_student_submissions_by_date)
    util.register_tool_mapping("get_student_submissions_by_exam_id",
                               v_get_student_submissions_by_exam_id)
    util.register_tool_mapping("get_submission_details",
                               v_get_submission_details)
    util.register_tool_mapping("get_student_grades",
                               v_get_student_grades)
    util.register_tool_mapping("get_submission_grade_details",
                               v_get_submission_grade_details)

    results = util.run_conversation(user_question)

    assistant_response = results.content

    chat_response = {"reply": assistant_response, "query": user_question}

    json_string = json.dumps(chat_response)

    current_timestamp = get_current_unix_timestamp()
    api_response = APISuccessOK(json_string)

    final_response = (api_response.add_response_header("x-assistant-name", AssistantName.MURPHY)
                      .add_response_header("x-conversation-id", conversation_id)
                      .add_response_header("x-response-id", current_timestamp))

    return final_response.build_response()

