from shared.assistant_tools import get_contoso_information, serialize_assistant_response


def v_get_examination_reference_information(query: str) -> str:
    """Returns the information from the AI Search index based on the query provided"""
    result = get_contoso_information(query)
    return serialize_assistant_response(result)


def v_get_exam_answers(question_id: str, examination_question: str) -> str:
    """Returns the information from the AI Search index based on the query provided"""
    print("Checking answers for examination question id {}: {}".format(question_id, examination_question))
    result = get_contoso_information(examination_question)
    return serialize_assistant_response(result)

