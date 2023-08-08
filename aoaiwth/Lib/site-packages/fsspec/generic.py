import inspect
import logging

from .asyn import AsyncFileSystem
from .callbacks import _DEFAULT_CALLBACK
from .core import filesystem, get_filesystem_class, split_protocol

_generic_fs = {}
logger = logging.getLogger("fsspec.generic")


def set_generic_fs(protocol, **storage_options):
    _generic_fs[protocol] = filesystem(protocol, **storage_options)


default_method = "default"


def _resolve_fs(url, method=None, protocol=None, storage_options=None):
    """Pick instance of backend FS"""
    method = method or default_method
    protocol = protocol or split_protocol(url)[0]
    storage_options = storage_options or {}
    if method == "default":
        return filesystem(protocol)
    if method == "generic":
        return _generic_fs[protocol]
    if method == "current":
        cls = get_filesystem_class(protocol)
        return cls.current()
    if method == "options":
        return filesystem(protocol, **storage_options.get(protocol, {}))
    raise ValueError(f"Unknown FS resolution method: {method}")


def rsync(
    source,
    destination,
    delete_missing=False,
    source_field="size",
    dest_field="size",
    update_cond="different",
    inst_kwargs=None,
    fs=None,
    **kwargs,
):
    """Sync files between two directory trees

    (experimental)

    Parameters
    ----------
    source: str
        Root of the directory tree to take files from.
    destination: str
        Root path to copy into. The contents of this location should be
        identical to the contents of ``source`` when done.
    delete_missing: bool
        If there are paths in the destination that don't exist in the
        source and this is True, delete them. Otherwise, leave them alone.
    source_field: str
        If ``update_field`` is "different", this is the key in the info
        of source files to consider for difference.
    dest_field: str
        If ``update_field`` is "different", this is the key in the info
        of destination files to consider for difference.
    update_cond: "different"|"always"|"never"
        If "always", every file is copied, regardless of whether it exists in
        the destination. If "never", files that exist in the destination are
        not copied again. If "different" (default), only copy if the info
        fields given by ``source_field`` and ``dest_field`` (usually "size")
        are different. Other comparisons may be added in the future.
    inst_kwargs: dict|None
        If ``fs`` is None, use this set of keyword arguments to make a
        GenericFileSystem instance
    fs: GenericFileSystem|None
        Instance to use if explicitly given. The instance defines how to
        to make downstream file system instances from paths.
    """
    fs = fs or GenericFileSystem(**(inst_kwargs or {}))
    source = fs._strip_protocol(source)
    destination = fs._strip_protocol(destination)
    allfiles = fs.find(source, withdirs=True, detail=True)
    if not fs.isdir(source):
        raise ValueError("Can only rsync on a directory")
    otherfiles = fs.find(destination, withdirs=True, detail=True)
    dirs = [
        a
        for a, v in allfiles.items()
        if v["type"] == "directory" and a.replace(source, destination) not in otherfiles
    ]
    logger.debug(f"{len(dirs)} directories to create")
    for dirn in dirs:
        # no async
        fs.mkdirs(dirn.replace(source, destination), exist_ok=True)
    allfiles = {a: v for a, v in allfiles.items() if v["type"] == "file"}
    logger.debug(f"{len(allfiles)} files to consider for copy")
    to_delete = [
        o
        for o, v in otherfiles.items()
        if o.replace(destination, source) not in allfiles and v["type"] == "file"
    ]
    for k, v in allfiles.copy().items():
        otherfile = k.replace(source, destination)
        if otherfile in otherfiles:
            if update_cond == "always":
                allfiles[k] = otherfile
            elif update_cond == "different":
                if v[source_field] != otherfiles[otherfile][dest_field]:
                    # details mismatch, make copy
                    allfiles[k] = otherfile
                else:
                    # details match, don't copy
                    allfiles.pop(k)
        else:
            # file not in target yet
            allfiles[k] = otherfile
    if allfiles:
        source_files, target_files = zip(*allfiles.items())
        logger.debug(f"{len(source_files)} files to copy")
        fs.cp(source_files, target_files, **kwargs)
    if delete_missing:
        logger.debug(f"{len(to_delete)} files to delete")
        fs.rm(to_delete)


class GenericFileSystem(AsyncFileSystem):
    """Wrapper over all other FS types

    <experimental!>

    This implementation is a single unified interface to be able to run FS operations
    over generic URLs, and dispatch to the specific implementations using the URL
    protocol prefix.

    Note: instances of this FS are always async, even if you never use it with any async
    backend.
    """

    protocol = "generic"  # there is no real reason to ever use a protocol with this FS

    def __init__(self, default_method="default", **kwargs):
        """

        Parameters
        ----------
        default_method: str (optional)
            Defines how to configure backend FS instances. Options are:
            - "default": instantiate like FSClass(), with no
              extra arguments; this is the default instance of that FS, and can be
              configured via the config system
            - "generic": takes instances from the `_generic_fs` dict in this module,
              which you must populate before use. Keys are by protocol
            - "current": takes the most recently instantiated version of each FS
        """
        self.method = default_method
        super(GenericFileSystem, self).__init__(**kwargs)

    def _strip_protocol(self, path):
        # normalization only
        fs = _resolve_fs(path, self.method)
        return fs.unstrip_protocol(fs._strip_protocol(path))

    async def _find(self, path, maxdepth=None, withdirs=False, detail=False, **kwargs):
        fs = _resolve_fs(path, self.method)
        if fs.async_impl:
            out = await fs._find(
                path, maxdepth=maxdepth, withdirs=withdirs, detail=detail, **kwargs
            )
        else:
            out = fs.find(
                path, maxdepth=maxdepth, withdirs=withdirs, detail=detail, **kwargs
            )
        result = {}
        for k, v in out.items():
            name = fs.unstrip_protocol(k)
            v["name"] = name
            result[name] = v
        if detail:
            return result
        return list(result)

    async def _info(self, url, **kwargs):
        fs = _resolve_fs(url, self.method)
        if fs.async_impl:
            out = await fs._info(url, **kwargs)
        else:
            out = fs.info(url, **kwargs)
        out["name"] = fs.unstrip_protocol(out["name"])
        return out

    async def _ls(
        self,
        url,
        detail=True,
        **kwargs,
    ):
        fs = _resolve_fs(url, self.method)
        if fs.async_impl:
            out = await fs._ls(url, detail=True, **kwargs)
        else:
            out = fs.ls(url, detail=True, **kwargs)
        for o in out:
            o["name"] = fs.unstrip_protocol(o["name"])
        if detail:
            return out
        else:
            return [o["name"] for o in out]

    async def _cat_file(
        self,
        url,
        **kwargs,
    ):
        fs = _resolve_fs(url, self.method)
        if fs.async_impl:
            return await fs._cat_file(url, **kwargs)
        else:
            return fs.cat_file(url, **kwargs)

    async def _pipe_file(
        self,
        path,
        value,
        **kwargs,
    ):
        fs = _resolve_fs(path, self.method)
        if fs.async_impl:
            return await fs._pipe_file(path, value, **kwargs)
        else:
            return fs.pipe_file(path, value, **kwargs)

    async def _rm(self, url, **kwargs):
        fs = _resolve_fs(url, self.method)
        if fs.async_impl:
            await fs._rm(url, **kwargs)
        else:
            fs.rm(url, **kwargs)

    async def _makedirs(self, path, exist_ok=False):
        fs = _resolve_fs(path, self.method)
        if fs.async_impl:
            await fs._makedirs(path, exist_ok=exist_ok)
        else:
            fs.makedirs(path, exist_ok=exist_ok)

    def rsync(self, source, destination, **kwargs):
        """Sync files between two directory trees

        See `func:rsync` for more details.
        """
        rsync(source, destination, fs=self, **kwargs)

    async def _cp_file(
        self,
        url,
        url2,
        blocksize=2**20,
        callback=_DEFAULT_CALLBACK,
        **kwargs,
    ):
        fs = _resolve_fs(url, self.method)
        fs2 = _resolve_fs(url2, self.method)
        if fs is fs2:
            # pure remote
            if fs.async_impl:
                return await fs._cp_file(url, url2, **kwargs)
            else:
                return fs.cp_file(url, url2, **kwargs)
        kw = {"blocksize": 0, "cache_type": "none"}
        try:
            f1 = (
                await fs.open_async(url, "rb")
                if hasattr(fs, "open_async")
                else fs.open(url, "rb", **kw)
            )
            callback.set_size(await maybe_await(f1.size))
            f2 = (
                await fs2.open_async(url2, "wb")
                if hasattr(fs2, "open_async")
                else fs2.open(url2, "wb", **kw)
            )
            while f1.size is None or f2.tell() < f1.size:
                data = await maybe_await(f1.read(blocksize))
                if f1.size is None and not data:
                    break
                await maybe_await(f2.write(data))
                callback.absolute_update(f2.tell())
        finally:
            try:
                await maybe_await(f2.close())
                await maybe_await(f1.close())
            except NameError:
                # fail while opening f1 or f2
                pass


async def maybe_await(cor):
    if inspect.iscoroutine(cor):
        return await cor
    else:
        return cor
