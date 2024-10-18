import azure.functions as func


class APIResponse:
    """Base class for all API responses"""

    def __init__(self, response_body, http_status_code):
        """Constructor for APIResponse class"""
        self.status_code = http_status_code
        self.response_headers = {"Content-Type": "application/json"}
        self.response_body = response_body

    def set_response_body(self, response_body):
        self.response_body = response_body
        return self

    def reset_headers(self):
        """Resets response headers"""
        self.response_headers = {}

    def add_response_header(self, name, value):
        self.response_headers[name] = value
        return self

    def build_response(self):
        status_code = self.status_code
        response_headers = self.response_headers
        return func.HttpResponse(self.response_body, status_code=status_code, headers=response_headers)


class APISuccessOK(APIResponse):
    """API Response with success"""

    def __init__(self, response_body):
        super().__init__(response_body, 200)


class APISuccessNoContent(APIResponse):
    """API Response with success"""

    def __init__(self):
        super().__init__(None, 204)


class APIBadRequest(APIResponse):
    """API Response with success"""

    def __init__(self, response_body):
        super().__init__(response_body, 400)


class APIAuthenticationRequired(APIResponse):
    """API Response with success"""

    def __init__(self, response_body):
        super().__init__(response_body, 401)


class APIAuthenticationFailed(APIResponse):
    """API Response with auth failure"""

    def __init__(self, response_body):
        super().__init__(response_body, 403)


class APINotFound(APIResponse):
    """API Response with not found error"""

    def __init__(self, response_body):
        super().__init__(response_body, 404)


class APIConflict(APIResponse):
    """API Response with conflict error"""

    def __init__(self, response_body):
        super().__init__(response_body, 409)


class APIInternalServerError(APIResponse):
    """API Response with internal server error"""

    def __init__(self, response_body):
        super().__init__(response_body, 500)
