import json
import os

from azure.servicebus import ServiceBusClient, ServiceBusSender, ServiceBusMessage
from azure.servicebus.management import ServiceBusAdministrationClient, QueueProperties, EntityStatus


class ServiceBusUtils:

    def __init__(self):
        service_bus_connection_string = os.environ.get("SERVICE_BUS_CONNECTION_STRING")
        self.service_bus_client: ServiceBusClient = ServiceBusClient.from_connection_string(
            service_bus_connection_string)

        self.admin_client: ServiceBusAdministrationClient = ServiceBusAdministrationClient.from_connection_string(
            service_bus_connection_string)

    def create_queue(self, queue_name: str):
        return self.admin_client.create_queue(queue_name)

    def delete_queue(self, queue_name: str):
        return self.admin_client.delete_queue(queue_name)

    def list_queues(self):
        results = []
        queues = self.admin_client.list_queues()
        for queue in queues:
            results.append(queue)
        return results

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

    def update_queue_status(self, queue_name: str, new_status: EntityStatus):
        queue_properties: QueueProperties = self.admin_client.get_queue(queue_name)
        queue_properties.status = new_status
        self.admin_client.update_queue(queue_properties)

    def update_queue_receive_disabled(self, queue_name: str):
        """Changes the queue status to ReceiveDisabled:
        You can send messages to the queue, but you can't receive messages from it.
        You'll get an exception if you try to receive messages from the queue..
        """
        self.update_queue_status(queue_name, EntityStatus.RECEIVE_DISABLED)

    def update_queue_send_disabled(self, queue_name: str):
        """Changes the queue status to SendDisabled:
        You can't send messages to the queue, but you can receive messages from it.
        You'll get an exception if you try to send messages to the queue.
        """
        self.update_queue_status(queue_name, EntityStatus.SEND_DISABLED)

    def update_queue_active(self, queue_name: str):
        """Changes the queue status to Active:
        The queue is active. You can send messages to and receive messages from the queue.
        """
        self.update_queue_status(queue_name, EntityStatus.ACTIVE)

    def update_queue_disabled(self, queue_name: str):
        """Changes the queue status to Disabled:
        The queue is suspended. It's equivalent to setting both SendDisabled and ReceiveDisabled.
        """
        self.update_queue_status(queue_name, EntityStatus.DISABLED)
