from models.students import Student, StudentSearchResponse
from shared.cosmos_db_utils import CosmosDbUtils
from shared.yacht_management_utils import remove_non_alphanumeric


def student_management_list_students():
    cosmos_util = CosmosDbUtils("students")

    query = f"SELECT * FROM s"

    retrieval_response = cosmos_util.query_container(query, enable_cross_partition_query=True)
    items = []
    for item in retrieval_response:
        student_id = item["studentId"]
        full_name = item["fullName"]
        school_district = item["schoolDistrict"]
        school_name = item["schoolName"]

        current_record: Student = {
            "studentId": student_id,
            "fullName": full_name,
            "schoolName": school_name,
            "schoolDistrict": school_district
        }

        items.append(current_record)

    return items


def student_management_get_details(student_id: str):
    cosmos_util = CosmosDbUtils("students")

    student_id = remove_non_alphanumeric(student_id)
    student_id = int(student_id)

    query = f"SELECT * FROM y WHERE y.studentId = {student_id}"

    retrieval_response = cosmos_util.query_container(query, enable_cross_partition_query=True)

    for item in retrieval_response:
        student_id = item["studentId"]
        full_name = item["fullName"]
        school_district = item["schoolDistrict"]
        school_name = item["schoolName"]

        current_record: StudentSearchResponse = {
            "id": student_id,
            "studentId": student_id,
            "fullName": full_name,
            "schoolName": school_name,
            "schoolDistrict": school_district
        }

        return current_record

    print("No student found for id {}".format(student_id))
    print("SQL statement executed was {}".format(query))

    return None
