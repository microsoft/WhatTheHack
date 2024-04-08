import logging

import azure.functions as func

service_bus_controller = func.Blueprint()


@service_bus_controller.function_name("service_bus_controller")
@service_bus_controller.service_bus_queue_trigger(arg_name='serviceBusRecord', connection="SERVICE_BUS",
                                                  queue_name='lemon')
def service_bus_handler(serviceBusRecord: func.ServiceBusMessage):
    logging.info('Python Azure Blob trigger function processed a request.')

    response = logging.info(serviceBusRecord.to)
    response = logging.info(serviceBusRecord.get_body())
