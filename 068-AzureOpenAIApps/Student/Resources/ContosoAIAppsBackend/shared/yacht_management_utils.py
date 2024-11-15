import re

from models.yacht import YachtSearchResponse, Yacht
from shared.cosmos_db_utils import CosmosDbUtils


def remove_non_alphanumeric(input_str):
    # Use re.sub() to remove all non-alphanumeric characters
    return re.sub(r'[\W_]', '', input_str)


def yacht_management_list_yachts():
    cosmos_util = CosmosDbUtils("yachts")

    query = f"SELECT * FROM y"

    retrieval_response = cosmos_util.query_container(query, enable_cross_partition_query=True)
    items = []
    for item in retrieval_response:
        yacht_id = item["yachtId"]
        yacht_name = item["name"]
        yacht_price = item["price"]
        yacht_description = item["description"]
        yacht_max_capacity = item["maxCapacity"]

        current_yacht: Yacht = {
            "yachtId": yacht_id,
            "name": yacht_name,
            "description": yacht_description,
            "price": yacht_price,
            "maxCapacity": yacht_max_capacity
        }

        items.append(current_yacht)

    return items


def yacht_management_get_yacht_details(yacht_id: str):
    cosmos_util = CosmosDbUtils("yachts")

    yacht_id = remove_non_alphanumeric(yacht_id)

    query = f"SELECT * FROM y WHERE y.yachtId = '{yacht_id}'"

    retrieval_response = cosmos_util.query_container(query, enable_cross_partition_query=True)

    for item in retrieval_response:
        record_id = item["id"]
        yacht_name = item["name"]
        yacht_price = item["price"]
        yacht_description = item["description"]
        yacht_max_capacity = item["maxCapacity"]

        current_yacht: YachtSearchResponse = {
            "id": record_id,
            "yachtId": yacht_id,
            "name": yacht_name,
            "description": yacht_description,
            "price": yacht_price,
            "maxCapacity": yacht_max_capacity
        }

        return current_yacht

    print("No yacht found for yacht {}".format(yacht_id))
    print("SQL statement executed was {}".format(query))

    return None
