import io
import json
import typing
from typing import BinaryIO, IO, Any

from azure.ai.documentintelligence import DocumentIntelligenceClient, _model_base
from azure.ai.documentintelligence.models import AnalyzeResult, ClassifyDocumentRequest, Document, DocumentField
from azure.core.credentials import AzureKeyCredential
from langchain_core.load import Serializable


class DocumentIntelligenceUtil:

    def __init__(self, endpoint, key, api_version):
        self.endpoint = endpoint
        self.key = key
        self.api_version = api_version

        credentials = AzureKeyCredential(key)
        self.client = DocumentIntelligenceClient(endpoint, credentials, api_version=api_version)

    def classify_buffer(self, classifier_model_id: str, buffer: bytes):

        buffer_bytes: IO[bytes] = io.BytesIO(buffer)

        results = self.client.begin_classify_document(classifier_model_id,
                                                      classify_request=buffer_bytes,
                                                      content_type="application/octet-stream")

        analyze_result: AnalyzeResult = results.result()

        classification_results = []

        for document in analyze_result.documents:
            pages = []
            confidence_level = document.confidence
            document_type = document.doc_type
            bounding_regions = document.bounding_regions

            for bounding_region in bounding_regions:
                page_number = bounding_region.page_number
                pages.append(str(page_number))

            classification_result = ClassificationResult(document_type, confidence_level, pages)
            classification_results.append(classification_result)

        return classification_results

    def extract_buffer(self, extractor_model_id: str, buffer: bytes, pages: list[str]):
        buffer_bytes = io.BytesIO(buffer)
        selected_pages = ",".join(pages)

        results = self.client.begin_analyze_document(model_id=extractor_model_id, analyze_request=buffer_bytes,
                                                     content_type="application/octet-stream", pages=selected_pages)

        result: AnalyzeResult = results.result()

        return result

    def __str__(self):
        obj = {"endpoint": self.endpoint, "key": self.key}
        return json.dumps(obj)

    def __repr__(self):
        return self.__str__()


class ClassificationResult:
    def __init__(self, document_type: str, confidence: float, pages: list[str]):
        self.document_type = document_type
        self.pages = pages
        self.confidence = confidence

    def get_document_type(self):
        return self.document_type

    def get_pages(self):
        return self.pages

    def get_confidence(self):
        return self.confidence

    def __str__(self):
        obj = {"document_type": self.document_type, "pages": self.pages, "confidence": self.confidence}
        return json.dumps(obj)

    def __repr__(self):
        return self.__str__()


class ExtractionResult:

    def __init__(self, field_mappings: dict):
        self.confidence = 0.0
        self.raw_text = None
        self.field_mappings = field_mappings

    def get_field_key(self, field_key: str):
        keys = self.field_mappings.keys()
        if field_key in keys:
            return self.field_mappings[field_key]
        return ''

    def get_value_string(self, field_dictionary: dict, field_name):
        keys = field_dictionary.keys()
        value = None
        if field_name in keys:
            field: dict = field_dictionary[field_name]

            if field is not None:
                field_keys = field.keys()
                if "valueString" in field_keys:
                    value = field["valueString"]

        return value

    def get_value_date(self, field_dictionary, field_name):
        field = field_dictionary.get(field_name)
        value = None
        if field:
            if field.get("valueDate"):
                value = field.get("valueDate")
        else:
            value = field.get("content")
        return value

    def get_selection_mark(self, field_dictionary, field_name):
        field = field_dictionary.get(field_name)
        value = False
        if field:
            if field.get("valueSelectionMark"):
                value = field.get("valueSelectionMark") == 'selected'
        return value

    def __repr__(self):
        obj = self.__dict__
        return json.dumps(obj)

class Form01ExtractionResult(ExtractionResult):

    def __init__(self, field_mappings: dict):
        super().__init__(field_mappings)

        self.student_id = ""
        self.student_name = ""
        self.school_district = ""
        self.school_name = ""
        self.exam_date = ""

        self.question_1 = ""
        self.question_2 = ""
        self.question_3 = ""
        self.question_4 = ""

    def parse_extraction_result(self, analyzed_result: AnalyzeResult):
        student_id_field_key = self.get_field_key("student_id")
        student_name_field_key = self.get_field_key("student_name")
        school_district_field_key = self.get_field_key("school_district")
        school_name_field_key = self.get_field_key("school_name")
        exam_date_field_key = self.get_field_key("exam_date")

        question_1_field_key = self.get_field_key("question_1")
        question_2_field_key = self.get_field_key("question_2")
        question_3_field_key = self.get_field_key("question_3")
        question_4_field_key = self.get_field_key("question_4")

        # extract the first document from the list of documents
        document = analyzed_result.documents[0]

        self.confidence = document.confidence
        self.raw_text = analyzed_result.content

        fields = document.fields.items()

        self.student_id = self.get_value_string(fields, student_id_field_key)
