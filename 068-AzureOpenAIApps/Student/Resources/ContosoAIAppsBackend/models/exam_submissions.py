from typing import TypedDict


class ExamSubmissionQuestion(TypedDict):
    question_id: str
    examination_question: str
    student_answer: str


class ExamAnswerAnalysis(ExamSubmissionQuestion):
    correct_answer: str
    is_correct: bool


class ExamSubmission(TypedDict):
    id: str
    submissionId: str
    student_id: str
    student_name: str
    school_district: str
    school_name: str
    exam_date: str
    questions: list[ExamSubmissionQuestion]


class AnswerAnalysis(ExamSubmission):
    answer_analysis: list[ExamAnswerAnalysis]
    total_questions: int
    correct_answers: int
    exam_score: float
