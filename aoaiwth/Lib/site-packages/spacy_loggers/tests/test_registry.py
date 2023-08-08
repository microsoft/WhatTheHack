import pytest
from spacy import registry

FUNCTIONS = [
    ("loggers", "spacy.WandbLogger.v1"),
    ("loggers", "spacy.WandbLogger.v2"),
    ("loggers", "spacy.WandbLogger.v3"),
    ("loggers", "spacy.WandbLogger.v4"),
    ("loggers", "spacy.MLflowLogger.v1"),
    ("loggers", "spacy.ClearMLLogger.v1"),
]


@pytest.mark.parametrize("reg_name,func_name", FUNCTIONS)
def test_registry(reg_name, func_name):
    assert registry.has(reg_name, func_name)
    assert registry.get(reg_name, func_name)
