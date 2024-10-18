import io
import json
import os
from datetime import datetime
from typing import IO, Callable

from azure.ai.documentintelligence import DocumentIntelligenceClient
from azure.ai.documentintelligence.models import AnalyzeResult, DocumentField, \
    DocumentAnalysisFeature, DocumentSelectionMarkState, DocumentSignatureType
from azure.core.credentials import AzureKeyCredential

from application_settings import ApplicationSettings


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


class DocumentIntelligenceUtil:

    def __init__(self, endpoint, key, api_version):
        self.endpoint = endpoint
        self.key = key
        self.api_version = api_version

        credentials = AzureKeyCredential(key)
        self.client = DocumentIntelligenceClient(endpoint, credentials, api_version=api_version)

    def classify_buffer(self, classifier_model_id: str, buffer: bytes) -> list[ClassificationResult]:

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
                                                     content_type="application/octet-stream", pages=selected_pages,
                                                     features=[DocumentAnalysisFeature.QUERY_FIELDS])

        result: AnalyzeResult = results.result()

        return result

    def __str__(self):
        obj = {"endpoint": self.endpoint, "key": self.key}
        return json.dumps(obj)

    def __repr__(self):
        return self.__str__()


class ActivityRequest:
    def __init__(self, experience_name: str, preferred_time: str, party_size: str):
        self.experience_name = experience_name
        self.preferred_time = preferred_time
        self.party_size = self._get_default_int_if_empty(party_size)

    def _get_default_int_if_empty(self, value: str):
        if value:
            return int(value)
        else:
            return 0

    def _get_default_float_if_empty(self, value: str):
        if value:
            return float(value)
        else:
            return 0.0

    def __repr__(self):
        obj = self.__dict__
        return json.dumps(obj)

    def __str__(self):
        return self.__repr__()

    def __json__(self):
        return {"experience_name": self.experience_name,
                "preferred_time": self.preferred_time, "party_size": self.party_size}


class ExtractionResult:

    def __init__(self, field_mappings: dict):
        self.confidence = 0.0
        self.raw_text = None
        self.field_mappings = field_mappings

    def convert_american_date_to_iso(self, american_date: str) -> str:
        input_format = "%m/%d/%Y"
        output_format = "%Y-%m-%d"

        date_object = datetime.strptime(american_date, input_format)

        return date_object.strftime(output_format)

    def get_submission(self):
        results = {
            "confidence": self.confidence,
            "raw_text": self.raw_text
        }
        return results

    def get_field_key(self, field_key: str):
        keys = self.field_mappings.keys()
        if field_key in keys:
            return self.field_mappings[field_key]
        else:
            raise KeyError("Field key '{}' not found in field_mappings dictionary -> {}".format(field_key,
                                                                                                self.field_mappings))

    def get_value_number(self, field_dictionary: dict[str, DocumentField], field_name) -> float:
        if field_name in field_dictionary and field_dictionary[field_name]:
            if field_dictionary[field_name].value_number:
                return field_dictionary[field_name].value_number
            else:
                return float(field_dictionary[field_name].content)
        else:
            return 0.0

    def get_value_integer(self, field_dictionary: dict[str, DocumentField], field_name) -> int:
        if field_name in field_dictionary and field_dictionary[field_name]:
            if field_dictionary[field_name].value_integer:
                return field_dictionary[field_name].value_integer
            else:
                return int(field_dictionary[field_name].content)
        else:
            return 0

    def get_value_string(self, field_dictionary: dict[str, DocumentField], field_name) -> str:
        if field_name in field_dictionary and field_dictionary[field_name]:
            if field_dictionary[field_name].value_string:
                return field_dictionary[field_name].value_string
            else:
                return field_dictionary[field_name].content
        else:
            return ''

    def get_value_date(self, field_dictionary: dict[str, DocumentField], field_name):
        if field_name in field_dictionary and field_dictionary[field_name]:
            if field_dictionary[field_name].value_date:
                return field_dictionary[field_name].value_date
            else:
                return field_dictionary[field_name].content
        else:
            return None

    def is_selected_mark(self, field_dictionary: dict[str, DocumentField], field_name) -> bool:
        if field_name in field_dictionary and field_dictionary[field_name]:
            if field_dictionary[field_name].value_selection_mark:
                selection_mark_state: DocumentSelectionMarkState = field_dictionary[field_name].value_selection_mark
                return selection_mark_state == DocumentSelectionMarkState.SELECTED
            else:
                return False
        else:
            return False

    def is_document_signed(self, field_dictionary: dict[str, DocumentField], field_name) -> bool:
        if field_name in field_dictionary and field_dictionary[field_name]:
            if field_dictionary[field_name].value_signature:
                selection_mark_state: DocumentSignatureType = field_dictionary[field_name].value_signature
                return selection_mark_state == DocumentSignatureType.SIGNED
            else:
                return False
        else:
            return False

    def get_table_rows(self, field_dictionary: dict[str, DocumentField],
                       table_name, column_names: list[str]) -> list[dict]:
        results: list[dict] = []
        if table_name not in field_dictionary:
            dictionary_keys = field_dictionary.keys()
            raise KeyError(f"Table field [{table_name}] does not exist in parsed field dictionary {dictionary_keys}")
        if table_name in field_dictionary and field_dictionary[table_name] and field_dictionary[table_name].value_array:
            rows: list[DocumentField] = field_dictionary[table_name].value_array
            for row in rows:
                current_row = {}
                for column_name in column_names:
                    print(f"======================={column_name} ==={row.value_object}==================")
                    if row.value_object and column_name in row.value_object.keys():
                        current_row[column_name] = row.value_object[column_name].content
                results.append(current_row)
            return results
        else:
            return results

    def __repr__(self):
        obj = self.__dict__
        return json.dumps(obj)

    def __str__(self):
        return self.__repr__()

    def prepare_question(self, question_id: str, question: str, answer: str):
        question = {"question_id": question_id, "examination_question": question, "student_answer": answer}
        return question


class Form01ExtractionResult(ExtractionResult):

    def __init__(self, field_mappings: dict):
        super().__init__(field_mappings)

        self.exam_id = "F01"
        self.exam_name = "Civics - Geography and Climate Exam"

        self.student_id = ""
        self.student_name = ""
        self.school_district = ""
        self.school_name = ""
        self.exam_date = ""

        self.question_1 = ""
        self.question_2 = ""
        self.question_3 = ""
        self.question_4 = ""

    def get_submission(self):

        exam_date = self.convert_american_date_to_iso(self.exam_date)

        results = {
            "exam_id": self.exam_id,
            "exam_name": self.exam_name,
            "student_id": self.student_id,
            "student_name": self.student_name,
            "school_district": self.school_district,
            "school_name": self.school_name,
            "exam_date": exam_date,
            "questions": [
                self.prepare_question("1",
                                      "What are the names of the islands that make up Contoso Islands?",
                                      self.question_1),
                self.prepare_question("2",
                                      "Where is the capital of Contoso Islands?",
                                      self.question_2),
                self.prepare_question("3",
                                      "How many seasons does the Contoso Islands have?",
                                      self.question_3),
                self.prepare_question("4",
                                      "What month is the start of the dry season?",
                                      self.question_4)
            ]
        }
        return results

    def parse_extraction_result(self, analyzed_result: AnalyzeResult):
        if (analyzed_result and analyzed_result.documents and analyzed_result.documents[0] and
                analyzed_result.documents[0].fields):
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
            raw_text: str = analyzed_result.content
            if raw_text:
                self.raw_text = raw_text

            fields: dict[str, DocumentField] = document.fields

            self.student_id = self.get_value_string(fields, student_id_field_key)
            self.student_name = self.get_value_string(fields, student_name_field_key)
            self.school_district = self.get_value_string(fields, school_district_field_key)
            self.school_name = self.get_value_string(fields, school_name_field_key)
            self.exam_date = self.get_value_string(fields, exam_date_field_key)

            self.question_1 = self.get_value_string(fields, question_1_field_key)
            self.question_2 = self.get_value_string(fields, question_2_field_key)
            self.question_3 = self.get_value_string(fields, question_3_field_key)
            self.question_4 = self.get_value_string(fields, question_4_field_key)


class Form02ExtractionResult(Form01ExtractionResult):
    def __init__(self, field_mappings: dict):
        super().__init__(field_mappings)

        self.exam_id = "F02"
        self.exam_name = "Civics - Tourism and Economy"

    def get_submission(self):
        exam_date = self.convert_american_date_to_iso(self.exam_date)
        results = {
            "exam_id": self.exam_id,
            "exam_name": self.exam_name,
            "student_id": self.student_id,
            "student_name": self.student_name,
            "school_district": self.school_district,
            "school_name": self.school_name,
            "exam_date": exam_date,
            "questions": [
                self.prepare_question("1",
                                      "What is the national currency of the Contoso Islands?",
                                      self.question_1),
                self.prepare_question("2",
                                      "What is the income tax rate in Contoso Islands?",
                                      self.question_2),
                self.prepare_question("3",
                                      "What are the official languages spoken in the Contoso Islands?",
                                      self.question_3),
                self.prepare_question("4",
                                      "How many people travel to Contoso Islands each year?",
                                      self.question_4)
            ]
        }
        return results


class Form03ExtractionResult(Form01ExtractionResult):
    def __init__(self, field_mappings: dict):
        super().__init__(field_mappings)
        self.question_5 = ""

        self.exam_id = "F03"
        self.exam_name = "Civics - Government and Politics"

    def parse_extraction_result(self, analyzed_result: AnalyzeResult):
        super().parse_extraction_result(analyzed_result)

        if (analyzed_result and analyzed_result.documents and analyzed_result.documents[0] and
                analyzed_result.documents[0].fields):
            question_5_field_key = self.get_field_key("question_5")
            document = analyzed_result.documents[0]
            extracted_fields: dict[str, DocumentField] = document.fields
            self.question_5 = self.get_value_string(extracted_fields, question_5_field_key)

    def get_submission(self):
        exam_date = self.convert_american_date_to_iso(self.exam_date)
        results = {
            "exam_id": self.exam_id,
            "exam_name": self.exam_name,
            "student_id": self.student_id,
            "student_name": self.student_name,
            "school_district": self.school_district,
            "school_name": self.school_name,
            "exam_date": exam_date,
            "questions": [
                self.prepare_question("1",
                                      "Who is the president of Contoso Islands?",
                                      self.question_1),
                self.prepare_question("2",
                                      "Who is the vice president of Contoso Islands?",
                                      self.question_2),
                self.prepare_question("3",
                                      "Where does the vice president of Contoso Islands Live?",
                                      self.question_3),
                self.prepare_question("4",
                                      "Who is the Minister of Agriculture?",
                                      self.question_4),
                self.prepare_question("5",
                                      "Who is the Minister of Finance?",
                                      self.question_5)
            ]
        }
        return results


class Form04ExtractionResult(ExtractionResult):
    ACTIVITY_FLOATING_MUSEUMS = "Contoso Floating Museums"
    ACTIVITY_SOLAR_YACHTS = "Contoso Solar Yachts"
    ACTIVITY_SPA = "Contoso Beachfront Spa"
    ACTIVITY_DOLPHIN_TOUR = "Contoso Dolphin and Turtle Tour"

    def __init__(self, field_mappings: dict):
        super().__init__(field_mappings)

        self.guest_full_name = ""
        self.guest_email_address = ""
        self.guest_signature = False
        self.signature_date = ""
        self.activity_preferences: list[str] = []
        self.activity_requests: list[dict] = []

    def get_submission(self):
        signature_date = self.convert_american_date_to_iso(self.signature_date)
        results = {
            "guest_full_name": self.guest_full_name,
            "guest_email_address": self.guest_email_address,
            "guest_signature": self.guest_signature,
            "signature_date": signature_date,
            "activity_preferences": self.activity_preferences,
            "activity_requests": self.activity_requests
        }
        return results

    def append_to_activity_if_selected(self, is_selected, value_if_exists):
        if is_selected:
            self.activity_preferences.append(value_if_exists)

    def append_to_activity_requests(self, request: ActivityRequest):
        self.activity_requests.append(request.__json__())

    def get_field_value_if_exists(self, dictionary: dict, field_name: str, default='') -> str:
        if field_name in dictionary:
            return dictionary[field_name]
        return default

    def parse_extraction_result(self, analyzed_result: AnalyzeResult):
        if (analyzed_result and analyzed_result.documents and analyzed_result.documents[0] and
                analyzed_result.documents[0].fields):
            # extracting guest information, contact info and signatures
            guest_full_name_key = self.get_field_key("guest_full_name")
            guest_email_address_key = self.get_field_key("guest_email_address")
            guest_signature_key = self.get_field_key("signature_field_name")
            guest_signature_date_key = self.get_field_key("signature_date_field_name")

            # activity interests and preferences
            checkbox_contoso_floating_museums_key = self.get_field_key("checkbox_contoso_floating_museums")
            checkbox_contoso_solar_yachts_key = self.get_field_key("checkbox_contoso_solar_yachts")
            checkbox_contoso_beachfront_spa_key = self.get_field_key("checkbox_contoso_beachfront_spa")
            checkbox_contoso_dolphin_turtle_tour_key = self.get_field_key("checkbox_contoso_dolphin_turtle_tour")

            # extracting meal temperature preferences
            guest_activity_requests_table_key = self.get_field_key("table_name")
            table_column_header_experience_name_key = self.get_field_key("table_column_header_experience_name")
            table_column_header_preferred_time_key = self.get_field_key("table_column_header_preferred_time")
            table_column_header_party_size_key = self.get_field_key("table_column_header_party_size")

            document = analyzed_result.documents[0]
            extracted_fields = document.fields

            self.confidence = document.confidence
            raw_text: str = analyzed_result.content
            if raw_text:
                self.raw_text = raw_text

            self.guest_full_name = self.get_value_string(extracted_fields, guest_full_name_key)
            self.guest_email_address = self.get_value_string(extracted_fields, guest_email_address_key)
            self.signature_date = self.get_value_string(extracted_fields, guest_signature_date_key)
            self.guest_signature = self.is_document_signed(extracted_fields, guest_signature_key)

            is_interested_in_museums = self.is_selected_mark(extracted_fields, checkbox_contoso_floating_museums_key)
            is_interested_in_yachts = self.is_selected_mark(extracted_fields, checkbox_contoso_solar_yachts_key)
            is_interested_in_spa = self.is_selected_mark(extracted_fields, checkbox_contoso_beachfront_spa_key)
            is_interested_in_dolphins = self.is_selected_mark(extracted_fields,
                                                              checkbox_contoso_dolphin_turtle_tour_key)

            self.append_to_activity_if_selected(is_interested_in_museums, self.ACTIVITY_FLOATING_MUSEUMS)
            self.append_to_activity_if_selected(is_interested_in_yachts, self.ACTIVITY_SOLAR_YACHTS)
            self.append_to_activity_if_selected(is_interested_in_spa, self.ACTIVITY_SPA)
            self.append_to_activity_if_selected(is_interested_in_dolphins, self.ACTIVITY_DOLPHIN_TOUR)

            # defines the column names we are expecting from the extracted table
            temp_preferences_column_names = [
                table_column_header_experience_name_key,
                table_column_header_preferred_time_key,
                table_column_header_party_size_key
            ]
            # load the table rows and columns dynamically

            table_rows = self.get_table_rows(extracted_fields, guest_activity_requests_table_key,
                                             temp_preferences_column_names)
            for table_row in table_rows:
                current_experience = self.get_field_value_if_exists(table_row, table_column_header_experience_name_key)
                current_pref_time = self.get_field_value_if_exists(table_row, table_column_header_preferred_time_key)
                current_party_size = self.get_field_value_if_exists(table_row, table_column_header_party_size_key)

                # construct the activity request using the extracted cell fields from columns
                current_activity_request = ActivityRequest(current_experience, current_pref_time, current_party_size)

                # append it to our object field of table rows
                self.append_to_activity_requests(current_activity_request)


class DocumentProcessor:
    def __init__(self):
        self.document_classifications = {}
        self.document_class_map: dict[str, str] = {}
        self.field_mappings: dict[str, dict[str, str]] = {}

        self.load_configuration()

        endpoint = os.environ.get("DOCUMENT_INTELLIGENCE_ENDPOINT")
        key = os.environ.get("DOCUMENT_INTELLIGENCE_KEY")
        api_version = os.environ.get("DOCUMENT_INTELLIGENCE_API_VERSION", "2024-02-29-preview")

        self.document_intelligence_util = DocumentIntelligenceUtil(endpoint, key, api_version)

    def register_classification(self, classification_id: str, extractor_id: str,
                                field_map: dict[str, str], position_key: str):
        self.document_class_map[classification_id] = extractor_id
        self.field_mappings[classification_id] = field_map
        self.document_classifications[classification_id] = position_key

    def get_document_classification(self, classification_id: str) -> str:
        return self.document_classifications[classification_id]

    def is_exam_submission(self, classification_id: str) -> bool:
        exam_classifications = ["f01", "f02", "f03"]
        classification_key = self.get_document_classification(classification_id)
        return classification_key in exam_classifications

    def is_activity_preference(self, classification_id: str) -> bool:
        return self.is_exam_submission(classification_id) is False

    def load_configuration(self):
        application_settings = ApplicationSettings()
        document_intelligence_settings = application_settings.document_intelligence_settings()

        f01 = document_intelligence_settings[0]
        self.register_classification(f01.classifier_document_type, f01.extractor_model_name, f01.fields, "f01")

        f02 = document_intelligence_settings[1]
        self.register_classification(f02.classifier_document_type, f02.extractor_model_name, f02.fields, "f02")

        f03 = document_intelligence_settings[2]
        self.register_classification(f03.classifier_document_type, f03.extractor_model_name, f03.fields, "f03")

        f04 = document_intelligence_settings[3]
        self.register_classification(f04.classifier_document_type, f04.extractor_model_name, f04.fields, "f04")

    def process_buffer(self, buffer: bytes):
        classifier_model_id = os.environ.get("DOCUMENT_INTELLIGENCE_CLASSIFIER_MODEL_ID", "2024-02-29-preview")
        classifications = self.document_intelligence_util.classify_buffer(classifier_model_id, buffer)

        return classifications

    def extract_contents(self, buffer: bytes, classifier_model: str, pages: list[str]):
        """Retrieves the digested and processed submission details"""
        extractor_model_id = self.document_class_map[classifier_model]
        contents = self.document_intelligence_util.extract_buffer(extractor_model_id, buffer, pages)
        position = self.document_classifications[classifier_model]

        if position == "f01":
            mappings = self.field_mappings[classifier_model]
            model = Form01ExtractionResult(mappings)
            model.parse_extraction_result(contents)
            return model.get_submission()

        elif position == "f02":
            mappings = self.field_mappings[classifier_model]
            model = Form02ExtractionResult(mappings)
            model.parse_extraction_result(contents)
            return model.get_submission()

        elif position == "f03":
            mappings = self.field_mappings[classifier_model]
            model = Form03ExtractionResult(mappings)
            model.parse_extraction_result(contents)
            return model.get_submission()

        elif position == "f04":
            mappings = self.field_mappings[classifier_model]
            model = Form04ExtractionResult(mappings)
            model.parse_extraction_result(contents)
            return model.get_submission()

        return None
