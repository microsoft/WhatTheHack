import os
from typing import Dict, Any, Tuple, Callable, List, Optional, IO
import sys

from spacy import Language, util
from spacy.training.loggers import console_logger


# entry point: spacy.ClearMLLogger.v1
def clearml_logger_v1(
    project_name: str,
    task_name: str,
    remove_config_values: List[str] = [],
    model_log_interval: Optional[int] = None,
    log_dataset_dir: Optional[str] = None,
    log_best_dir: Optional[str] = None,
    log_latest_dir: Optional[str] = None,
):
    try:
        # test that these are available
        from clearml import Task, Dataset, OutputModel  # noqa: F401
    except ImportError as exc:
        raise ImportError(
            "The 'clearml' library could not be found - did you install it? "
            "Alternatively, specify the 'ConsoleLogger' in the "
            "'training.logger' config section, instead of the 'ClearMLLogger'."
        ) from exc

    console = console_logger(progress_bar=False)

    def setup_logger(
        nlp: Language, stdout: IO = sys.stdout, stderr: IO = sys.stderr
    ) -> Tuple[Callable[[Dict[str, Any]], None], Callable[[], None]]:
        config = nlp.config.interpolate()
        config_dot = util.dict_to_dot(config)
        for field in remove_config_values:
            del config_dot[field]
        config = util.dot_to_dict(config_dot)
        task = Task.init(
            project_name=project_name,
            task_name=task_name,
            output_uri=True,
        )
        for config_section, subconfig_or_value in config.items():
            task.connect(subconfig_or_value, name=config_section)

        # Connect 2 models to the task, we will periodically update their weights later on
        if log_best_dir:
            best_model = OutputModel(task=task, framework="spaCy", name="Best Model")
        if log_latest_dir:
            last_model = OutputModel(task=task, framework="spaCy", name="Last Model")

        console_log_step, console_finalize = console(nlp, stdout, stderr)

        if log_dataset_dir:
            dataset = Dataset.create(
                dataset_project=project_name,
                dataset_name=os.path.basename(log_dataset_dir),
            )
            dataset.add_files(log_dataset_dir)
            dataset.finalize(auto_upload=True)
            task.set_user_properties(
                {
                    "name": "Created Dataset ID",
                    "value": dataset.id,
                }
            )

        def log_step(info: Optional[Dict[str, Any]]):
            console_log_step(info)
            if info is not None:
                score = info.get("score")
                other_scores = info.get("other_scores")
                losses = info.get("losses")
                if score:
                    task.get_logger().report_scalar(
                        "Score", "Score", iteration=info["step"], value=score
                    )
                if losses:
                    for metric, metric_value in losses.items():
                        task.get_logger().report_scalar(
                            title=f"loss_{metric}",
                            series=f"loss_{metric}",
                            iteration=info["step"],
                            value=metric_value,
                        )
                if isinstance(other_scores, dict):
                    # other_scores is usually a nested dict, so group they by the first key and flatten the rest
                    # combine flattened submetrics on the same ClearML graph when they have the same first key
                    for metric, metric_value in other_scores.items():
                        if isinstance(metric_value, dict):
                            sub_metrics_dict = util.dict_to_dot(metric_value)
                            for (
                                sub_metric,
                                sub_metric_value,
                            ) in sub_metrics_dict.items():
                                # Scalars with the same title get plotted on the same graph as multiple traces
                                # This saves a lot of space in the UI
                                task.get_logger().report_scalar(
                                    title=metric,
                                    series=sub_metric,
                                    iteration=info["step"],
                                    value=sub_metric_value,
                                )
                        elif isinstance(metric_value, (float, int)):
                            task.get_logger().report_scalar(
                                metric,
                                metric,
                                iteration=info["step"],
                                value=metric_value,
                            )
                if model_log_interval and info.get("output_path"):
                    if info["step"] % model_log_interval == 0 and info["step"] != 0:
                        if log_latest_dir:
                            last_model.update_weights_package(
                                weights_path=log_latest_dir,
                                auto_delete_file=False,
                                target_filename="last_model",
                            )
                        if (
                            log_best_dir
                            and info["score"] == max(info["checkpoints"])[0]
                        ):
                            best_model.update_weights_package(
                                weights_path=log_best_dir,
                                auto_delete_file=False,
                                target_filename="best_model",
                            )

        def finalize() -> None:
            console_finalize()
            task.flush(wait_for_uploads=True)
            task.close()

        return log_step, finalize

    return setup_logger
