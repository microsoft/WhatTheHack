import azure.functions as func

from controllers.application_initializer import app_initializer_controller
from controllers.ask_elizabeth import ask_elizabeth_controller
from controllers.ask_esther import ask_esther_controller
from controllers.azure_blob import azure_blob_controller
from controllers.azure_service_bus import service_bus_controller
from controllers.contoso_tourists_basic import contoso_tourists_controller
from controllers.cosmos_db import cosmos_controller
from controllers.customers import customers_controller
from controllers.yachts import yachts_controller

app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)

app.register_functions(ask_elizabeth_controller)
app.register_functions(ask_esther_controller)
app.register_functions(yachts_controller)
app.register_functions(customers_controller)
app.register_functions(azure_blob_controller)
app.register_functions(service_bus_controller)
app.register_functions(cosmos_controller)
app.register_functions(app_initializer_controller)
app.register_functions(contoso_tourists_controller)
