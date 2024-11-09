import logging

import azure.functions as func
from azure.functions import AuthLevel
import json
from shared.function_utils import APISuccessOK
from shared.assistant_tools import get_contoso_document_vector_store

contoso_yacht_reservations_controller = func.Blueprint()


@contoso_yacht_reservations_controller.function_name("contoso_yachts_chat_completion")
@contoso_yacht_reservations_controller.route(route="contoso-yachts-chat", methods=["POST"],
                                             auth_level=AuthLevel.ANONYMOUS)
def contoso_tourists2(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('contoso_yacht_reservations_controller processed a request.')

    headers = req.headers

    query_mode = headers.get("x-query-mode", "vector-search")

    body = req.get_json()

    vector_store = get_contoso_document_vector_store()

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
