from models.meal_preferences import MealPreferences
from shared.assistant_tools import serialize_assistant_response
from shared.cosmos_db_utils import CosmosDbUtils


def v_get_meal_preferences_and_allergies(customer_email_address: str) -> str:
    result = get_meal_preferences_and_allergies(customer_email_address)
    return serialize_assistant_response(result)


def get_meal_preferences_and_allergies(customer_email_address: str) -> object:
    cosmos_util = CosmosDbUtils("mealpreferences")

    query = "SELECT * FROM m"

    retrieval_response = cosmos_util.query_container(query, enable_cross_partition_query=True)

    items: list[MealPreferences] = []
    for item in retrieval_response:
        items.append(item)

    return items
