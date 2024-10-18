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
from shared.assistant_tools import get_current_unix_timestamp
from shared.cosmos_db_utils import CosmosDbUtils
from shared.document_intelligence_utils import DocumentProcessor
from shared.service_bus_utils import ServiceBusUtils


def is_valid_school_district(school_district: str):
    district_search = school_district.lower()
    school_districts = ["orange", "tangerine", "lemon", "grapefruit"]
    return district_search in school_districts


azure_document_intelligence_controller = func.Blueprint()


@azure_document_intelligence_controller.function_name("document_intelligence_controller")
@azure_document_intelligence_controller.blob_trigger(arg_name='documentstream', connection='DOCUMENT_STORAGE',
                                                     path='submissions/{blobName}')
def azure_document_intelligence_handler(documentstream: func.InputStream):
    logging.info('document_intelligence_controller function processed a request.')

    logging.info(documentstream.name)
    logging.info(documentstream.length)
    document_buffer = documentstream.read()

    print("A total of {} bytes detected".format(len(document_buffer)))

    document_processor_util = DocumentProcessor()
    service_bus_util = ServiceBusUtils()

    classifications = document_processor_util.process_buffer(document_buffer)

    print("These are the classification results: {}".format(classifications))

    for classification in classifications:
        pages = classification.pages
        document_type = classification.document_type

        result = document_processor_util.extract_contents(document_buffer, document_type, pages)

        is_exam_submission = document_processor_util.is_exam_submission(document_type)
        is_activity_preference = document_processor_util.is_activity_preference(document_type)

        submission_id = str(get_current_unix_timestamp())

        if is_exam_submission:
            destination_queue = result['school_district'].lower()
            exam_submission = result
            exam_submission['id'] = submission_id
            exam_submission['submissionId'] = submission_id

            cosmos_db_util = CosmosDbUtils("examsubmissions")
            print("Saving Exam Submission to Cosmos DB {}".format(exam_submission))
            cosmos_db_util.create_item(exam_submission)

            print("Saving Exam Submission to Destination Queue {}: {}".format(destination_queue, exam_submission))
            service_bus_util.send_object_to_queue(destination_queue, exam_submission)

        elif is_activity_preference:
            activity_preference = result

            guest_email_address = result['guest_email_address']
            activity_preference['id'] = guest_email_address
            activity_preference['registrationId'] = guest_email_address
            activity_preference['profileId'] = submission_id

            cosmos_db_util = CosmosDbUtils("activitypreferences")

            print("Saving Activity Preference to Cosmos DB {}".format(activity_preference))
            cosmos_db_util.upsert_item(activity_preference)
