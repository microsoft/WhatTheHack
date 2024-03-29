import logging

import azure.functions as func
from azure.functions import AuthLevel
import json

from shared.function_utils import APISuccessOK

yachts_controller = func.Blueprint()


@yachts_controller.function_name("yachts_controller")
@yachts_controller.route(route="yachts/{yachtId?}", methods=["GET", "PUT", "POST", "DELETE"],
                         auth_level=AuthLevel.FUNCTION)
def yachts_handler(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    response = json.dumps({'name': 'Israel'})

    return APISuccessOK(response).build_response()
