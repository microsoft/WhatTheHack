import json

from application_settings import ApplicationSettings, AssistantConfig, AssistantName
from models.exam_submissions import ExamSubmission, ExamSubmissionQuestion, ExamAnswerAnalysis, AnswerAnalysis
from models.students import ExamGrade
from shared.assistant_tools import get_current_unix_timestamp
from shared.assistant_tools_solomon import v_get_examination_reference_information, v_get_exam_answers
from shared.cosmos_db_utils import CosmosDbUtils
from shared.tool_utils import ToolUtils


class GradeExamSubmission:
    def __init__(self, submission: ExamSubmission):
        self.submission = submission
        self.conversation_id = str(get_current_unix_timestamp())

    def compute_letter_grade(self, exam_score: float) -> ExamGrade:

        if exam_score < 60.00:
            return ExamGrade.F

        elif exam_score < 70.00:
            return ExamGrade.D

        elif exam_score < 80.00:
            return ExamGrade.C

        elif exam_score < 90.00:
            return ExamGrade.B

        else:
            return ExamGrade.A

    def process_submission(self):
        settings = ApplicationSettings()
        assistant_config: AssistantConfig = settings.get_assistant_config(assistant_name=AssistantName.SOLOMON)

        system_message = assistant_config["system_message"]
        tools_config = assistant_config["tools"]

        util = ToolUtils(AssistantName.SOLOMON, system_message, tools_config, self.conversation_id)

        util.register_tool_mapping("get_exam_answers", v_get_exam_answers)

        util.set_response_format_json()

        questions: list[ExamSubmissionQuestion] = self.submission['questions']

        student_submission = json.dumps(questions)

        user_message = """
        The following is a submission of answers to questions by a student. 
        Please check each of the answers carefully to make ensure the answers are correct.
        These are the answers to each of the questions:
        
        """
        user_message += student_submission

        print(user_message)

        results = util.run_conversation(user_message)

        assistant_response: str = results.content

        assistant_response_object = json.loads(assistant_response)

        answers_analysis: list[ExamAnswerAnalysis] = assistant_response_object['answers_analysis']

        total_questions = 0
        correct_answers = 0

        analysis_response = self.submission

        if len(answers_analysis) > 0:

            for answer in answers_analysis:
                total_questions += 1

                if answer['is_correct'] is True:
                    correct_answers += 1

            exam_score = (correct_answers / total_questions) * 100
            letter_grade: ExamGrade = self.compute_letter_grade(exam_score)

            results = {
                "answers_analysis": answers_analysis,
                "correct_answers": correct_answers,
                "total_questions": total_questions,
                "exam_score": exam_score,
                "letter_grade": letter_grade
            }

            analysis_response.update(results)

        cosmos_util = CosmosDbUtils("grades")

        cosmos_util.upsert_item(analysis_response)

        return analysis_response
