from shared.assistant_tools import get_contoso_information, serialize_assistant_response


def v_get_contoso_information(query: str) -> str:
    """Returns the information from the AI Search index based on the query provided"""
    result = get_contoso_information(query)
    return serialize_assistant_response(result)
