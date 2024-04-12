import azure.functions as func
import datetime
import json
import logging

from controllers.application_initializer import app_initializer_controller
from controllers.contoso_tourists_basic import contoso_tourists_controller
from controllers.customers import customers_controller
from controllers.yachts import yachts_controller
from controllers.azure_blob import azure_blob_controller
from controllers.azure_service_bus import service_bus_controller
from controllers.cosmos_db import cosmos_controller

app = func.FunctionApp(http_auth_level=func.AuthLevel.FUNCTION)

app.register_functions(yachts_controller)
app.register_functions(customers_controller)
app.register_functions(azure_blob_controller)
app.register_functions(service_bus_controller)
app.register_functions(cosmos_controller)
app.register_functions(app_initializer_controller)
app.register_functions(contoso_tourists_controller)
