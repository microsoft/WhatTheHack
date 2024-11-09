import logging
import azure.functions as func

from shared.application_initialization_logic import initialize_contoso_documents_index, initialize_yachts_index, \
    initialize_cosmos_collections

app_initializer_controller = func.Blueprint()


@app_initializer_controller.function_name("application_initializer")
@app_initializer_controller.timer_trigger(schedule="0 */55 * * * *",
                                          arg_name="mytimer",
                                          run_on_startup=True)
def app_initializer_handler(mytimer: func.TimerRequest) -> None:
    logging.info('Python HTTP trigger function processed a request.')
    logging.info('Initializing Application Initializer')

    # initialize contoso documents index for langchain integration
    initialize_contoso_documents_index()

    # initialize contoso yachts index for langchain integration
    initialize_yachts_index()

    # initialize cosmos db collections
    initialize_cosmos_collections()