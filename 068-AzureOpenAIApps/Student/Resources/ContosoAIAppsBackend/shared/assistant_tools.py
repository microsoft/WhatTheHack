import json
import os
import time
from datetime import timedelta, date
import re

from azure.search.documents.indexes.models import SimpleField, SearchFieldDataType, SearchableField, SearchField
from langchain_community.vectorstores.azuresearch import AzureSearch
from langchain_openai import AzureOpenAIEmbeddings

from models.application_models import Customer, YachtDetails, YachtReservation, YachtReservationFull
from models.yacht import Yacht
from shared.cosmos_db_utils import CosmosDbUtils
from shared.redis_utils import RedisUtil


def serialize_assistant_response(assistant_response: any) -> str:
    """This function is used to serialize the assistant response from any data type into a JSON string
    :param assistant_response: any the data to be serialized
    :returns: a JSON string representation of the assistant response"""
    string_response = json.dumps(assistant_response)
    return string_response


def get_ai_search_vector_store(ai_search_index_name: str, fields: list[SearchField]):
    embedding_function = get_embedding_function()

    vector_store_address = os.environ.get('AZURE_AI_SEARCH_ENDPOINT')
    vector_store_admin_key = os.environ.get('AZURE_AI_SEARCH_ADMIN_KEY')

    vector_store = AzureSearch(
        azure_search_endpoint=vector_store_address,
        azure_search_key=vector_store_admin_key,
        index_name=ai_search_index_name,
        embedding_function=embedding_function,
        fields=fields
    )

    return vector_store


def get_embedding_function():
    azure_openai_endpoint = os.environ.get('AZURE_OPENAI_ENDPOINT')
    azure_openai_api_key = os.environ.get('AZURE_OPENAI_API_KEY')
    azure_openai_api_version = os.environ.get('AZURE_OPENAI_API_VERSION')
    azure_openai_embedding_deployment = os.environ.get('AZURE_OPENAI_EMBEDDING_DEPLOYMENT_NAME')

    langchain_embeddings_object = AzureOpenAIEmbeddings(
        azure_deployment=azure_openai_embedding_deployment,
        openai_api_version=azure_openai_api_version,
        azure_endpoint=azure_openai_endpoint,
        api_key=azure_openai_api_key,
    )

    embedding_function = langchain_embeddings_object.embed_query

    return embedding_function


def get_contoso_yachts_vector_store() -> AzureSearch:
    contoso_yachts_index_name = os.environ.get('AZURE_AI_SEARCH_CONTOSO_YACHTS_INDEX_NAME')
    embedding_function = get_embedding_function()

    contoso_yachts_fields = [
        SimpleField(
            name="id",
            type=SearchFieldDataType.String,
            key=True,
            filterable=True,
        ),
        SimpleField(
            name="yachtId",
            type=SearchFieldDataType.String,
            filterable=True,
        ),
        SearchableField(
            name="content",
            type=SearchFieldDataType.String,
            searchable=True,
        ),
        SearchableField(
            name="description",
            type=SearchFieldDataType.String,
            searchable=True,
        ),
        SearchField(
            name="content_vector",
            type=SearchFieldDataType.Collection(SearchFieldDataType.Single),
            searchable=True,
            vector_search_dimensions=len(embedding_function("Text")),
            vector_search_profile_name="myHnswProfile",
        ),
        SearchableField(
            name="metadata",
            type=SearchFieldDataType.String,
            searchable=True,
        ),
        SearchableField(
            name="name",
            type=SearchFieldDataType.String,
            searchable=True,
        ),
        # Additional field to store the price of the Yacht
        SimpleField(
            name="price",
            type=SearchFieldDataType.Double,
            filterable=True,
        ),
        # Additional field for filtering on maxCapacity
        SimpleField(
            name="maxCapacity",
            type=SearchFieldDataType.Int32,
            filterable=True,
        ),
    ]

    return get_ai_search_vector_store(contoso_yachts_index_name, contoso_yachts_fields)


def get_contoso_document_vector_store() -> AzureSearch:
    contoso_documents_index_name = os.environ.get('AZURE_AI_SEARCH_CONTOSO_DOCUMENTS_INDEX_NAME')
    embedding_function = get_embedding_function()

    contoso_document_fields = [
        SimpleField(
            name="id",
            type=SearchFieldDataType.String,
            key=True,
            filterable=True,
        ),
        SearchableField(
            name="content",
            type=SearchFieldDataType.String,
            searchable=True,
        ),
        SearchField(
            name="content_vector",
            type=SearchFieldDataType.Collection(SearchFieldDataType.Single),
            searchable=True,
            vector_search_dimensions=len(embedding_function("Text")),
            vector_search_profile_name="myHnswProfile",
        ),
        SearchableField(
            name="metadata",
            type=SearchFieldDataType.String,
            searchable=True,
        ),
        # Additional field to store the title
        SearchableField(
            name="title",
            type=SearchFieldDataType.String,
            searchable=True,
        ),
        # Additional field for filtering on document source
        SimpleField(
            name="source",
            type=SearchFieldDataType.String,
            filterable=True,
        ),

        # Additional field for filtering on document source
        SimpleField(
            name="filename",
            type=SearchFieldDataType.String,
            filterable=True,
        ),
    ]

    return get_ai_search_vector_store(contoso_documents_index_name, contoso_document_fields)


def contoso_document_retrieval_similarity(query: str) -> list[str]:
    vector_store: AzureSearch = get_contoso_document_vector_store()

    docs = vector_store.similarity_search(
        query=query,
        k=3,
        search_type="similarity",
    )

    display_docs = []

    for doc in docs:
        display_docs.append(doc.page_content)

    return display_docs


def contoso_document_retrieval_hybrid(query: str) -> list[str]:
    vector_store: AzureSearch = get_contoso_document_vector_store()

    docs = vector_store.hybrid_search(
        query=query,
        k=3
    )

    display_docs = []

    for doc in docs:
        display_docs.append(doc.page_content)

    return display_docs


def contoso_document_retrieval_semantic(query: str) -> list[str]:
    vector_store: AzureSearch = get_contoso_document_vector_store()

    docs = vector_store.semantic_hybrid_search(
        query=query,
        k=3
    )

    display_docs = []

    for doc in docs:
        display_docs.append(doc.page_content)

    return display_docs


def contoso_yachts_retrieval_hybrid(query: str, search_filters: str = None) -> list[Yacht]:
    vector_store: AzureSearch = get_contoso_yachts_vector_store()

    docs = vector_store.hybrid_search(
        query=query,
        k=3,
        filters=search_filters
    )

    display_yachts = []

    for doc in docs:
        metadata = doc.metadata
        description = doc.page_content
        yacht_id = metadata['id']
        yacht_name = metadata['name']
        yacht_price = float(metadata['price'])
        yacht_max_capacity = int(metadata['maxCapacity'])

        current_yacht: Yacht = {
            "yachtId": yacht_id,
            "name": yacht_name,
            "description": description,
            "price": yacht_price,
            "maxCapacity": yacht_max_capacity
        }

        display_yachts.append(current_yacht)

    return display_yachts


def set_default_int_if_empty(value: int, default: int) -> int:
    if value:
        return value
    return default


def set_default_float_if_empty(value: float, default: float) -> float:
    if value:
        return value
    return default


def contoso_yachts_filtered_search(query: str,
                                   minimum_price: float, maximum_price: float,
                                   minimum_capacity: int, maximum_capacity: int) -> list[Yacht]:
    search_query = query

    min_price = set_default_float_if_empty(minimum_price, 0.0)
    max_price = set_default_float_if_empty(maximum_price, 1000000)
    min_capacity = set_default_int_if_empty(minimum_capacity, 0)
    max_capacity = set_default_int_if_empty(maximum_capacity, 10000)

    filter_query = f"price ge {min_price} and price le {max_price} and maxCapacity ge {min_capacity} and maxCapacity le {max_capacity}"

    results = contoso_yachts_retrieval_hybrid(search_query, filter_query)

    return results


def get_contoso_information(query: str) -> list[str]:
    response = contoso_document_retrieval_hybrid(query)
    return response


def check_if_customer_account_exists(customer_email: str) -> bool:
    """Returns True if customer account exists and False otherwise"""

    response = get_customer_account_details(customer_email)

    return response is not None


def get_customer_account_details(customer_email: str) -> Customer | None:
    """Returns True if customer account exists and False otherwise"""

    query = f"SELECT * FROM c WHERE c.email = '{customer_email}'"

    cosmos_util = CosmosDbUtils("customers")

    responses = cosmos_util.query_container(query, enable_cross_partition_query=True)

    for response in responses:
        email = response['email']
        first_name = response['firstName']
        last_name = response['lastName']
        customer: Customer = {"email": email, "firstName": first_name, "lastName": last_name}
        return customer

    return None


def create_customer_account(customer_email: str, first_name: str, last_name: str) -> Customer:
    cosmos_util = CosmosDbUtils("customers")

    customer_profile: Customer = {"email": customer_email, "firstName": first_name, "lastName": last_name}

    customer_profile["id"] = customer_email

    customer_record: Customer = cosmos_util.create_item(customer_profile)

    return customer_record


def get_customer_account_balance(customer_email: str) -> float:
    lookup_key = "bank_account_balance_{}".format(customer_email)
    redis_util = RedisUtil()
    account_balance = redis_util.increment_float(lookup_key, 0.0)
    return account_balance


def make_bank_account_deposit(customer_email: str, deposit_amount: float) -> float:
    lookup_key = "bank_account_balance_{}".format(customer_email)
    redis_util = RedisUtil()
    account_balance = redis_util.increment_float(lookup_key, deposit_amount)
    return account_balance


def make_bank_account_withdrawal(customer_email: str, withdrawal_amount: float) -> float:
    lookup_key = "bank_account_balance_{}".format(customer_email)
    redis_util = RedisUtil()
    account_balance = redis_util.decrement_float(lookup_key, withdrawal_amount)
    return account_balance


def get_yacht_details(yacht_id: str) -> YachtDetails | None:
    """Returns the YachtDetails object"""

    query = f"SELECT * FROM c WHERE c.yachtId = '{yacht_id}'"

    cosmos_util = CosmosDbUtils("yachts")

    retrieval_response = cosmos_util.query_container(query, enable_cross_partition_query=True)

    for item in retrieval_response:
        yacht_id = item['yachtId']
        name = item['name']
        max_capacity = int(item['maxCapacity'])
        price = float(item['price'])
        description = item['description']
        yacht_details: YachtDetails = {"yachtId": yacht_id, "name": name,
                                       "maxCapacity": max_capacity, "price": price,
                                       "description": description}
        return yacht_details

    else:
        return None


def calculate_reservation_grand_total_amount(yacht_id: str, number_of_passengers: int) -> float:
    """Calculates the reservation grand total"""
    yacht_details: YachtDetails = get_yacht_details(yacht_id)
    yacht_unit_price = float(yacht_details['price'])
    return number_of_passengers * yacht_unit_price


def yacht_travel_party_size_within_capacity(yacht_id: str, travel_party_size: int) -> bool:
    """Returns True if yacht capacity is less than or equal to the travel party size"""
    yacht_details: YachtDetails = get_yacht_details(yacht_id)
    yacht_capacity = int(yacht_details['maxCapacity'])
    return travel_party_size <= yacht_capacity


def bank_account_balance_is_sufficient(bank_account_balance: float, reservation_total: float) -> bool:
    """Returns True if the bank account balance is sufficient to cover the transaction"""
    return bank_account_balance >= reservation_total


def yacht_is_available_for_date(yacht_id: str, date: str) -> bool:
    query = f"SELECT r.yachtId FROM r WHERE r.yachtId = '{yacht_id}' AND r.reservationDate = '{date}'"

    cosmos_util = CosmosDbUtils("reservations")

    retrieval_response = cosmos_util.query_container(query, enable_cross_partition_query=True)

    items = []
    for item in retrieval_response:
        items.append(item)

    return len(items) == 0


def get_valid_reservation_search_dates() -> list[str]:
    """"Returns the list of valid date ranges allowable to make reservation"""

    number_of_days = int(os.environ.get("YACHT_RESERVATION_MAX_NUMBER_OF_DAYS", "3"))
    valid_date_ranges: list[str] = []
    today_date: date = date.today()

    for days_to_add in range(0, number_of_days + 1):
        current_date = today_date + timedelta(days=days_to_add)
        # the date in YYYY-MM-DD format
        iso_date = current_date.isoformat()
        valid_date_ranges.append(iso_date)

    return valid_date_ranges


def is_valid_search_date(search_date: str) -> bool:
    valid_date_ranges = get_valid_reservation_search_dates()
    return search_date in valid_date_ranges


def yacht_booked_reservation_dates(yacht_id: str) -> list[str]:
    """This is a private function that is used internally to retrieve dates that a specific yacht has been booked"""
    query = f"SELECT r.reservationDate FROM r WHERE r.yachtId = '{yacht_id}'"
    cosmos_util = CosmosDbUtils("reservations")
    retrieval_response = cosmos_util.query_container(query, enable_cross_partition_query=True)
    items = []
    for item in retrieval_response:
        items.append(item['reservationDate'])

    return items


def yacht_ids_booked_on_reservation_dates(reservation_date: str) -> list[str]:
    """This is a private function that is used internally to retrieve yachts booked for a specific date"""
    query = f"SELECT r.yachtId FROM r WHERE r.reservationDate = '{reservation_date}'"
    cosmos_util = CosmosDbUtils("reservations")
    retrieval_response = cosmos_util.query_container(query, enable_cross_partition_query=True)
    items = []
    for item in retrieval_response:
        items.append(item['yachtId'])

    return items


def get_yacht_availability_by_id(yacht_id: str) -> list[str]:
    """Returns an array of ISO 8601 dates available for a specific yachtId"""
    possible_dates_for_reservation = get_valid_reservation_search_dates()
    booked_reservation_dates = yacht_booked_reservation_dates(yacht_id)

    set_possible_dates = set(possible_dates_for_reservation)
    set_booked_dates = set(booked_reservation_dates)

    open_dates = set_possible_dates - set_booked_dates

    return sorted(list(open_dates))


def get_yacht_availability_by_date(search_date: str) -> list[str]:
    """Returns a list of yacht ids open and available for a specific date"""
    all_yacht_ids = ["100", "200", "300", "400", "500"]
    booked_yacht_ids = yacht_ids_booked_on_reservation_dates(search_date)

    set_possible = set(all_yacht_ids)
    set_booked = set(booked_yacht_ids)

    open_yachts = set_possible - set_booked

    return sorted(list(open_yachts))


def create_yacht_reservation(yacht_id: str, reservation_date: str,
                             customer_email: str, passenger_count: int) -> YachtReservation:
    current_unix_time = int(time.time())
    reservation_id = str(current_unix_time)

    yacht_reservation: YachtReservationFull = {
        "id": reservation_id,
        "reservationId": reservation_id, "yachtId": yacht_id,
        "reservationDate": reservation_date, "emailAddress": customer_email,
        "numberOfPassengers": passenger_count}

    cosmos_util = CosmosDbUtils("reservations")
    insert_response: YachtReservation = cosmos_util.create_item(yacht_reservation)

    return insert_response


def yacht_reservation_exists(reservation_id: str) -> bool:
    retrieval_response: YachtReservation = get_reservation_details(reservation_id)
    return retrieval_response is not None


def get_reservation_details(reservation_id: str) -> YachtReservation | None:
    query = f"SELECT * FROM r WHERE r.reservationId = '{reservation_id}'"

    cosmos_util = CosmosDbUtils("reservations")

    retrieval_response = cosmos_util.query_container(query, enable_cross_partition_query=True)

    for item in retrieval_response:
        reservation_id = item["reservationId"]
        yacht_id = item["yachtId"]
        reservation_date = item["reservationDate"]
        customer_email = item["emailAddress"]
        passenger_count = item["numberOfPassengers"]

        yacht_reservation: YachtReservation = {
            "reservationId": reservation_id, "yachtId": yacht_id,
            "reservationDate": reservation_date, "emailAddress": customer_email,
            "numberOfPassengers": passenger_count}

        return yacht_reservation

    return None


def cancel_yacht_reservation(reservation_id: str):
    exists = yacht_reservation_exists(reservation_id)
    if exists:
        cosmos_util = CosmosDbUtils("reservations")
        cosmos_util.delete_item(reservation_id, reservation_id)
        return True
    return False


def get_customer_yacht_reservations(customer_email: str) -> list[YachtReservation]:
    query = f"SELECT * FROM r WHERE r.emailAddress = '{customer_email}'"

    cosmos_util = CosmosDbUtils("reservations")

    retrieval_response = cosmos_util.query_container(query, enable_cross_partition_query=True)

    items: list[YachtReservation] = []
    for item in retrieval_response:
        reservation_id = item["id"]
        yacht_id = item["yachtId"]
        email_address = item["emailAddress"]
        reservation_date = item["reservationDate"]
        number_of_passengers = item["numberOfPassengers"]

        reservation: YachtReservation = {"reservationId": reservation_id,
                                         "yachtId": yacht_id, "emailAddress": email_address,
                                         "reservationDate": reservation_date,
                                         "numberOfPassengers": number_of_passengers}
        items.append(reservation)

    return items


def is_properly_formatted_email_address(email_address: str) -> bool:
    regex_pattern_object = re.compile(r'([A-Za-z0-9]+[.-_])*[A-Za-z0-9]+@[A-Za-z0-9-]+(\.[A-Z|a-z]{2,})+')
    result = re.fullmatch(regex_pattern_object, email_address)
    if result:
        return True
    else:
        return False


def get_current_unix_timestamp() -> int:
    current_unix_time = int(time.time())
    return current_unix_time
