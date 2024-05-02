import logging
import azure.functions as func
from azure.functions import AuthLevel
import json
import os

from azure.search.documents.indexes.models import SimpleField, SearchFieldDataType, SearchableField, SearchField
from langchain_community.vectorstores.azuresearch import AzureSearch
from langchain_core.documents import Document
from langchain_openai import AzureOpenAIEmbeddings
from langchain_text_splitters import RecursiveCharacterTextSplitter

from shared.ai_search_utils import AISearchUtils

azure_blob_controller = func.Blueprint()


@azure_blob_controller.function_name("azure_blob_controller")
@azure_blob_controller.blob_trigger(arg_name='contosostream', connection='DOCUMENT_STORAGE',
                                    path='government/{blobName}')
def azure_blob_handler(contosostream: func.InputStream):
    logging.info('Python Azure Blob trigger function processed a request.')

    file_content_encoding = 'utf-8'
    logging.info(contosostream.name)
    logging.info(contosostream.length)

    blob_content = contosostream.read().decode(file_content_encoding)
    logging.info(blob_content)

    contoso_documents_index_name = os.environ.get('AZURE_AI_SEARCH_CONTOSO_DOCUMENTS_INDEX_NAME')
    azure_openai_endpoint = os.environ.get('AZURE_OPENAI_ENDPOINT', '')
    azure_openai_api_key = os.environ.get('AZURE_OPENAI_API_KEY')
    azure_openai_api_version = os.environ.get('AZURE_OPENAI_API_VERSION')
    azure_openai_embedding_deployment = os.environ.get('AZURE_OPENAI_EMBEDDING_DEPLOYMENT_NAME')

    vector_store_address = os.environ.get('AZURE_AI_SEARCH_ENDPOINT')
    vector_store_admin_key = os.environ.get('AZURE_AI_SEARCH_ADMIN_KEY')

    ai_search_util = AISearchUtils(contoso_documents_index_name)

    source_identifier = contosostream.name

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

    search_results = ai_search_util.filter_query("*", f"source eq '{source_identifier}'")

    matching_document_ids: list[str] = []

    for document in search_results:
        matching_document_ids.append(document['id'])

    if matching_document_ids and len(matching_document_ids) == 0:
        ai_search_util.delete_documents(matching_document_ids, key_field_name="id")

    doc_meta = {"title": "Documents from {}".format(source_identifier),
                "source": source_identifier, "filename": source_identifier, }

    document = Document(page_content=blob_content, metadata=doc_meta)

    splitter = RecursiveCharacterTextSplitter(separators=["\n\n"], chunk_size=512, chunk_overlap=0)

    # Chunks of docs after splitting the blob chunks into reasonable chunks of smaller size
    document_chunks = splitter.split_documents([document])

    vector_store.add_documents(document_chunks)

    print("Added {} documents".format(len(document_chunks)))
