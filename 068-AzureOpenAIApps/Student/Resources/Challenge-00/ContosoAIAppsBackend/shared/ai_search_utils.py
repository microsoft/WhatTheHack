import os

from azure.core.credentials import AzureKeyCredential
from azure.search.documents import SearchClient
from azure.search.documents.indexes import SearchIndexClient


class AISearchUtils:

    def __init__(self, index_name: str):
        vector_store_address = os.environ.get('AZURE_AI_SEARCH_ENDPOINT')
        vector_store_admin_key = os.environ.get('AZURE_AI_SEARCH_ADMIN_KEY')

        self.index_name = index_name

        credential = AzureKeyCredential(vector_store_admin_key)
        azure_ai_search_client = SearchClient(vector_store_address, index_name=index_name, credential=credential)

        self.client = azure_ai_search_client

        self.index_client = SearchIndexClient(vector_store_address, credential=credential)

    def delete_documents(self, document_ids: list[str], key_field_name):

        documents_to_delete = []

        for document_id in document_ids:
            document: dict[str, str] = {key_field_name: document_id}
            documents_to_delete.append(document)

        response = self.client.delete_documents(documents_to_delete)

        return response

    def filter_query(self, search_text, filter_query: str):

        list_of_indices = self.index_client.list_index_names()

        l2 = []
        for i in list_of_indices:
            l2.append(i)

        if l2:
            search_result = self.client.search(search_text=search_text,filter=filter_query)
            return search_result

        return []