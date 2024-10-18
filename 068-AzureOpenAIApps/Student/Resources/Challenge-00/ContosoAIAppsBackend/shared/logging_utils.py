from typing import Optional, Dict

from azure.monitor.events.extension import track_event
from azure.monitor.opentelemetry import configure_azure_monitor


class LoggingUtils:
    initialized = False

    @staticmethod
    def initialize_logger() -> bool:
        if LoggingUtils.initialized is False:
            configure_azure_monitor()
            LoggingUtils.initialized = True
            return False
        else:
            return True

    @staticmethod
    def track_event(name: str, custom_dimensions: Optional[Dict[str, str]] = None):
        LoggingUtils.initialize_logger()
        track_event(name, custom_dimensions)
