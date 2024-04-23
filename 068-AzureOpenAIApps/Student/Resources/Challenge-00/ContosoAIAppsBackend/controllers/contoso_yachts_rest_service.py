import logging

import azure.functions as func
from azure.functions import AuthLevel
import json

from models.yacht import Yacht, YachtSearchResponse
from shared.cosmos_db_utils import CosmosDbUtils
from shared.function_utils import APISuccessOK, APINotFound, APIBadRequest

yachts_crud_controller = func.Blueprint()


@yachts_crud_controller.function_name("yachts_management_controller")
@yachts_crud_controller.route(route="yachts-management/{yachtId?}", methods=["GET", "PUT", "POST", "DELETE"],
                              auth_level=AuthLevel.FUNCTION)
def yachts_management_controller(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    request_method = req.method.upper()

    if request_method == "GET":
        return handle_get_request(req)
    elif request_method == "PUT":
        return handle_put_request(req)
    elif request_method == "DELETE":
        return handle_delete_request(req)


def handle_delete_request(request: func.HttpRequest):
    cosmos_util = CosmosDbUtils("yachts")
    yacht_id = request.route_params.get('yachtId', None)

    if yacht_id is not None:
        yacht_details = yacht_management_get_yacht_details(yacht_id)
        if yacht_details:
            record_identifier = yacht_details['id']
            cosmos_util.delete_item(record_identifier, yacht_id)
            response = json.dumps(yacht_details)
            return APISuccessOK(response).build_response()
        else:
            message = {"message": "No yacht matches yacht identifier provided", "yacht_identifier": yacht_id}
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
    return APISuccessOK(response).build_response()


def handle_get_request(request: func.HttpRequest):
    yacht_identifier = request.route_params.get('yachtId', None)

    if yacht_identifier is not None:
        yacht_details = yacht_management_get_yacht_details(yacht_identifier)
        if yacht_details:
            response = json.dumps(yacht_details)
            return APISuccessOK(response).build_response()
        else:
            message = {"message": "No yacht matches yacht identifier provided", "yacht_identifier": yacht_identifier}
            response = json.dumps(message)
            return APINotFound(response).build_response()
    else:
        yachts = yacht_management_list_yachts()
        response = json.dumps(yachts)
        return APISuccessOK(response).build_response()


def yacht_management_list_yachts():
    cosmos_util = CosmosDbUtils("yachts")

    query = f"SELECT * FROM y"

    retrieval_response = cosmos_util.query_container(query, enable_cross_partition_query=True)
    items = []
    for item in retrieval_response:
        yacht_id = item["yachtId"]
        yacht_name = item["name"]
        yacht_price = item["price"]
        yacht_description = item["description"]
        yacht_max_capacity = item["maxCapacity"]

        current_yacht: Yacht = {
            "yachtId": yacht_id,
            "name": yacht_name,
            "description": yacht_description,
            "price": yacht_price,
            "maxCapacity": yacht_max_capacity
        }

        items.append(current_yacht)

    return items


def yacht_management_get_yacht_details(yacht_id: str):
    cosmos_util = CosmosDbUtils("yachts")

    query = f"SELECT * FROM y WHERE y.yachtId = '{yacht_id}'"

    retrieval_response = cosmos_util.query_container(query, enable_cross_partition_query=True)

    for item in retrieval_response:
        record_id = item["id"]
        yacht_name = item["name"]
        yacht_price = item["price"]
        yacht_description = item["description"]
        yacht_max_capacity = item["maxCapacity"]

        current_yacht: YachtSearchResponse = {
            "id": record_id,
            "yachtId": yacht_id,
            "name": yacht_name,
            "description": yacht_description,
            "price": yacht_price,
            "maxCapacity": yacht_max_capacity
        }

        return current_yacht

    return None
