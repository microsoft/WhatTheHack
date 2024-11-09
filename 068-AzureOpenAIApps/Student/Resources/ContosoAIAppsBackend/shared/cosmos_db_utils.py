import os
from typing import Any, Iterable, Dict
from azure.cosmos import CosmosClient, DatabaseProxy, ContainerProxy, PartitionKey


class CosmosDbUtils:
    def __init__(self, collection: str):
        cosmos_connection_string = os.environ["COSMOS_CONNECTION"]
        cosmos_database_name_string = os.environ["COSMOS_DATABASE_NAME"]

        self.client: CosmosClient = CosmosClient.from_connection_string(conn_str=cosmos_connection_string)
        self.database_name: str = cosmos_database_name_string
        self.collection_name: str = collection

    def create_collection(self, partition_key_path: str):
        partition_key_path = PartitionKey(path=partition_key_path)
        container_identifier = self.collection_name
        self.get_database().create_container_if_not_exists(id=container_identifier, partition_key=partition_key_path)

    def get_database(self) -> DatabaseProxy:
        return self.client.get_database_client(self.database_name)

    def get_collection(self) -> ContainerProxy:
        return self.get_database().get_container_client(self.collection_name)

    def update_database_name(self, database_name: str):
        self.database_name = database_name
        return self

    def update_collection_name(self, collection_name: str):
        self.collection_name = collection_name
        return self

    def create_item(self, item: dict):
        """Returns a dictionary representing the item created"""
        container_proxy = self.get_collection()
        return container_proxy.create_item(item)

    def upsert_item(self, item: dict):
        """Returns a dictionary representing the item upserted"""
        container_proxy = self.get_collection()
        return container_proxy.upsert_item(item)

    def delete_item(self, item: dict[str, Any] | str, partition_key):
        container_proxy = self.get_collection()
        return container_proxy.delete_item(item, partition_key=partition_key)

    def query_container(self, query: str,
                        parameters: list[dict[str, object]] | None = None,
                        partition_key: Any | None = None,
                        enable_cross_partition_query: bool | None = None,
                        max_item_count: int | None = None):
        container_proxy = self.get_collection()

        results: Iterable[Dict[str, Any]] = container_proxy.query_items(query, parameters=parameters, partition_key=partition_key,
                                              enable_cross_partition_query=enable_cross_partition_query,
                                              max_item_count=max_item_count)

        return results
