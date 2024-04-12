import logging
import os

import azure.functions as func
from azure.cosmos import DataType
from azure.functions import AuthLevel, Document
import json
from azure.functions._cosmosdb import Document

cosmos_controller = func.Blueprint()

cosmos_database_name = os.environ.get('COSMOS_DATABASE_NAME')


@cosmos_controller.function_name("cosmos_controller")
@cosmos_controller.cosmos_db_trigger(arg_name='documents',
                                     connection="COSMOS_CONNECTION",
                                     database_name=cosmos_database_name,
                                     container_name="yachts", lease_container_name="leases",
                                     create_lease_container_if_not_exists=True)
def cosmos_db_handler(documents: func.DocumentList):
    logging.info('Python Cosmos DB trigger function processed a request.')

    if documents:
        logging.info(documents[0])
        logging.info(json.dumps(documents[0]['price']))
