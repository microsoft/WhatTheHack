import json
import os

from azure.servicebus import ServiceBusClient, ServiceBusSender, ServiceBusMessage


class ServiceBusUtils:

    def __init__(self):
        service_bus_connection_string = os.environ.get("CITRUS_BUS")
        self.service_bus_client: ServiceBusClient = ServiceBusClient.from_connection_string(
            service_bus_connection_string)

    def get_queue_sender(self, queue_name: str):
        service_bus_queue_sender: ServiceBusSender = self.service_bus_client.get_queue_sender(queue_name)
        return service_bus_queue_sender

    def send_string_to_queue(self, queue_name: str, message: str):
        message = ServiceBusMessage(message)
        queue_sender = self.get_queue_sender(queue_name)
        queue_sender.send_messages(message)

    def send_object_to_queue(self, queue_name: str, message: dict):
        service_bus_message = json.dumps(message)
        return self.send_string_to_queue(queue_name, service_bus_message)


