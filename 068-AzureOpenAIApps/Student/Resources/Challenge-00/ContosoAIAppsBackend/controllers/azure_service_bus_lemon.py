import json
import logging

import azure.functions as func

service_bus_controller_lemon = func.Blueprint()


@service_bus_controller_lemon.function_name("service_bus_controller")
@service_bus_controller_lemon.service_bus_queue_trigger(arg_name='record', connection="CITRUS_BUS",
                                                        queue_name='lemon')
def service_bus_handler(record: func.ServiceBusMessage):
    logging.info('Python Azure Blob trigger function processed a request.')

    service_bus_stream = record.get_body()
    service_bus_object = json.loads(service_bus_stream)

    logging.info('Processed object{}'.format(service_bus_object))
