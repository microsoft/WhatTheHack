import logging

import azure.functions as func

from shared.quota_enforcement_manager import QuotaEnforcementManager

quota_controller = func.Blueprint()


@quota_controller.function_name("app_llm_quota_enforcement_manager")
@quota_controller.timer_trigger(schedule="*/15 * * * * *",
                                arg_name="mytimer",
                                run_on_startup=True)
def llm_quota_enforcement_manager(mytimer: func.TimerRequest) -> None:
    logging.info('Python HTTP trigger function processed a request.')
    logging.info('Initializing Application Initializer')

    service_bus_queues: list[str] = ["grapefruit", "lemon", "orange", "tangerine"]

    for service_bus_queue_name in service_bus_queues:
        quota_manager = QuotaEnforcementManager(service_bus_queue_name)
        quota_manager.reactivate_queue_if_necessary()
