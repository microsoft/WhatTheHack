import json
import os

from azure.search.documents.indexes.models import SimpleField, SearchFieldDataType, SearchableField, SearchField
from langchain_community.vectorstores.azuresearch import AzureSearch
from langchain_openai import AzureOpenAIEmbeddings

from models.yacht import Yacht


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


def get_contoso_information(query: str) -> str:
    response = contoso_document_retrieval_hybrid(query)

    return json.dumps(response)
