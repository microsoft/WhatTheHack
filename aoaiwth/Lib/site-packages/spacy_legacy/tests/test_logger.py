import pytest
from spacy_legacy.loggers import wandb_logger_v1


def test_logger():
    wandb_logger_v1("test", [])
