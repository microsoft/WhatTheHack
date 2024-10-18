from enum import StrEnum
from typing import TypedDict


class Student(TypedDict):
    studentId: str
    fullName: str
    schoolDistrict: str
    schoolName: str


class StudentSearchResponse(Student):
    id: str


class ExamGrade(StrEnum):
    A = "A"
    B = "B"
    C = "C"
    D = "D"
    F = "F"


class ExamIdentifier(StrEnum):
    F01 = "F01"
    F02 = "F02"
    F03 = "F03"
