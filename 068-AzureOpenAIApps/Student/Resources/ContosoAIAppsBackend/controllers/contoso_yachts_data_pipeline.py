import logging
import os

import azure.functions as func
from azure.cosmos import DataType
from azure.functions import AuthLevel, Document
import json
from azure.functions._cosmosdb import Document
from azure.search.documents.indexes.models import SimpleField, SearchFieldDataType, SearchableField, SearchField
from langchain_core.documents.base import Document as LangchainDocument
from langchain_community.vectorstores.azuresearch import AzureSearch
from langchain_openai import AzureOpenAIEmbeddings

from models.yacht import Yacht, YachtEmbeddingHash
from shared.ai_search_utils import AISearchUtils
from shared.crypto_utils import CryptoUtils
from shared.logging_utils import LoggingUtils
from shared.redis_utils import RedisUtil

cosmos_controller = func.Blueprint()

cosmos_database_name = os.environ.get('COSMOS_DATABASE_NAME')


@cosmos_controller.function_name("cosmos_controller")
@cosmos_controller.cosmos_db_trigger(arg_name='documents',
                                     connection="COSMOS_CONNECTION",
                                     database_name=cosmos_database_name,
                                     container_name="yachts", lease_container_name="leases",
                                     create_lease_container_if_not_exists=True)
def cosmos_db_handler(documents: func.DocumentList):
    logging.info('Python Cosmos DB trigger function processed a request.')

    if documents:
        for document in documents:
            yacht_record = {
                'yachtId': document['yachtId'],
                'name': document['name'],
                'price': float(document['price']),
                'maxCapacity': int(document['maxCapacity']),
                'description': document['description'],
            }

            process_document_change(yacht_record)


def process_document_change(yacht_record: Yacht):
    contoso_yachts_index_name = os.environ.get('AZURE_AI_SEARCH_CONTOSO_YACHTS_INDEX_NAME')
    azure_openai_endpoint = os.environ.get('AZURE_OPENAI_ENDPOINT')
    azure_openai_api_key = os.environ.get('AZURE_OPENAI_API_KEY')
    azure_openai_api_version = os.environ.get('AZURE_OPENAI_API_VERSION')
    azure_openai_embedding_deployment = os.environ.get('AZURE_OPENAI_EMBEDDING_DEPLOYMENT_NAME')

    vector_store_address = os.environ.get('AZURE_AI_SEARCH_ENDPOINT')
    vector_store_admin_key = os.environ.get('AZURE_AI_SEARCH_ADMIN_KEY')

    ai_search_util = AISearchUtils(contoso_yachts_index_name)
    redis_util = RedisUtil()

    yacht_id = yacht_record['yachtId']
    yacht_name = yacht_record['name']
    yacht_price = yacht_record['price']
    yacht_max_capacity = yacht_record['maxCapacity']
    yacht_description = yacht_record['description']
    description_hash = CryptoUtils.sha1_hash_string(yacht_description)

    redis_lookup_key = "yacht_embeddings_cache_{}".format(yacht_id)
    cache_exists = redis_util.exists(redis_lookup_key)
    yacht_description_sha1_hash = redis_util.get(redis_lookup_key)

    langchain_embeddings_object = AzureOpenAIEmbeddings(
        azure_deployment=azure_openai_embedding_deployment,
        openai_api_version=azure_openai_api_version,
        azure_endpoint=azure_openai_endpoint,
        api_key=azure_openai_api_key,
    )

    embedding_function = langchain_embeddings_object.embed_query

    fields = [
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

    vector_store = AzureSearch(
        azure_search_endpoint=vector_store_address,
        azure_search_key=vector_store_admin_key,
        index_name=contoso_yachts_index_name,
        embedding_function=embedding_function,
        fields=fields
    )

    compute_embeddings_on_if_necessary = int(os.environ.get("COMPUTE_EMBEDDINGS_ONLY_IF_NECESSARY", "0"))
    check_hash: bool = compute_embeddings_on_if_necessary == 1

    # This check prevents computing the embedding everytime any field is modified including numbers
    # and fields besides the description field that needs vector search
    if check_hash and cache_exists and description_hash == yacht_description_sha1_hash:

        metadata = {
            "id": yacht_id,
            "yachtId": yacht_id,
            "name": yacht_name,
            "price": yacht_price,
            "description": yacht_description,
            "content": yacht_description,
            "maxCapacity": yacht_max_capacity
        }

        yacht_object = metadata
        yacht_object['metadata'] = json.dumps(metadata)

        print("Patching Yacht object with {}".format(yacht_object))
        custom_event = {"yacht_id": yacht_id, "hash": yacht_description_sha1_hash}
        event_name = "SKIP_YACHT_EMBEDDING_COMPUTE"
        LoggingUtils.track_event(event_name, custom_event)

        ai_search_util.patch_document(yacht_object)

    else:
        metadata_object = {
            "id": yacht_id,
            "yachtId": yacht_id,
            "name": yacht_name,
            "price": yacht_price,
            "description": yacht_description,
            "maxCapacity": yacht_max_capacity,
        }

        new_document = LangchainDocument(page_content=yacht_description, metadata=metadata_object)

        documents = [new_document]

        redis_util.set(redis_lookup_key, description_hash)

        print("Inserting Yacht object {}".format(metadata_object))
        custom_event = {"yacht_id": yacht_id, "hash": yacht_description_sha1_hash}
        event_name = "PROCESS_YACHT_EMBEDDING_COMPUTE"
        LoggingUtils.track_event(event_name, custom_event)

        vector_store.add_documents(documents)
