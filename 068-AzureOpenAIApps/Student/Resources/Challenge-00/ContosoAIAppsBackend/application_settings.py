import json
import os


class DocumentIntelligenceSetting:
    def __init__(self, classifier_type, extractor_type, model_description, fields: dict[str, str]):
        self.classifier_document_type = classifier_type
        self.extractor_model_name = extractor_type
        self.model_description = model_description
        self.fields: dict[str, str] = fields

    def __repr__(self):
        obj = self.__dict__
        return json.dumps(obj)

    def __str__(self):
        return self.__repr__()


class ApplicationSettings:

    def __init__(self):
        self.root_directory = os.path.dirname(os.path.abspath(__file__))

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
