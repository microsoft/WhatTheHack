import os

from langchain_community.vectorstores.azuresearch import AzureSearch
from langchain_core.documents import Document
from langchain_openai import AzureOpenAIEmbeddings
from langchain_text_splitters import RecursiveCharacterTextSplitter

from shared.ai_search_utils import AISearchUtils

from azure.search.documents.indexes.models import (
    SearchableField,
    SearchField,
    SearchFieldDataType,
    SimpleField,
)

from shared.cosmos_db_utils import CosmosDbUtils


def initialize_yachts_index():

    azure_endpoint = os.environ.get('AZURE_OPENAI_ENDPOINT')
    azure_openai_api_key = os.environ.get('AZURE_OPENAI_API_KEY')
    azure_openai_api_version = os.environ.get('AZURE_OPENAI_API_VERSION')
    azure_openai_embedding_deployment = os.environ.get('AZURE_OPENAI_EMBEDDING_DEPLOYMENT_NAME')

    vector_store_address = os.environ.get('AZURE_AI_SEARCH_ENDPOINT')
    vector_store_admin_key = os.environ.get('AZURE_AI_SEARCH_ADMIN_KEY')

    contoso_yachts_index_name = os.environ.get('AZURE_AI_SEARCH_CONTOSO_YACHTS_INDEX_NAME')

    embeddings = AzureOpenAIEmbeddings(
        azure_deployment=azure_openai_embedding_deployment,
        openai_api_version=azure_openai_api_version,
        azure_endpoint=azure_endpoint,
        api_key=azure_openai_api_key,
    )

    embedding_function = embeddings.embed_query

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

    ai_search_util = AISearchUtils(contoso_yachts_index_name)

    index_exists = ai_search_util.index_exists(contoso_yachts_index_name)

    print("{} AI Search Index exists {}".format(contoso_yachts_index_name, index_exists))

def initialize_contoso_documents_index():
    azure_endpoint = os.environ.get('AZURE_OPENAI_ENDPOINT')
    azure_openai_api_key = os.environ.get('AZURE_OPENAI_API_KEY')
    azure_openai_api_version = os.environ.get('AZURE_OPENAI_API_VERSION')
    azure_openai_embedding_deployment = os.environ.get('AZURE_OPENAI_EMBEDDING_DEPLOYMENT_NAME')

    vector_store_address = os.environ.get('AZURE_AI_SEARCH_ENDPOINT')
    vector_store_admin_key = os.environ.get('AZURE_AI_SEARCH_ADMIN_KEY')

    contoso_documents_index_name = os.environ.get('AZURE_AI_SEARCH_CONTOSO_DOCUMENTS_INDEX_NAME')

    embeddings = AzureOpenAIEmbeddings(
        azure_deployment=azure_openai_embedding_deployment,
        openai_api_version=azure_openai_api_version,
        azure_endpoint=azure_endpoint,
        api_key=azure_openai_api_key,
    )

    embedding_function = embeddings.embed_query

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

    ai_search_util = AISearchUtils(contoso_documents_index_name)

    index_exists = ai_search_util.index_exists(contoso_documents_index_name)

    print("{} AI Search Index exists {}".format(contoso_documents_index_name, index_exists))


def initialize_cosmos_collections():

    cosmos_db_grades_util = CosmosDbUtils("grades")
    cosmos_db_grades_util.create_collection("/submissionId")

    cosmos_db_activities_util = CosmosDbUtils("activitypreferences")
    cosmos_db_activities_util.create_collection("/registrationId")

    cosmos_db_activities_util = CosmosDbUtils("students")
    cosmos_db_activities_util.create_collection("/studentId")
