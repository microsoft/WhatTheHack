import os

from shared.logging_utils import LoggingUtils
from shared.redis_utils import RedisUtil
from shared.service_bus_utils import ServiceBusUtils


class QuotaEnforcementManager:
    def __init__(self, queue_name: str):
        self.queue_name = queue_name.lower()
        self.service_bus_util = ServiceBusUtils()
        self.redis_util = RedisUtil()

        quota_enforcement_enabled: int = int(os.environ.get('LLM_QUOTA_ENFORCEMENT', '0'))
        quota_enforcement_window_seconds: int = int(os.environ.get('LLM_QUOTA_ENFORCEMENT_WINDOW_SECONDS', '60'))
        quota_enforcement_max_transactions: int = int(os.environ.get('LLM_QUOTA_ENFORCEMENT_MAX_TRANSACTIONS', '3'))
        quota_enforcement_cool_down_seconds: int = int(os.environ.get('LLM_QUOTA_ENFORCEMENT_COOL_DOWN_SECONDS', '180'))

        self.quota_enforcement_enabled = quota_enforcement_enabled > 0
        self.quota_enforcement_window_seconds = quota_enforcement_window_seconds
        self.quota_enforcement_max_transactions = quota_enforcement_max_transactions
        self.quota_enforcement_cool_down_seconds = quota_enforcement_cool_down_seconds

        self.quota_enforcement_tracker_lookup_key = "quota_enforcement_tracking_{}".format(queue_name)
        self.quota_enforcement_tracker_flag_key = "quota_enforcement_tracking_flag_{}".format(queue_name)
        self.quota_enforcement_tracker_start_key = "quota_enforcement_tracking_started_{}".format(queue_name)

    def increment_transaction_count(self):

        if self.quota_enforcement_enabled is False:
            return 0

        transaction_start_key = self.quota_enforcement_tracker_start_key
        transaction_count_key = self.quota_enforcement_tracker_lookup_key

        transaction_started = self.redis_util.exists(transaction_start_key)

        if transaction_started:
            print("Transaction tracking already started")
        else:
            self.redis_util.delete(transaction_count_key)
            self.redis_util.set(transaction_start_key, "1", self.quota_enforcement_window_seconds)

        transaction_count = self.redis_util.increment(transaction_count_key, 1)

        print("Transaction Count for Queue {} is now {}".format(self.queue_name, transaction_count))
        return transaction_count

    def suspend_queue_if_necessary(self):

        if self.quota_enforcement_enabled is False:
            return 0

        transaction_count_key = self.quota_enforcement_tracker_lookup_key
        enforcement_flag_key = self.quota_enforcement_tracker_flag_key

        transaction_count = self.redis_util.increment(transaction_count_key, 0)

        if transaction_count > self.quota_enforcement_max_transactions:
            cool_down_seconds = self.quota_enforcement_cool_down_seconds
            self.redis_util.set(enforcement_flag_key, "1", cool_down_seconds)
            self.service_bus_util.update_queue_receive_disabled(self.queue_name)

            event_name = "ACTIVATE_QUEUE_{}".format(self.queue_name)
            LoggingUtils.track_event(event_name)

            print("Queue {} is now suspended".format(self.queue_name))

        return 1

    def reactivate_queue_if_necessary(self):

        if self.quota_enforcement_enabled is False:
            return 0

        enforcement_flag_key = self.quota_enforcement_tracker_flag_key

        queue_is_still_suspended = self.redis_util.exists(enforcement_flag_key)

        if queue_is_still_suspended:
            print("Queue is still suspended due to quota enforcement {}".format(self.queue_name))
        else:
            print("Reactivating Queue {}".format(self.queue_name))
            event_name = "DEACTIVATE_QUEUE_{}".format(self.queue_name)
            LoggingUtils.track_event(event_name)
            self.service_bus_util.update_queue_active(self.queue_name)

        return 1
