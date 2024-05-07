import json
import os
from logging import getLogger, DEBUG

import azure.functions as func
from azure.functions import AuthLevel
from azure.monitor.opentelemetry import configure_azure_monitor

from shared.ai_search_utils import AISearchUtils
from shared.cosmos_db_utils import CosmosDbUtils
from shared.function_utils import APISuccessOK, APINotFound, APIBadRequest
from shared.yacht_management_utils import yacht_management_list_yachts, yacht_management_get_yacht_details, \
    remove_non_alphanumeric

configure_azure_monitor()
logger = getLogger(__name__)

yachts_crud_controller = func.Blueprint()


@yachts_crud_controller.function_name("yachts_management_controller")
@yachts_crud_controller.route(route="yachts-management/{yachtId?}", methods=["GET", "PUT", "DELETE"],
                              auth_level=AuthLevel.FUNCTION)
def yachts_management_controller(req: func.HttpRequest) -> func.HttpResponse:
    logger.info('Python HTTP trigger function processed a request.')

    request_method = req.method.upper()

    logger.info(f"Yacht REST Service Request method: {request_method}")

    if request_method == "GET":
        return handle_get_request(req)
    elif request_method == "PUT":
        return handle_put_request(req)
    elif request_method == "DELETE":
        return handle_delete_request(req)


def handle_delete_request(request: func.HttpRequest):
    cosmos_util = CosmosDbUtils("yachts")
    contoso_yachts_index_name = os.environ.get('AZURE_AI_SEARCH_CONTOSO_YACHTS_INDEX_NAME')
    ai_search_util = AISearchUtils(contoso_yachts_index_name)
    yacht_id = request.route_params.get('yachtId', None)

    print("This is the incoming yacht id: {}".format(yacht_id))
    logger.info("YachtId to be DELETED: {}".format(yacht_id))

    if yacht_id is not None:
        yacht_details = yacht_management_get_yacht_details(yacht_id)
        print("This is the yacht object that was retrieved from the backend database for yacht id {} {}".format(yacht_id, yacht_details))
        if yacht_details:
            record_identifier = yacht_details['id']
            yacht_id = remove_non_alphanumeric(yacht_id)
            cosmos_util.delete_item(record_identifier, yacht_id)
            matching_document_ids: list[str] = [yacht_id]
            ai_search_util.delete_documents(matching_document_ids, key_field_name="id")
            logger.info("YachtId {} has been DELETED".format(yacht_id))
            message = "Yacht id {} has been deleted from the databases".format(yacht_id)
            confirmation_message = {
                "yachtId": yacht_id,
                "confirmationMessage": message
            }
            response = json.dumps(confirmation_message)
            return APISuccessOK(response).build_response()
        else:
            message = {"message": "No yacht matches yacht identifier provided", "yacht_identifier": yacht_id}
            logger.info("YachtId {} was NOT FOUND".format(yacht_id))
            response = json.dumps(message)
            return APINotFound(response).build_response()

    message = {"message": "A valid yacht identifier is required for this operation", "yacht_identifier": yacht_id}
    response = json.dumps(message)
    return APIBadRequest(response).build_response()


def handle_put_request(request: func.HttpRequest):
    yacht_object = request.get_json()
    yacht_id = yacht_object["yachtId"]

    yacht_object['id'] = yacht_id

    cosmos_util = CosmosDbUtils("yachts")

    yacht_details = cosmos_util.upsert_item(yacht_object)
    response = json.dumps(yacht_details)
    logger.info("YachtId {} was UPDATED".format(yacht_id))
    return APISuccessOK(response).build_response()


def handle_get_request(request: func.HttpRequest):
    yacht_identifier = request.route_params.get('yachtId', None)

    print("Yacht identifier for GET Request : {}".format(yacht_identifier))
    if yacht_identifier is not None:
        yacht_details = yacht_management_get_yacht_details(yacht_identifier)
        print("This is the details for yacht id {} -> {}".format(yacht_identifier, yacht_details))

        if yacht_details is not None:
            response = json.dumps(yacht_details)
            logger.info("Single Yacht Retrieval for {}".format(yacht_identifier))
            return APISuccessOK(response).build_response()
        else:
            message = {"message": "No yacht matches yacht identifier provided", "yacht_identifier": yacht_identifier}
            response = json.dumps(message)
            logger.info("Yacht Retrieval for {} Was NOT Successful".format(yacht_identifier))
            return APINotFound(response).build_response()
    else:
        yachts = yacht_management_list_yachts()
        list_yachts = {
            "count": len(yachts),
            "yachts": yachts
        }
        response = json.dumps(list_yachts)
        logger.info("Yacht Listing Retrieval".format(yacht_identifier))
        return APISuccessOK(response).build_response()
