import logging

import azure.functions as func
from azure.functions import AuthLevel
import json
import os

from azure.search.documents.indexes.models import SearchFieldDataType, SimpleField, SearchableField, SearchField
from langchain_community.vectorstores.azuresearch import AzureSearch
from langchain_openai import AzureOpenAIEmbeddings

from models.customers import Customers
from shared.function_utils import APISuccessOK

contoso_tourists_controller = func.Blueprint()


@contoso_tourists_controller.function_name("contoso_tourists_basic")
@contoso_tourists_controller.route(route="contoso-tourists-basic", methods=["POST"],
                            auth_level=AuthLevel.FUNCTION)
def contoso_tourists(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    headers = req.headers

    query_mode = headers.get("x-query-mode", "vector-search")

    body = req.get_json()

    contoso_documents_index_name = os.environ.get('AZURE_AI_SEARCH_CONTOSO_DOCUMENTS_INDEX_NAME')
    azure_openai_endpoint = os.environ.get('AZURE_OPENAI_ENDPOINT', '')
    azure_openai_api_key = os.environ.get('AZURE_OPENAI_API_KEY')
    azure_openai_api_version = os.environ.get('AZURE_OPENAI_API_VERSION')
    azure_openai_embedding_deployment = os.environ.get('AZURE_OPENAI_EMBEDDING_DEPLOYMENT_NAME')

    vector_store_address = os.environ.get('AZURE_AI_SEARCH_ENDPOINT')
    vector_store_admin_key = os.environ.get('AZURE_AI_SEARCH_ADMIN_KEY')

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

    vector_store = AzureSearch(
        azure_search_endpoint=vector_store_address,
        azure_search_key=vector_store_admin_key,
        index_name=contoso_documents_index_name,
        embedding_function=embedding_function,
        fields=fields
    )

    user_question = body['message']

    # Perform a similarity search
    docs = vector_store.similarity_search(
        query=user_question,
        k=3,
        search_type="similarity",
    )

    display_docs = []

    for doc in docs:
        display_docs.append(doc.page_content)

    assistant_response = docs[0].page_content

    chat_response = {"reply": assistant_response, "query": user_question, "matches": display_docs}

    json_string = json.dumps(chat_response)

    return APISuccessOK(json_string).build_response()
