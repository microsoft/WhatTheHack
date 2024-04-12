import logging
import azure.functions as func
from azure.functions import AuthLevel
import json

azure_blob_controller = func.Blueprint()


@azure_blob_controller.function_name("azure_blob_controller")
@azure_blob_controller.blob_trigger(arg_name='izzystream', connection='SOURCE_DATA_STORAGE',
                                    path='government/{blobName}')
def azure_blob_handler(izzystream: func.InputStream):
    logging.info('Python Azure Blob trigger function processed a request.')

    file_content_encoding = 'utf-8'
    logging.info(izzystream.name)
    logging.info(izzystream.length)

    blob_content = izzystream.read().decode(file_content_encoding)
    logging.info(blob_content)
