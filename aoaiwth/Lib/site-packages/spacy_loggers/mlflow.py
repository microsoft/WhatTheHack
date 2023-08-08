"""
A logger that logs training activity to MLflow.
"""

from typing import Dict, Any, Tuple, Callable, List, Optional, IO
import sys

from spacy import util
from spacy import Language
from spacy import load
from spacy.training.loggers import console_logger


# entry point: spacy.MLflowLogger.v1
def mlflow_logger_v1(
    run_id: Optional[str] = None,
    experiment_id: Optional[str] = None,
    run_name: Optional[str] = None,
    nested: bool = False,
    tags: Optional[Dict[str, Any]] = None,
    remove_config_values: List[str] = [],
):
    try:
        import mlflow

        # test that these are available
        from mlflow import start_run, log_metric, log_metrics, log_artifact, end_run  # noqa: F401
    except ImportError:
        raise ImportError(
            "The 'mlflow' library could not be found - did you install it? "
            "Alternatively, specify the 'ConsoleLogger' in the "
            "'training.logger' config section, instead of the 'MLflowLogger'."
        )

    console = console_logger(progress_bar=False)

    def setup_logger(
        nlp: Language, stdout: IO = sys.stdout, stderr: IO = sys.stderr
    ) -> Tuple[Callable[[Dict[str, Any]], None], Callable[[], None]]:
        config = nlp.config.interpolate()
        config_dot = util.dict_to_dot(config)
        for field in remove_config_values:
            del config_dot[field]
        config = util.dot_to_dict(config_dot)
        mlflow.start_run(
            run_id=run_id,
            experiment_id=experiment_id,
            run_name=run_name,
            nested=nested,
            tags=tags,
        )

        config_dot_items = list(config_dot.items())
        config_dot_batches = [
            config_dot_items[i : i + 100] for i in range(0, len(config_dot_items), 100)
        ]
        for batch in config_dot_batches:
            mlflow.log_params({k.replace("@", ""): v for k, v in batch})

        console_log_step, console_finalize = console(nlp, stdout, stderr)

        def log_step(info: Optional[Dict[str, Any]]):
            console_log_step(info)
            if info is not None:
                score = info["score"]
                other_scores = info["other_scores"]
                losses = info["losses"]
                output_path = info.get("output_path", None)
                if score is not None:
                    mlflow.log_metric("score", score)
                if losses:
                    mlflow.log_metrics({f"loss_{k}": v for k, v in losses.items()})
                if isinstance(other_scores, dict):
                    mlflow.log_metrics(
                        {
                            k: v
                            for k, v in util.dict_to_dot(other_scores).items()
                            if isinstance(v, float) or isinstance(v, int)
                        }
                    )
                if output_path and score == max(info["checkpoints"])[0]:
                    nlp = load(output_path)
                    mlflow.spacy.log_model(nlp, "best")

        def finalize() -> None:
            console_finalize()
            mlflow.end_run()

        return log_step, finalize

    return setup_logger
