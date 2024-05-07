from models.students import ExamIdentifier
from shared.assistant_tools import serialize_assistant_response
from shared.cosmos_db_utils import CosmosDbUtils


def v_is_registered_student(student_id: str) -> str:
    result = is_registered_student(student_id)
    return serialize_assistant_response(result)


def v_get_student_submissions(student_id: str) -> str:
    result = get_student_submissions(student_id)
    return serialize_assistant_response(result)


def v_get_student_submissions_by_date(student_id: str, exam_date: str) -> str:
    result = get_student_submissions_by_date(student_id, exam_date)
    return serialize_assistant_response(result)


def v_get_student_submissions_by_exam_id(student_id: str, exam_id: ExamIdentifier) -> str:
    result = get_student_submissions_by_exam_id(student_id, exam_id)
    return serialize_assistant_response(result)


# get_submission_details
def v_get_submission_details(student_id: str, submission_id: str) -> str:
    result = get_submission_details(student_id, submission_id)
    return serialize_assistant_response(result)


# get_student_grades

def v_get_student_grades(student_id: str) -> str:
    result = get_student_grades(student_id)
    return serialize_assistant_response(result)


# get_submission_grade_details
def v_get_submission_grade_details(student_id: str, submission_id: str) -> str:
    result = get_submission_grade_details(student_id, submission_id)
    return serialize_assistant_response(result)


def v_student_has_exam_submissions(student_id: str) -> str:
    result = student_has_exam_submissions(student_id)
    return serialize_assistant_response(result)


def v_student_has_exam_grades(student_id: str) -> str:
    result = student_has_exam_grades(student_id)
    return serialize_assistant_response(result)


def student_has_exam_submissions(student_id: str) -> bool:
    submissions = get_student_submissions(student_id)
    return len(submissions) > 0


def student_has_exam_grades(student_id: str) -> bool:
    grades = get_student_grades(student_id)
    return len(grades) > 0


def get_student_submissions(student_id: str):
    cosmos_util = CosmosDbUtils("examsubmissions")

    query = "SELECT * FROM e WHERE e.student_id = '{}'".format(student_id)

    retrieval_response = cosmos_util.query_container(query, enable_cross_partition_query=True)

    results = []

    for item in retrieval_response:
        result_item = {
            "submissionId": item["submissionId"],
            "examId": item["exam_id"],
            "examName": item["exam_name"],
            "examDate": item["exam_date"]
        }

        results.append(result_item)

    return results


def get_student_submissions_by_date(student_id: str, exam_date: str):
    cosmos_util = CosmosDbUtils("examsubmissions")

    query = "SELECT * FROM e WHERE e.student_id = '{}' AND e.exam_date = '{}'".format(student_id, exam_date)

    retrieval_response = cosmos_util.query_container(query, enable_cross_partition_query=True)

    results = []

    for item in retrieval_response:
        result_item = {
            "submissionId": item["submissionId"],
            "examId": item["exam_id"],
            "examName": item["exam_name"],
            "examDate": item["exam_date"]
        }

        results.append(result_item)

    return results


def get_student_submissions_by_exam_id(student_id: str, exam_identifier: ExamIdentifier):
    cosmos_util = CosmosDbUtils("examsubmissions")

    query = "SELECT * FROM e WHERE e.student_id = '{}' AND e.exam_id = '{}'".format(student_id, exam_identifier)

    retrieval_response = cosmos_util.query_container(query, enable_cross_partition_query=True)

    results = []

    for item in retrieval_response:
        result_item = {
            "submissionId": item["submissionId"],
            "examId": item["exam_id"],
            "examName": item["exam_name"],
            "examDate": item["exam_date"]
        }

        results.append(result_item)

    return results


def get_submission_details(student_id: str, submission_id: str):
    cosmos_util = CosmosDbUtils("examsubmissions")

    query = "SELECT * FROM e WHERE e.student_id = '{}' AND e.submissionId = '{}'".format(student_id, submission_id)

    retrieval_response = cosmos_util.query_container(query, enable_cross_partition_query=True)

    for item in retrieval_response:
        return item

    return None


def get_student_grades(student_id: str):
    cosmos_util = CosmosDbUtils("grades")

    query = "SELECT * FROM g WHERE g.student_id = '{}'".format(student_id)

    retrieval_response = cosmos_util.query_container(query, enable_cross_partition_query=True)

    results = []

    for item in retrieval_response:
        result_item = {
            "submissionId": item["submissionId"],
            "examId": item["exam_id"],
            "examName": item["exam_name"],
            "examDate": item["exam_date"],
            "totalQuestions": item["total_questions"],
            "correctAnswers": item["correct_answers"],
            "examScore": item["exam_score"],
            "letterGrade": item["letter_grade"]
        }

        results.append(result_item)

    return results


def get_submission_grade_details(student_id: str, submission_id: str):
    cosmos_util = CosmosDbUtils("grades")

    query = "SELECT * FROM g WHERE g.student_id = '{}' AND g.submissionId = '{}'".format(student_id, submission_id)

    retrieval_response = cosmos_util.query_container(query, enable_cross_partition_query=True)

    for item in retrieval_response:
        return item

    return None


def is_registered_student(student_id: str):
    cosmos_util = CosmosDbUtils("students")

    student_identifier = int(student_id)

    query = "SELECT * FROM s WHERE s.studentId = {}".format(student_identifier)

    retrieval_response = cosmos_util.query_container(query, enable_cross_partition_query=True)

    for item in retrieval_response:
        print(item)
        return True

    return False
