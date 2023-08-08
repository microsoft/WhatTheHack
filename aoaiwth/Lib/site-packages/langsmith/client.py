from __future__ import annotations

import json
import logging
import os
import socket
import weakref
from collections import defaultdict
from datetime import datetime
from functools import lru_cache
from io import BytesIO
from typing import (
    TYPE_CHECKING,
    Any,
    Callable,
    DefaultDict,
    Dict,
    Iterator,
    List,
    Mapping,
    Optional,
    Sequence,
    Tuple,
    Union,
    cast,
)
from urllib.parse import urlsplit
from uuid import UUID, uuid4

from requests import ConnectionError, HTTPError, Response, Session
from requests.adapters import HTTPAdapter
from urllib3.util import Retry

from langsmith.evaluation.evaluator import RunEvaluator
from langsmith.schemas import (
    APIFeedbackSource,
    Dataset,
    DatasetCreate,
    DataType,
    Example,
    ExampleCreate,
    ExampleUpdate,
    Feedback,
    FeedbackCreate,
    FeedbackSourceBase,
    FeedbackSourceType,
    ModelFeedbackSource,
    Run,
    RunBase,
    TracerSession,
    TracerSessionResult,
)
from langsmith.utils import (
    LangSmithAPIError,
    LangSmithConnectionError,
    LangSmithError,
    LangSmithUserError,
    get_enum_value,
    get_llm_generation_from_outputs,
    get_message_generation_from_outputs,
    get_messages_from_inputs,
    get_prompt_from_inputs,
    get_runtime_environment,
    raise_for_status_with_text,
    xor_args,
)

if TYPE_CHECKING:
    import pandas as pd

logger = logging.getLogger(__name__)


def _is_localhost(url: str) -> bool:
    """Check if the URL is localhost.

    Parameters
    ----------
    url : str
        The URL to check.

    Returns
    -------
    bool
        True if the URL is localhost, False otherwise.
    """
    try:
        netloc = urlsplit(url).netloc.split(":")[0]
        ip = socket.gethostbyname(netloc)
        return ip == "127.0.0.1" or ip.startswith("0.0.0.0") or ip.startswith("::")
    except socket.gaierror:
        return False


ID_TYPE = Union[UUID, str]


def _default_retry_config() -> Retry:
    """Get the default retry configuration.

    Returns
    -------
    Retry
        The default retry configuration.
    """
    return Retry(
        total=3,
        allowed_methods=None,  # Retry on all methods
        status_forcelist=[502, 503, 504, 408, 425, 429],
        backoff_factor=0.5,
        # Sadly urllib3 1.x doesn't support backoff_jitter
        raise_on_redirect=False,
        raise_on_status=False,
    )


def _serialize_json(obj: Any) -> str:
    """Serialize an object to JSON.

    Parameters
    ----------
    obj : Any
        The object to serialize.

    Returns
    -------
    str
        The serialized JSON string.

    Raises
    ------
    TypeError
        If the object type is not serializable.
    """
    if isinstance(obj, datetime):
        return obj.isoformat()
    else:
        return str(obj)


def close_session(session: Session) -> None:
    """Close the session.

    Parameters
    ----------
    session : Session
        The session to close.
    """
    logger.debug("Closing Client.session")
    session.close()


def _validate_api_key_if_hosted(api_url: str, api_key: Optional[str]) -> None:
    """Verify API key is provided if url not localhost.

    Parameters
    ----------
    api_url : str
        The API URL.
    api_key : str or None
        The API key.

    Raises
    ------
    LangSmithUserError
        If the API key is not provided when using the hosted service.
    """
    if not _is_localhost(api_url):
        if not api_key:
            raise LangSmithUserError(
                "API key must be provided when using hosted LangSmith API"
            )


def _get_api_key(api_key: Optional[str]) -> Optional[str]:
    api_key = api_key if api_key is not None else os.getenv("LANGCHAIN_API_KEY")
    if api_key is None or not api_key.strip():
        return None
    return api_key.strip().strip('"').strip("'")


def _get_api_url(api_url: Optional[str], api_key: Optional[str]) -> str:
    _api_url = (
        api_url
        if api_url is not None
        else os.getenv(
            "LANGCHAIN_ENDPOINT",
            "https://api.smith.langchain.com" if api_key else "http://localhost:1984",
        )
    )
    if not _api_url.strip():
        raise LangSmithUserError("LangSmith API URL cannot be empty")
    return _api_url.strip().strip('"').strip("'").rstrip("/")


class Client:
    """Client for interacting with the LangSmith API."""

    __slots__ = [
        "__weakref__",
        "api_url",
        "api_key",
        "retry_config",
        "timeout_ms",
        "session",
        "_get_data_type_cached",
    ]

    def __init__(
        self,
        api_url: Optional[str] = None,
        *,
        api_key: Optional[str] = None,
        retry_config: Optional[Retry] = None,
        timeout_ms: Optional[int] = None,
    ) -> None:
        """Initialize a Client instance.

        Parameters
        ----------
        api_url : str or None, default=None
            URL for the LangSmith API. Defaults to the LANGCHAIN_ENDPOINT
            environment variable or http://localhost:1984 if not set.
        api_key : str or None, default=None
            API key for the LangSmith API. Defaults to the LANGCHAIN_API_KEY
            environment variable.
        retry_config : Retry or None, default=None
            Retry configuration for the HTTPAdapter.
        timeout_ms : int or None, default=None
            Timeout in milliseconds for the HTTPAdapter.

        Raises
        ------
        LangSmithUserError
            If the API key is not provided when using the hosted service.
        """
        self.api_key = _get_api_key(api_key)
        self.api_url = _get_api_url(api_url, self.api_key)
        _validate_api_key_if_hosted(self.api_url, self.api_key)
        self.retry_config = retry_config or _default_retry_config()
        self.timeout_ms = timeout_ms or 7000
        # Create a session and register a finalizer to close it
        self.session = Session()
        weakref.finalize(self, close_session, self.session)

        # Mount the HTTPAdapter with the retry configuration
        adapter = HTTPAdapter(max_retries=self.retry_config)
        self.session.mount("http://", adapter)
        self.session.mount("https://", adapter)
        self._get_data_type_cached = lru_cache(maxsize=10)(self._get_data_type)

    def _repr_html_(self) -> str:
        """Return an HTML representation of the instance with a link to the URL.

        Returns
        -------
        str
            The HTML representation of the instance.
        """
        link = self._host_url
        return f'<a href="{link}", target="_blank" rel="noopener">LangSmith Client</a>'

    def __repr__(self) -> str:
        """Return a string representation of the instance with a link to the URL.

        Returns
        -------
        str
            The string representation of the instance.
        """
        return f"Client (API URL: {self.api_url})"

    @property
    def _host_url(self) -> str:
        """The web host url."""
        if _is_localhost(self.api_url):
            link = "http://localhost"
        elif "dev" in self.api_url.split(".", maxsplit=1)[0]:
            link = "https://dev.smith.langchain.com"
        else:
            link = "https://smith.langchain.com"
        return link

    @property
    def _headers(self) -> Dict[str, str]:
        """Get the headers for the API request.

        Returns
        -------
        Dict[str, str]
            The headers for the API request.
        """
        headers = {}
        if self.api_key:
            headers["x-api-key"] = self.api_key
        return headers

    def request_with_retries(
        self,
        request_method: str,
        url: str,
        request_kwargs: Mapping,
    ) -> Response:
        """Send a request with retries.

        Parameters
        ----------
        request_method : str
            The HTTP request method.
        url : str
            The URL to send the request to.
        request_kwargs : Mapping
            Additional request parameters.

        Returns
        -------
        Response
            The response object.

        Raises
        ------
        LangSmithAPIError
            If a server error occurs.
        LangSmithUserError
            If the request fails.
        LangSmithConnectionError
            If a connection error occurs.
        LangSmithError
            If the request fails.
        """
        try:
            response = self.session.request(
                request_method, url, stream=False, **request_kwargs
            )
            raise_for_status_with_text(response)
            return response
        except HTTPError as e:
            if response is not None and response.status_code == 500:
                raise LangSmithAPIError(
                    f"Server error caused failure to {request_method} {url} in"
                    f" LangSmith API. {e}"
                )
            else:
                raise LangSmithUserError(
                    f"Failed to {request_method} {url} in LangSmith API. {e}"
                )
        except ConnectionError as e:
            raise LangSmithConnectionError(
                f"Connection error caused failure to {request_method} {url}"
                "  in LangSmith API. Please confirm your LANGCHAIN_ENDPOINT."
            ) from e
        except Exception as e:
            raise LangSmithError(
                f"Failed to {request_method} {url} in LangSmith API. {e}"
            ) from e

    def _get_with_retries(
        self, path: str, params: Optional[Dict[str, Any]] = None
    ) -> Response:
        """Send a GET request with retries.

        Parameters
        ----------
        path : str
            The path of the request URL.
        params : Dict[str, Any] or None, default=None
            The query parameters.

        Returns
        -------
        Response
            The response object.

        Raises
        ------
        LangSmithAPIError
            If a server error occurs.
        LangSmithUserError
            If the request fails.
        LangSmithConnectionError
            If a connection error occurs.
        LangSmithError
            If the request fails.
        """
        return self.request_with_retries(
            "get",
            f"{self.api_url}{path}",
            request_kwargs={
                "params": params,
                "headers": self._headers,
                "timeout": self.timeout_ms / 1000,
            },
        )

    def _get_paginated_list(
        self, path: str, *, params: Optional[dict] = None
    ) -> Iterator[dict]:
        """Get a paginated list of items.

        Parameters
        ----------
        path : str
            The path of the request URL.
        params : dict or None, default=None
            The query parameters.

        Yields
        ------
        dict
            The items in the paginated list.
        """
        params_ = params.copy() if params else {}
        offset = params_.get("offset", 0)
        params_["limit"] = params_.get("limit", 100)
        while True:
            params_["offset"] = offset
            response = self._get_with_retries(path, params=params_)
            items = response.json()
            if not items:
                break
            yield from items
            if len(items) < params_["limit"]:
                # offset and limit isn't respected if we're
                # querying for specific values
                break
            offset += len(items)

    def upload_dataframe(
        self,
        df: pd.DataFrame,
        name: str,
        input_keys: Sequence[str],
        output_keys: Sequence[str],
        *,
        description: Optional[str] = None,
        data_type: Optional[DataType] = DataType.kv,
    ) -> Dataset:
        """Upload a dataframe as individual examples to the LangSmith API.

        Parameters
        ----------
        df : pd.DataFrame
            The dataframe to upload.
        name : str
            The name of the dataset.
        input_keys : Sequence[str]
            The input keys.
        output_keys : Sequence[str]
            The output keys.
        description : str or None, default=None
            The description of the dataset.
        data_type : DataType or None, default=DataType.kv
            The data type of the dataset.

        Returns
        -------
        Dataset
            The uploaded dataset.

        Raises
        ------
        ValueError
            If the csv_file is not a string or tuple.
        """
        csv_file = BytesIO()
        df.to_csv(csv_file, index=False)
        csv_file.seek(0)
        return self.upload_csv(
            ("data.csv", csv_file),
            input_keys=input_keys,
            output_keys=output_keys,
            description=description,
            name=name,
            data_type=data_type,
        )

    def upload_csv(
        self,
        csv_file: Union[str, Tuple[str, BytesIO]],
        input_keys: Sequence[str],
        output_keys: Sequence[str],
        *,
        name: Optional[str] = None,
        description: Optional[str] = None,
        data_type: Optional[DataType] = DataType.kv,
    ) -> Dataset:
        """Upload a CSV file to the LangSmith API.

        Parameters
        ----------
        csv_file : str or Tuple[str, BytesIO]
            The CSV file to upload. If a string, it should be the path
            If a tuple, it should be a tuple containing the filename
            and a BytesIO object.
        input_keys : Sequence[str]
            The input keys.
        output_keys : Sequence[str]
            The output keys.
        name : str or None, default=None
            The name of the dataset.
        description : str or None, default=None
            The description of the dataset.
        data_type : DataType or None, default=DataType.kv
            The data type of the dataset.

        Returns
        -------
        Dataset
            The uploaded dataset.

        Raises
        ------
        ValueError
            If the csv_file is not a string or tuple.
        """
        data = {
            "input_keys": input_keys,
            "output_keys": output_keys,
        }
        if name:
            data["name"] = name
        if description:
            data["description"] = description
        if data_type:
            data["data_type"] = get_enum_value(data_type)
        if isinstance(csv_file, str):
            with open(csv_file, "rb") as f:
                file_ = {"file": f}
                response = self.session.post(
                    self.api_url + "/datasets/upload",
                    headers=self._headers,
                    data=data,
                    files=file_,
                )
        elif isinstance(csv_file, tuple):
            response = self.session.post(
                self.api_url + "/datasets/upload",
                headers=self._headers,
                data=data,
                files={"file": csv_file},
            )
        else:
            raise ValueError("csv_file must be a string or tuple")
        raise_for_status_with_text(response)
        result = response.json()
        # TODO: Make this more robust server-side
        if "detail" in result and "already exists" in result["detail"]:
            file_name = csv_file if isinstance(csv_file, str) else csv_file[0]
            file_name = file_name.split("/")[-1]
            raise ValueError(f"Dataset {file_name} already exists")
        return Dataset(**result)

    def create_run(
        self,
        name: str,
        inputs: Dict[str, Any],
        run_type: str,
        *,
        execution_order: Optional[int] = None,
        **kwargs: Any,
    ) -> None:
        """Persist a run to the LangSmith API.

        Parameters
        ----------
        name : str
            The name of the run.
        inputs : Dict[str, Any]
            The input values for the run.
        run_type : str
            The type of the run, such as  such as tool, chain, llm, retriever,
            embedding, prompt, or parser.
        execution_order : int or None, default=None
            The execution order of the run.
        **kwargs : Any
            Additional keyword arguments.

        Raises
        ------
        LangSmithUserError
            If the API key is not provided when using the hosted service.
        """
        project_name = kwargs.pop(
            "project_name",
            kwargs.pop(
                "session_name",
                os.environ.get(
                    # TODO: Deprecate LANGCHAIN_SESSION
                    "LANGCHAIN_PROJECT",
                    os.environ.get("LANGCHAIN_SESSION", "default"),
                ),
            ),
        )
        run_create = {
            **kwargs,
            "session_name": project_name,
            "name": name,
            "inputs": inputs,
            "run_type": run_type,
            "execution_order": execution_order if execution_order is not None else 1,
        }
        run_extra = cast(dict, run_create.setdefault("extra", {}))
        runtime = run_extra.setdefault("runtime", {})
        runtime_env = get_runtime_environment()
        run_extra["runtime"] = {**runtime_env, **runtime}
        headers = {**self._headers, "Accept": "application/json"}
        self.request_with_retries(
            "post",
            f"{self.api_url}/runs",
            request_kwargs={
                "data": json.dumps(run_create, default=_serialize_json),
                "headers": headers,
                "timeout": self.timeout_ms / 1000,
            },
        )

    def update_run(
        self,
        run_id: ID_TYPE,
        **kwargs: Any,
    ) -> None:
        """Update a run in the LangSmith API.

        Parameters
        ----------
        run_id : str or UUID
            The ID of the run to update.
        **kwargs : Any
            Additional keyword arguments.
        """
        headers = {**self._headers, "Accept": "application/json"}
        self.request_with_retries(
            "patch",
            f"{self.api_url}/runs/{run_id}",
            request_kwargs={
                "data": json.dumps(kwargs, default=_serialize_json),
                "headers": headers,
                "timeout": self.timeout_ms / 1000,
            },
        )

    def _load_child_runs(self, run: Run) -> Run:
        """Load child runs for a given run.

        Parameters
        ----------
        run : Run
            The run to load child runs for.

        Returns
        -------
        Run
            The run with loaded child runs.

        Raises
        ------
        LangSmithError
            If a child run has no parent.
        """
        child_runs = self.list_runs(id=run.child_run_ids)
        treemap: DefaultDict[UUID, List[Run]] = defaultdict(list)
        runs: Dict[UUID, Run] = {}
        for child_run in sorted(child_runs, key=lambda r: r.execution_order):
            if child_run.parent_run_id is None:
                raise LangSmithError(f"Child run {child_run.id} has no parent")
            treemap[child_run.parent_run_id].append(child_run)
            runs[child_run.id] = child_run
        run.child_runs = treemap.pop(run.id, [])
        for run_id, children in treemap.items():
            runs[run_id].child_runs = children
        return run

    def read_run(self, run_id: ID_TYPE, load_child_runs: bool = False) -> Run:
        """Read a run from the LangSmith API.

        Parameters
        ----------
        run_id : str or UUID
            The ID of the run to read.
        load_child_runs : bool, default=False
            Whether to load nested child runs.

        Returns
        -------
        Run
            The run.
        """
        response = self._get_with_retries(f"/runs/{run_id}")
        run = Run(**response.json(), _host_url=self._host_url)
        if load_child_runs and run.child_run_ids:
            run = self._load_child_runs(run)
        return run

    def list_runs(
        self,
        *,
        project_id: Optional[ID_TYPE] = None,
        project_name: Optional[str] = None,
        run_type: Optional[str] = None,
        dataset_name: Optional[str] = None,
        dataset_id: Optional[ID_TYPE] = None,
        reference_example_id: Optional[ID_TYPE] = None,
        query: Optional[str] = None,
        filter: Optional[str] = None,
        execution_order: Optional[int] = None,
        parent_run_id: Optional[ID_TYPE] = None,
        start_time: Optional[datetime] = None,
        end_time: Optional[datetime] = None,
        error: Optional[bool] = None,
        run_ids: Optional[List[ID_TYPE]] = None,
        limit: Optional[int] = None,
        offset: Optional[int] = None,
        order_by: Optional[Sequence[str]] = None,
        **kwargs: Any,
    ) -> Iterator[Run]:
        """List runs from the LangSmith API.

        Parameters
        ----------
        project_id : UUID or None, default=None
            The ID of the project to filter by.
        project_name : str or None, default=None
            The name of the project to filter by.
        run_type : str or None, default=None
            The type of the runs to filter by.
        dataset_name : str or None, default=None
            The name of the dataset to filter by.
        dataset_id : UUID or None, default=None
            The ID of the dataset to filter by.
        reference_example_id : UUID or None, default=None
            The ID of the reference example to filter by.
        query : str or None, default=None
            The query string to filter by.
        filter : str or None, default=None
            The filter string to filter by.
        execution_order : int or None, default=None
            The execution order to filter by.
        parent_run_id : UUID or None, default=None
            The ID of the parent run to filter by.
        start_time : datetime or None, default=None
            The start time to filter by.
        end_time : datetime or None, default=None
            The end time to filter by.
        error : bool or None, default=None
            Whether to filter by error status.
        run_ids : List[str or UUID] or None, default=None
            The IDs of the runs to filter by.
        limit : int or None, default=None
            The maximum number of runs to return.
        offset : int or None, default=None
            The number of runs to skip.
        order_by : Sequence[str] or None, default=None
            The fields to order the runs by.
        **kwargs : Any
            Additional keyword arguments.

        Yields
        ------
        Run
            The runs.
        """
        if project_name is not None:
            if project_id is not None:
                raise ValueError("Only one of project_id or project_name may be given")
            project_id = self.read_project(project_name=project_name).id
        if dataset_name is not None:
            if dataset_id is not None:
                raise ValueError("Only one of dataset_id or dataset_name may be given")
            dataset_id = self.read_dataset(dataset_name=dataset_name).id
        query_params: Dict[str, Any] = {
            "session": project_id,
            "run_type": run_type,
            **kwargs,
        }
        if reference_example_id is not None:
            query_params["reference_example"] = reference_example_id
        if dataset_id is not None:
            query_params["dataset"] = dataset_id
        if query is not None:
            query_params["query"] = query
        if filter is not None:
            query_params["filter"] = filter
        if execution_order is not None:
            query_params["execution_order"] = execution_order
        if parent_run_id is not None:
            query_params["parent_run"] = parent_run_id
        if start_time is not None:
            query_params["start_time"] = start_time.isoformat()
        if end_time is not None:
            query_params["end_time"] = end_time.isoformat()
        if error is not None:
            query_params["error"] = error
        if run_ids is not None:
            query_params["id"] = run_ids
        if limit is not None:
            query_params["limit"] = limit
        if offset is not None:
            query_params["offset"] = offset
        if order_by is not None:
            query_params["order"] = order_by
        yield from (
            Run(**run, _host_url=self._host_url)
            for run in self._get_paginated_list("/runs", params=query_params)
        )

    def delete_run(self, run_id: ID_TYPE) -> None:
        """Delete a run from the LangSmith API.

        Parameters
        ----------
        run_id : str or UUID
            The ID of the run to delete.
        """
        response = self.session.delete(
            f"{self.api_url}/runs/{run_id}",
            headers=self._headers,
        )
        raise_for_status_with_text(response)

    def share_run(self, run_id: ID_TYPE, *, share_id: Optional[ID_TYPE] = None) -> str:
        """Get a share link for a run."""
        data = {
            "run_id": str(run_id),
            "share_token": share_id or str(uuid4()),
        }
        response = self.session.put(
            f"{self.api_url}/runs/{run_id}/share",
            headers=self._headers,
            json=data,
        )
        raise_for_status_with_text(response)
        share_token = response.json()["share_token"]
        return f"{self._host_url}/public/{share_token}/r"

    def unshare_run(self, run_id: ID_TYPE) -> None:
        """Delete share link for a run."""
        response = self.session.delete(
            f"{self.api_url}/runs/{run_id}/share",
            headers=self._headers,
        )
        raise_for_status_with_text(response)

    def read_run_shared_link(self, run_id: ID_TYPE) -> Optional[str]:
        response = self.session.get(
            f"{self.api_url}/runs/{run_id}/share",
            headers=self._headers,
        )
        raise_for_status_with_text(response)
        result = response.json()
        if result is None or "share_token" not in result:
            return None
        return f"{self._host_url}/public/{result['share_token']}/r"

    def run_is_shared(self, run_id: ID_TYPE) -> bool:
        """Get share state for a run."""
        link = self.read_run_shared_link(run_id)
        return link is not None

    def create_project(
        self,
        project_name: str,
        *,
        project_extra: Optional[dict] = None,
        upsert: bool = False,
    ) -> TracerSession:
        """Create a project on the LangSmith API.

        Parameters
        ----------
        project_name : str
            The name of the project.
        project_extra : dict or None, default=None
            Additional project information.
        upsert : bool, default=False
            Whether to update the project if it already exists.

        Returns
        -------
        TracerSession
            The created project.
        """
        endpoint = f"{self.api_url}/sessions"
        body = {
            "name": project_name,
            "extra": project_extra,
        }
        params = {}
        if upsert:
            params["upsert"] = True
        response = self.session.post(
            endpoint,
            headers=self._headers,
            json=body,
        )
        raise_for_status_with_text(response)
        return TracerSession(**response.json())

    @xor_args(("project_id", "project_name"))
    def read_project(
        self, *, project_id: Optional[str] = None, project_name: Optional[str] = None
    ) -> TracerSessionResult:
        """Read a project from the LangSmith API.

        Parameters
        ----------
        project_id : str or None, default=None
            The ID of the project to read.
        project_name : str or None, default=None
            The name of the project to read.
                Note: Only one of project_id or project_name may be given.

        Returns
        -------
        TracerSessionResult
            The project.
        """
        path = "/sessions"
        params: Dict[str, Any] = {"limit": 1}
        if project_id is not None:
            path += f"/{project_id}"
        elif project_name is not None:
            params["name"] = project_name
        else:
            raise ValueError("Must provide project_name or project_id")
        response = self._get_with_retries(path, params=params)
        result = response.json()
        if isinstance(result, list):
            if len(result) == 0:
                raise LangSmithError(f"Project {project_name} not found")
            return TracerSessionResult(**result[0])
        return TracerSessionResult(**response.json())

    def list_projects(self) -> Iterator[TracerSession]:
        """List projects from the LangSmith API.

        Yields
        ------
        TracerSession
            The projects.
        """
        yield from (
            TracerSession(**project)
            for project in self._get_paginated_list("/sessions")
        )

    @xor_args(("project_name", "project_id"))
    def delete_project(
        self, *, project_name: Optional[str] = None, project_id: Optional[str] = None
    ) -> None:
        """Delete a project from the LangSmith API.

        Parameters
        ----------
        project_name : str or None, default=None
            The name of the project to delete.
        project_id : str or None, default=None
            The ID of the project to delete.
        """
        if project_name is not None:
            project_id = str(self.read_project(project_name=project_name).id)
        elif project_id is None:
            raise ValueError("Must provide project_name or project_id")
        response = self.session.delete(
            self.api_url + f"/sessions/{project_id}",
            headers=self._headers,
        )
        raise_for_status_with_text(response)

    def create_dataset(
        self,
        dataset_name: str,
        *,
        description: Optional[str] = None,
        data_type: DataType = DataType.kv,
    ) -> Dataset:
        """Create a dataset in the LangSmith API.

        Parameters
        ----------
        dataset_name : str
            The name of the dataset.
        description : str or None, default=None
            The description of the dataset.
        data_type : DataType or None, default=DataType.kv
            The data type of the dataset.

        Returns
        -------
        Dataset
            The created dataset.
        """
        dataset = DatasetCreate(
            name=dataset_name,
            description=description,
            data_type=data_type,
        )
        response = self.session.post(
            self.api_url + "/datasets",
            headers=self._headers,
            data=dataset.json(),
        )
        raise_for_status_with_text(response)
        return Dataset(**response.json())

    @xor_args(("dataset_name", "dataset_id"))
    def read_dataset(
        self,
        *,
        dataset_name: Optional[str] = None,
        dataset_id: Optional[ID_TYPE] = None,
    ) -> Dataset:
        """Read a dataset from the LangSmith API.

        Parameters
        ----------
        dataset_name : str or None, default=None
            The name of the dataset to read.
        dataset_id : UUID or None, default=None
            The ID of the dataset to read.

        Returns
        -------
        Dataset
            The dataset.
        """
        path = "/datasets"
        params: Dict[str, Any] = {"limit": 1}
        if dataset_id is not None:
            path += f"/{dataset_id}"
        elif dataset_name is not None:
            params["name"] = dataset_name
        else:
            raise ValueError("Must provide dataset_name or dataset_id")
        response = self._get_with_retries(
            path,
            params=params,
        )
        result = response.json()
        if isinstance(result, list):
            if len(result) == 0:
                raise LangSmithError(f"Dataset {dataset_name} not found")
            return Dataset(**result[0])
        return Dataset(**result)

    def list_datasets(self) -> Iterator[Dataset]:
        """List the datasets on the LangSmith API.

        Yields
        ------
        Dataset
            The datasets.
        """
        yield from (
            Dataset(**dataset) for dataset in self._get_paginated_list("/datasets")
        )

    @xor_args(("dataset_id", "dataset_name"))
    def delete_dataset(
        self,
        *,
        dataset_id: Optional[ID_TYPE] = None,
        dataset_name: Optional[str] = None,
    ) -> None:
        """Delete a dataset from the LangSmith API.

        Parameters
        ----------
        dataset_id : UUID or None, default=None
            The ID of the dataset to delete.
        dataset_name : str or None, default=None
            The name of the dataset to delete.
        """
        if dataset_name is not None:
            dataset_id = self.read_dataset(dataset_name=dataset_name).id
        if dataset_id is None:
            raise ValueError("Must provide either dataset name or ID")
        response = self.session.delete(
            f"{self.api_url}/datasets/{dataset_id}",
            headers=self._headers,
        )
        raise_for_status_with_text(response)

    def _get_data_type(self, dataset_id: ID_TYPE) -> DataType:
        dataset = self.read_dataset(dataset_id=dataset_id)
        return dataset.data_type

    @xor_args(("dataset_id", "dataset_name"))
    def create_llm_example(
        self,
        prompt: str,
        generation: Optional[str] = None,
        dataset_id: Optional[ID_TYPE] = None,
        dataset_name: Optional[str] = None,
        created_at: Optional[datetime] = None,
    ) -> Example:
        """Add an example (row) to an LLM-type dataset."""
        return self.create_example(
            inputs={"input": prompt},
            outputs={"output": generation},
            dataset_id=dataset_id,
            dataset_name=dataset_name,
            created_at=created_at,
        )

    @xor_args(("dataset_id", "dataset_name"))
    def create_chat_example(
        self,
        messages: List[Mapping[str, Any]],
        generations: Optional[Mapping[str, Any]] = None,
        dataset_id: Optional[ID_TYPE] = None,
        dataset_name: Optional[str] = None,
        created_at: Optional[datetime] = None,
    ) -> Example:
        """Add an example (row) to a Chat-type dataset."""
        return self.create_example(
            inputs={"input": messages},
            outputs={"output": generations},
            dataset_id=dataset_id,
            dataset_name=dataset_name,
            created_at=created_at,
        )

    def create_example_from_run(
        self,
        run: Run,
        dataset_id: Optional[ID_TYPE] = None,
        dataset_name: Optional[str] = None,
        created_at: Optional[datetime] = None,
    ) -> Example:
        """Add an example (row) to an LLM-type dataset."""
        if dataset_id is None:
            dataset_id = self.read_dataset(dataset_name=dataset_name).id
            dataset_name = None  # Nested call expects only 1 defined
        dataset_type = self._get_data_type_cached(dataset_id)
        if dataset_type == DataType.llm:
            if run.run_type != "llm":
                raise ValueError(
                    f"Run type {run.run_type} is not supported"
                    " for dataset of type 'LLM'"
                )
            try:
                prompt = get_prompt_from_inputs(run.inputs)
            except ValueError:
                raise ValueError(
                    "Error converting LLM run inputs to prompt for run"
                    f" {run.id} with inputs {run.inputs}"
                )
            inputs: Dict[str, Any] = {"input": prompt}
            if not run.outputs:
                outputs: Optional[Dict[str, Any]] = None
            else:
                try:
                    generation = get_llm_generation_from_outputs(run.outputs)
                except ValueError:
                    raise ValueError(
                        "Error converting LLM run outputs to generation for run"
                        f" {run.id} with outputs {run.outputs}"
                    )
                outputs = {"output": generation}
        elif dataset_type == DataType.chat:
            if run.run_type != "llm":
                raise ValueError(
                    f"Run type {run.run_type} is not supported"
                    " for dataset of type 'chat'"
                )
            try:
                inputs = {"input": get_messages_from_inputs(run.inputs)}
            except ValueError:
                raise ValueError(
                    "Error converting LLM run inputs to chat messages for run"
                    f" {run.id} with inputs {run.inputs}"
                )
            if not run.outputs:
                outputs = None
            else:
                try:
                    outputs = {
                        "output": get_message_generation_from_outputs(run.outputs)
                    }
                except ValueError:
                    raise ValueError(
                        "Error converting LLM run outputs to chat generations"
                        f" for run {run.id} with outputs {run.outputs}"
                    )
        elif dataset_type == DataType.kv:
            # Anything goes
            inputs = run.inputs
            outputs = run.outputs

        else:
            raise ValueError(f"Dataset type {dataset_type} not recognized.")
        return self.create_example(
            inputs=inputs,
            outputs=outputs,
            dataset_id=dataset_id,
            dataset_name=dataset_name,
            created_at=created_at,
        )

    @xor_args(("dataset_id", "dataset_name"))
    def create_example(
        self,
        inputs: Mapping[str, Any],
        dataset_id: Optional[ID_TYPE] = None,
        dataset_name: Optional[str] = None,
        created_at: Optional[datetime] = None,
        outputs: Optional[Mapping[str, Any]] = None,
    ) -> Example:
        """Create a dataset example in the LangSmith API.

        Parameters
        ----------
        inputs : Mapping[str, Any]
            The input values for the example.
        dataset_id : UUID or None, default=None
            The ID of the dataset to create the example in.
        dataset_name : str or None, default=None
            The name of the dataset to create the example in.
        created_at : datetime or None, default=None
            The creation timestamp of the example.
        outputs : Mapping[str, Any] or None, default=None
            The output values for the example.

        Returns
        -------
        Example
            The created example.
        """
        if dataset_id is None:
            dataset_id = self.read_dataset(dataset_name=dataset_name).id

        data = {
            "inputs": inputs,
            "outputs": outputs,
            "dataset_id": dataset_id,
        }
        if created_at:
            data["created_at"] = created_at.isoformat()
        example = ExampleCreate(**data)
        response = self.session.post(
            f"{self.api_url}/examples", headers=self._headers, data=example.json()
        )
        raise_for_status_with_text(response)
        result = response.json()
        return Example(**result)

    def read_example(self, example_id: ID_TYPE) -> Example:
        """Read an example from the LangSmith API.

        Parameters
        ----------
        example_id : str or UUID
            The ID of the example to read.

        Returns
        -------
        Example
            The example.
        """
        response = self._get_with_retries(f"/examples/{example_id}")
        return Example(**response.json())

    def list_examples(
        self, dataset_id: Optional[ID_TYPE] = None, dataset_name: Optional[str] = None
    ) -> Iterator[Example]:
        """List the examples on the LangSmith API.

        Parameters
        ----------
        dataset_id : UUID or None, default=None
            The ID of the dataset to filter by.
        dataset_name : str or None, default=None
            The name of the dataset to filter by.

        Yields
        ------
        Example
            The examples.
        """
        params = {}
        if dataset_id is not None:
            params["dataset"] = dataset_id
        elif dataset_name is not None:
            dataset_id = self.read_dataset(dataset_name=dataset_name).id
            params["dataset"] = dataset_id
        else:
            pass
        yield from (
            Example(**dataset)
            for dataset in self._get_paginated_list("/examples", params=params)
        )

    def update_example(
        self,
        example_id: str,
        *,
        inputs: Optional[Dict[str, Any]] = None,
        outputs: Optional[Mapping[str, Any]] = None,
        dataset_id: Optional[ID_TYPE] = None,
    ) -> Dict[str, Any]:
        """Update a specific example.

        Parameters
        ----------
        example_id : str or UUID
            The ID of the example to update.
        inputs : Dict[str, Any] or None, default=None
            The input values to update.
        outputs : Mapping[str, Any] or None, default=None
            The output values to update.
        dataset_id : UUID or None, default=None
            The ID of the dataset to update.

        Returns
        -------
        Dict[str, Any]
            The updated example.
        """
        example = ExampleUpdate(
            inputs=inputs,
            outputs=outputs,
            dataset_id=dataset_id,
        )
        response = self.session.patch(
            f"{self.api_url}/examples/{example_id}",
            headers=self._headers,
            data=example.json(exclude_none=True),
        )
        raise_for_status_with_text(response)
        return response.json()

    def delete_example(self, example_id: ID_TYPE) -> None:
        """Delete an example by ID.

        Parameters
        ----------
        example_id : str or UUID
            The ID of the example to delete.
        """
        response = self.session.delete(
            f"{self.api_url}/examples/{example_id}",
            headers=self._headers,
        )
        raise_for_status_with_text(response)

    def _resolve_run_id(
        self, run: Union[Run, RunBase, str, UUID], load_child_runs: bool
    ) -> Run:
        """Resolve the run ID.

        Parameters
        ----------
        run : Run or RunBase or str or UUID
            The run to resolve.
        load_child_runs : bool
            Whether to load child runs.

        Returns
        -------
        Run
            The resolved run.

        Raises
        ------
        TypeError
            If the run type is invalid.
        """
        if isinstance(run, (str, UUID)):
            run_ = self.read_run(run, load_child_runs=load_child_runs)
        elif isinstance(run, Run):
            run_ = run
        elif isinstance(run, RunBase):
            run_ = Run(**run.dict())
        else:
            raise TypeError(f"Invalid run type: {type(run)}")
        return run_

    def _resolve_example_id(
        self, example: Union[Example, str, UUID, dict, None], run: Run
    ) -> Optional[Example]:
        """Resolve the example ID.

        Parameters
        ----------
        example : Example or str or UUID or dict or None
            The example to resolve.
        run : Run
            The run associated with the example.

        Returns
        -------
        Example or None
            The resolved example.
        """
        if isinstance(example, (str, UUID)):
            reference_example_ = self.read_example(example)
        elif isinstance(example, Example):
            reference_example_ = example
        elif isinstance(example, dict):
            reference_example_ = Example(**example)
        elif run.reference_example_id is not None:
            reference_example_ = self.read_example(run.reference_example_id)
        else:
            reference_example_ = None
        return reference_example_

    def evaluate_run(
        self,
        run: Union[Run, RunBase, str, UUID],
        evaluator: RunEvaluator,
        *,
        source_info: Optional[Dict[str, Any]] = None,
        reference_example: Optional[Union[Example, str, dict, UUID]] = None,
        load_child_runs: bool = False,
    ) -> Feedback:
        """Evaluate a run.

        Parameters
        ----------
        run : Run or RunBase or str or UUID
            The run to evaluate.
        evaluator : RunEvaluator
            The evaluator to use.
        source_info : Dict[str, Any] or None, default=None
            Additional information about the source of the evaluation to log
            as feedback metadata.
        reference_example : Example or str or dict or UUID or None, default=None
            The example to use as a reference for the evaluation.
            If not provided, the run's reference example will be used.
        load_child_runs : bool, default=False
            Whether to load child runs when resolving the run ID.

        Returns
        -------
        Feedback
            The feedback object created by the evaluation.
        """
        run_ = self._resolve_run_id(run, load_child_runs=load_child_runs)
        reference_example_ = self._resolve_example_id(reference_example, run_)
        feedback_result = evaluator.evaluate_run(
            run_,
            example=reference_example_,
        )
        source_info = source_info or {}
        if feedback_result.evaluator_info:
            source_info = {**feedback_result.evaluator_info, **source_info}
        return self.create_feedback(
            run_.id,
            feedback_result.key,
            score=feedback_result.score,
            value=feedback_result.value,
            comment=feedback_result.comment,
            correction=feedback_result.correction,
            source_info=source_info,
            feedback_source_type=FeedbackSourceType.MODEL,
        )

    async def aevaluate_run(
        self,
        run: Union[Run, str, UUID],
        evaluator: RunEvaluator,
        *,
        source_info: Optional[Dict[str, Any]] = None,
        reference_example: Optional[Union[Example, str, dict, UUID]] = None,
        load_child_runs: bool = False,
    ) -> Feedback:
        """Evaluate a run asynchronously.

        Parameters
        ----------
        run : Run or str or UUID
            The run to evaluate.
        evaluator : RunEvaluator
            The evaluator to use.
        source_info : Dict[str, Any] or None, default=None
            Additional information about the source of the evaluation to log
            as feedback metadata.
        reference_example : Optional Example or UUID, default=None
            The example to use as a reference for the evaluation.
            If not provided, the run's reference example will be used.
        load_child_runs : bool, default=False
            Whether to load child runs when resolving the run ID.

        Returns
        -------
        Feedback
            The feedback created by the evaluation.
        """
        run_ = self._resolve_run_id(run, load_child_runs=load_child_runs)
        reference_example_ = self._resolve_example_id(reference_example, run_)
        feedback_result = await evaluator.aevaluate_run(
            run_,
            example=reference_example_,
        )
        source_info = source_info or {}
        if feedback_result.evaluator_info:
            source_info = {**feedback_result.evaluator_info, **source_info}
        return self.create_feedback(
            run_.id,
            feedback_result.key,
            score=feedback_result.score,
            value=feedback_result.value,
            comment=feedback_result.comment,
            correction=feedback_result.correction,
            source_info=source_info,
            feedback_source_type=FeedbackSourceType.MODEL,
        )

    def create_feedback(
        self,
        run_id: ID_TYPE,
        key: str,
        *,
        score: Union[float, int, bool, None] = None,
        value: Union[float, int, bool, str, dict, None] = None,
        correction: Union[str, dict, None] = None,
        comment: Union[str, None] = None,
        source_info: Optional[Dict[str, Any]] = None,
        feedback_source_type: Union[FeedbackSourceType, str] = FeedbackSourceType.API,
    ) -> Feedback:
        """Create a feedback in the LangSmith API.

        Parameters
        ----------
        run_id : str or UUID
            The ID of the run to provide feedback on.
        key : str
            The name of the metric, tag, or 'aspect' this feedback is about.
        score : float or int or bool or None, default=None
            The score to rate this run on the metric or aspect.
        value : float or int or bool or str or dict or None, default=None
            The display value or non-numeric value for this feedback.
        correction : str or dict or None, default=None
            The proper ground truth for this run.
        comment : str or None, default=None
            A comment about this feedback.
        source_info : Dict[str, Any] or None, default=None
            Information about the source of this feedback.
        feedback_source_type : FeedbackSourceType or str, default=FeedbackSourceType.API
            The type of feedback source.

        Returns
        -------
        Feedback
            The created feedback.
        """
        if feedback_source_type == FeedbackSourceType.API:
            feedback_source: FeedbackSourceBase = APIFeedbackSource(
                metadata=source_info
            )
        elif feedback_source_type == FeedbackSourceType.MODEL:
            feedback_source = ModelFeedbackSource(metadata=source_info)
        else:
            raise ValueError(f"Unknown feedback source type {feedback_source_type}")
        feedback = FeedbackCreate(
            id=uuid4(),
            run_id=run_id,
            key=key,
            score=score,
            value=value,
            correction=correction,
            comment=comment,
            feedback_source=feedback_source,
        )
        response = self.session.post(
            self.api_url + "/feedback",
            headers={**self._headers, "Content-Type": "application/json"},
            data=feedback.json(exclude_none=True),
        )
        raise_for_status_with_text(response)
        return Feedback(**response.json())

    def read_feedback(self, feedback_id: ID_TYPE) -> Feedback:
        """Read a feedback from the LangSmith API.

        Parameters
        ----------
        feedback_id : str or UUID
            The ID of the feedback to read.

        Returns
        -------
        Feedback
            The feedback.
        """
        response = self._get_with_retries(f"/feedback/{feedback_id}")
        return Feedback(**response.json())

    def list_feedback(
        self,
        *,
        run_ids: Optional[Sequence[ID_TYPE]] = None,
        **kwargs: Any,
    ) -> Iterator[Feedback]:
        """List the feedback objects on the LangSmith API.

        Parameters
        ----------
        run_ids : List[str or UUID] or None, default=None
            The IDs of the runs to filter by.
        **kwargs : Any
            Additional keyword arguments.

        Yields
        ------
        Feedback
            The feedback objects.
        """
        params = {
            "run": run_ids,
            **kwargs,
        }

        yield from (
            Feedback(**feedback)
            for feedback in self._get_paginated_list("/feedback", params=params)
        )

    def delete_feedback(self, feedback_id: ID_TYPE) -> None:
        """Delete a feedback by ID.

        Parameters
        ----------
        feedback_id : str or UUID
            The ID of the feedback to delete.
        """
        response = self.session.delete(
            f"{self.api_url}/feedback/{feedback_id}",
            headers=self._headers,
        )
        raise_for_status_with_text(response)

    async def arun_on_dataset(
        self,
        dataset_name: str,
        llm_or_chain_factory: Any,
        *,
        evaluation: Optional[Any] = None,
        concurrency_level: int = 5,
        num_repetitions: int = 1,
        project_name: Optional[str] = None,
        verbose: bool = False,
        tags: Optional[List[str]] = None,
        input_mapper: Optional[Callable[[Dict], Any]] = None,
    ) -> Dict[str, Any]:
        """
        Asynchronously run the Chain or language model on a dataset
        and store traces to the specified project name.

        Args:
            dataset_name: Name of the dataset to run the chain on.
            llm_or_chain_factory: Language model or Chain constructor to run
                over the dataset. The Chain constructor is used to permit
                independent calls on each example without carrying over state.
            evaluation: Optional evaluation configuration to use when evaluating
            concurrency_level: The number of async tasks to run concurrently.
            num_repetitions: Number of times to run the model on each example.
                This is useful when testing success rates or generating confidence
                intervals.
            project_name: Name of the project to store the traces in.
                Defaults to {dataset_name}-{chain class name}-{datetime}.
            verbose: Whether to print progress.
            tags: Tags to add to each run in the project.
            input_mapper: A function to map to the inputs dictionary from an Example
                to the format expected by the model to be evaluated. This is useful if
                your model needs to deserialize more complex schema or if your dataset
                has inputs with keys that differ from what is expected by your chain
                or agent.

        Returns:
            A dictionary containing the run's project name and the
            resulting model outputs.

        For the synchronous version, see client.run_on_dataset.

        Examples
        --------

        .. code-block:: python

            from langsmith import Client
            from langchain.chat_models import ChatOpenAI
            from langchain.chains import LLMChain
            from langchain.smith import RunEvalConfig

            # Chains may have memory. Passing in a constructor function lets the
            # evaluation framework avoid cross-contamination between runs.
            def construct_chain():
                llm = ChatOpenAI(temperature=0)
                chain = LLMChain.from_string(
                    llm,
                    "What's the answer to {your_input_key}"
                )
                return chain

            # Load off-the-shelf evaluators via config or the EvaluatorType (string or enum)
            evaluation_config = RunEvalConfig(
                evaluators=[
                    "qa",  # "Correctness" against a reference answer
                    "embedding_distance",
                    RunEvalConfig.Criteria("helpfulness"),
                    RunEvalConfig.Criteria({
                        "fifth-grader-score": "Do you have to be smarter than a fifth grader to answer this question?"
                    }),
                ]
            )

            client = Client()
            await client.arun_on_dataset(
                "<my_dataset_name>",
                construct_chain,
                evaluation=evaluation_config,
            )

        You can also create custom evaluators by subclassing the
        :class:`StringEvaluator <langchain.evaluation.schema.StringEvaluator>`
        or LangSmith's `RunEvaluator` classes.

        .. code-block:: python

            from typing import Optional
            from langchain.evaluation import StringEvaluator

            class MyStringEvaluator(StringEvaluator):

                @property
                def requires_input(self) -> bool:
                    return False

                @property
                def requires_reference(self) -> bool:
                    return True

                @property
                def evaluation_name(self) -> str:
                    return "exact_match"

                def _evaluate_strings(self, prediction, reference=None, input=None, **kwargs) -> dict:
                    return {"score": prediction == reference}


            evaluation_config = RunEvalConfig(
                custom_evaluators = [MyStringEvaluator()],
            )

            await client.arun_on_dataset(
                "<my_dataset_name>",
                construct_chain,
                evaluation=evaluation_config,
            )
        """  # noqa: E501
        try:
            from langchain.smith import arun_on_dataset as _arun_on_dataset
        except ImportError:
            raise ImportError(
                "The client.arun_on_dataset function requires the langchain"
                "package to run.\nInstall with pip install langchain"
            )
        return await _arun_on_dataset(
            self,
            dataset_name,
            llm_or_chain_factory,
            evaluation=evaluation,
            concurrency_level=concurrency_level,
            num_repetitions=num_repetitions,
            project_name=project_name,
            verbose=verbose,
            tags=tags,
            input_mapper=input_mapper,
        )

    def run_on_dataset(
        self,
        dataset_name: str,
        llm_or_chain_factory: Any,
        *,
        evaluation: Optional[Any] = None,
        num_repetitions: int = 1,
        project_name: Optional[str] = None,
        verbose: bool = False,
        tags: Optional[List[str]] = None,
        input_mapper: Optional[Callable[[Dict], Any]] = None,
    ) -> Dict[str, Any]:
        """
        Run the Chain or language model on a dataset and store traces
        to the specified project name.

        Args:
            dataset_name: Name of the dataset to run the chain on.
            llm_or_chain_factory: Language model or Chain constructor to run
                over the dataset. The Chain constructor is used to permit
                independent calls on each example without carrying over state.
            evaluation: Configuration for evaluators to run on the
                results of the chain
            num_repetitions: Number of times to run the model on each example.
                This is useful when testing success rates or generating confidence
                intervals.
            project_name: Name of the project to store the traces in.
                Defaults to {dataset_name}-{chain class name}-{datetime}.
            verbose: Whether to print progress.
            tags: Tags to add to each run in the project.
            input_mapper: A function to map to the inputs dictionary from an Example
                to the format expected by the model to be evaluated. This is useful if
                your model needs to deserialize more complex schema or if your dataset
                has inputs with keys that differ from what is expected by your chain
                or agent.

        Returns:
            A dictionary containing the run's project name and the resulting model outputs.


        For the (usually faster) async version of this function, see `client.arun_on_dataset`.

        Examples
        --------

        .. code-block:: python

            from langsmith import Client
            from langchain.chat_models import ChatOpenAI
            from langchain.chains import LLMChain
            from langchain.smith import RunEvalConfig

            # Chains may have memory. Passing in a constructor function lets the
            # evaluation framework avoid cross-contamination between runs.
            def construct_chain():
                llm = ChatOpenAI(temperature=0)
                chain = LLMChain.from_string(
                    llm,
                    "What's the answer to {your_input_key}"
                )
                return chain

            # Load off-the-shelf evaluators via config or the EvaluatorType (string or enum)
            evaluation_config = RunEvalConfig(
                evaluators=[
                    "qa",  # "Correctness" against a reference answer
                    "embedding_distance",
                    RunEvalConfig.Criteria("helpfulness"),
                    RunEvalConfig.Criteria({
                        "fifth-grader-score": "Do you have to be smarter than a fifth grader to answer this question?"
                    }),
                ]
            )

            client = Client()
            client.run_on_dataset(
                "<my_dataset_name>",
                construct_chain,
                evaluation=evaluation_config,
            )

        You can also create custom evaluators by subclassing the
        :class:`StringEvaluator <langchain.evaluation.schema.StringEvaluator>`
        or LangSmith's `RunEvaluator` classes.

        .. code-block:: python

            from typing import Optional
            from langchain.evaluation import StringEvaluator

            class MyStringEvaluator(StringEvaluator):

                @property
                def requires_input(self) -> bool:
                    return False

                @property
                def requires_reference(self) -> bool:
                    return True

                @property
                def evaluation_name(self) -> str:
                    return "exact_match"

                def _evaluate_strings(self, prediction, reference=None, input=None, **kwargs) -> dict:
                    return {"score": prediction == reference}


            evaluation_config = RunEvalConfig(
                custom_evaluators = [MyStringEvaluator()],
            )

            client.run_on_dataset(
                "<my_dataset_name>",
                construct_chain,
                evaluation=evaluation_config,
            )
        """  # noqa: E501
        try:
            from langchain.smith import run_on_dataset as _run_on_dataset
        except ImportError:
            raise ImportError(
                "The client.run_on_dataset function requires the langchain"
                "package to run.\nInstall with pip install langchain"
            )
        return _run_on_dataset(
            self,
            dataset_name,
            llm_or_chain_factory,
            evaluation=evaluation,
            num_repetitions=num_repetitions,
            project_name=project_name,
            verbose=verbose,
            tags=tags,
            input_mapper=input_mapper,
        )
