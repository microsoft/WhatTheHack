import logging

import azure.functions as func
from azure.functions import AuthLevel
import json

from models.application_models import Customer
from shared.function_utils import APISuccessOK

customers_controller = func.Blueprint()


@customers_controller.function_name("customers_controller")
@customers_controller.route(route="customers/{customerId?}", methods=["GET", "PUT", "POST", "DELETE"],
                            auth_level=AuthLevel.FUNCTION)
def customers_handler(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    books = {'id': 1, 'name': '<NAME>'}
    result = {'name': 'israel ekpo', 'books': books}

    response = json.dumps(result)

    return APISuccessOK(result).build_response()
