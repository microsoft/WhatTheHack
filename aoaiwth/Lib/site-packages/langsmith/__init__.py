"""LangSmith Client."""
from importlib import metadata

from langsmith.client import Client
from langsmith.evaluation.evaluator import EvaluationResult, RunEvaluator
from langsmith.run_trees import RunTree

try:
    __version__ = metadata.version(__package__)
except metadata.PackageNotFoundError:
    # Case where package metadata is not available.
    __version__ = ""

__all__ = [
    "Client",
    "RunTree",
    "__version__",
    "EvaluationResult",
    "RunEvaluator",
]
