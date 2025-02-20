from application_settings import ApplicationSettings


class ExampleDirectory:

    def __init__(self):
        self.settings = ApplicationSettings()

    def get_example_dir(self):
        util = ApplicationSettings()
        return self.settings.document_intelligence_settings()
