import json

import azure.functions as func
from azure.functions import AuthLevel

from models.students import StudentSearchResponse
from shared.cosmos_db_utils import CosmosDbUtils
from shared.function_utils import APISuccessOK, APINotFound, APIBadRequest
from shared.logging_utils import LoggingUtils
from shared.student_management_utils import student_management_get_details, student_management_list_students
from shared.yacht_management_utils import remove_non_alphanumeric

students_crud_controller = func.Blueprint()


@students_crud_controller.function_name("students_management_controller")
@students_crud_controller.route(route="students-management/{studentId?}", methods=["GET", "PUT", "POST", "DELETE"],
                                auth_level=AuthLevel.FUNCTION)
def students_mgmt_controller(req: func.HttpRequest) -> func.HttpResponse:

    request_method = req.method.upper()
    LoggingUtils.track_event("STUDENT_CONTROLLER", {"cosmos": "1", "db": "2", "a": "False"})

    if request_method == "GET":
        return handle_get_request(req)
    elif request_method == "PUT":
        return handle_put_request(req)
    elif request_method == "POST":
        return handle_post_request(req)
    elif request_method == "DELETE":
        return handle_delete_request(req)


def handle_delete_request(request: func.HttpRequest):
    cosmos_util = CosmosDbUtils("students")
    student_id = request.route_params.get('studentId', None)

    LoggingUtils.track_event("DELETE_STUDENT", {"student_id": student_id})
    if student_id is not None:
        student_details: StudentSearchResponse = student_management_get_details(student_id)
        print("This is the yacht object that was retrieved from the backend database for yacht id {} {}".format(
            student_id, student_details))
        if student_details:
            record_identifier = student_details['id']
            student_id = remove_non_alphanumeric(student_id)
            cosmos_util.delete_item(record_identifier, student_id)

            message = "Student id {} has been deleted from the databases".format(student_id)
            confirmation_message = {
                "studentId": student_id,
                "confirmationMessage": message
            }
            response = json.dumps(confirmation_message)
            return APISuccessOK(response).build_response()
        else:
            message = {"message": "No student matches identifier provided", "student_id": student_id}

            response = json.dumps(message)
            return APINotFound(response).build_response()

    message = {"message": "A valid student identifier is required for this operation", "student_id": student_id}
    response = json.dumps(message)
    return APIBadRequest(response).build_response()


def handle_put_request(request: func.HttpRequest):

    student_object: StudentSearchResponse = request.get_json()
    student_id = student_object["studentId"]

    student_object['id'] = str(student_id)

    cosmos_util = CosmosDbUtils("students")

    LoggingUtils.track_event("UPDATE_STUDENT", {"student_id": student_id})

    student_details = cosmos_util.upsert_item(student_object)
    response = json.dumps(student_details)
    return APISuccessOK(response).build_response()


def handle_post_request(request: func.HttpRequest):
    student_objects: list[StudentSearchResponse] = request.get_json()

    results = []

    cosmos_util = CosmosDbUtils("students")

    LoggingUtils.track_event("BULK_STUDENT_UPLOAD", {"total_students": str(len(student_objects))})
    # loop through array
    for student_object in student_objects:
        student_id = student_object["studentId"]
        student_object['id'] = str(student_id)

        student_details = cosmos_util.upsert_item(student_object)
        results.append(student_details)

    response = json.dumps(results)

    return APISuccessOK(response).build_response()


def handle_get_request(request: func.HttpRequest):

    student_identifier = request.route_params.get('studentId', None)

    print("Student identifier for GET Request : {}".format(student_identifier))
    if student_identifier is not None:
        student_details = student_management_get_details(student_identifier)
        if student_details is not None:
            response = json.dumps(student_details)
            LoggingUtils.track_event("RETRIEVE_SINGLE_STUDENT", {"student_id": student_identifier})
            return APISuccessOK(response).build_response()
        else:
            message = {"message": "No student matches yacht identifier provided", "student id": student_identifier}
            response = json.dumps(message)
            return APINotFound(response).build_response()
    else:
        students = student_management_list_students()
        LoggingUtils.track_event("RETRIEVE_STUDENT_LIST", {"student_count": str(len(students))})
        list_response = {
            "count": len(students),
            "students": students,
        }

        response = json.dumps(list_response)
        return APISuccessOK(response).build_response()
