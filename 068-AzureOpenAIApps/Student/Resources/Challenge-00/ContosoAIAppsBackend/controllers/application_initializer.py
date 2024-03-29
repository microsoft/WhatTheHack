import logging
import azure.functions as func
from azure.functions import AuthLevel
import json

app_initializer_controller = func.Blueprint()


@app_initializer_controller.function_name("application_initializer")
@app_initializer_controller.timer_trigger(schedule="0 */5 * * * *",
                                          arg_name="mytimer",
                                          run_on_startup=True)
def app_initializer_handler(mytimer: func.TimerRequest) -> None:
    logging.info('Python HTTP trigger function processed a request.')
    logging.info('Initializing Application Initializer')
