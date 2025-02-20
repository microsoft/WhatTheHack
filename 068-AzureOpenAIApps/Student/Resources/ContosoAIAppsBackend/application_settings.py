import json
import os
from enum import StrEnum

from typing import TypedDict

from openai.types.chat import ChatCompletionToolParam


class DocumentIntelligenceSetting:
    def __init__(self, classifier_type, extractor_type, model_description, fields: dict[str, str]):
        self.classifier_document_type: str = classifier_type
        self.extractor_model_name: str = extractor_type
        self.model_description: str = model_description
        self.fields: dict[str, str] = fields

    def __repr__(self):
        obj = self.__dict__
        return json.dumps(obj)

    def __str__(self):
        return self.__repr__()


class AssistantConfig(TypedDict):
    system_message: str
    tools: list[ChatCompletionToolParam]


class AssistantName(StrEnum):
    DONALD = 'donald'
    CALLUM = 'callum'
    VETA = 'veta'
    PRISCILLA = 'priscilla'
    MURPHY = 'murphy'
    SOLOMON = 'solomon'


class ApplicationSettings:

    def __init__(self):
        self.root_directory = os.path.dirname(os.path.abspath(__file__))

    def get_assistant_config(self, assistant_name: AssistantName):
        tools_file_path = self.root_directory + "/assistant_configurations/" + assistant_name + ".json"
        system_message_file_path = self.root_directory + "/assistant_configurations/" + assistant_name + ".txt"

        json_data: AssistantConfig = {"system_message": "", "tools": []}

        with open(tools_file_path, "r") as tools_file:
            tools_list = json.load(tools_file)
            json_data['tools'] = tools_list

        with open(system_message_file_path, "r") as system_message_file:
            file_content_encoding = 'utf-8'
            system_message_content = system_message_file.read()
            json_data['system_message'] = system_message_content

        return json_data

    def document_intelligence_settings(self) -> list[DocumentIntelligenceSetting]:
        file_path = self.root_directory + "/document-intelligence-dictionary.json"

        json_data: list[dict] = []
        result: list[DocumentIntelligenceSetting] = []

        with open(file_path, "r") as file:
            json_data = json.load(file)

            file.close()

        for document_intelligence in json_data:
            classifier_document_type = document_intelligence['classifier_document_type']
            extractor_model_name = document_intelligence['extractor_model_name']
            model_description = document_intelligence['model_description']
            fields = document_intelligence['fields']

            document_config = DocumentIntelligenceSetting(classifier_type=classifier_document_type,
                                                          extractor_type=extractor_model_name,
                                                          model_description=model_description,
                                                          fields=fields)

            result.append(document_config)
        return result

    def retrieve_document_intelligence_section(self, index: int):
        sections = self.document_intelligence_settings()
        return sections[index]
