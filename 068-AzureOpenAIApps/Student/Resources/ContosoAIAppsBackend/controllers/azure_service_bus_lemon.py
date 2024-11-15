import json
import logging

import azure.functions as func

from models.exam_submissions import ExamSubmission
from shared.grade_exam_submission import GradeExamSubmission
from shared.quota_enforcement_manager import QuotaEnforcementManager

service_bus_controller_lemon = func.Blueprint()


@service_bus_controller_lemon.function_name("service_bus_controller_lemon")
@service_bus_controller_lemon.service_bus_queue_trigger(arg_name='record', connection="SERVICE_BUS_CONNECTION_STRING",
                                                        queue_name='lemon')
def service_bus_handler_lemon(record: func.ServiceBusMessage):
    logging.info('service_bus_controller_lemon function processed a request.')

    service_bus_stream = record.get_body()
    exam_submission: ExamSubmission = json.loads(service_bus_stream)

    logging.info('Processed object{}'.format(exam_submission))

    util = GradeExamSubmission(exam_submission)

    result = util.process_submission()

    print(json.dumps(result))

    service_bus_queue_name = "lemon"
    quota_manager = QuotaEnforcementManager(service_bus_queue_name)
    quota_manager.increment_transaction_count()
    quota_manager.suspend_queue_if_necessary()
