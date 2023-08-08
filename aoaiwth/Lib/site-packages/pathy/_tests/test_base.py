import tempfile
from errno import ENOTDIR
from pathlib import Path
from typing import Any

import pytest

from .. import (
    Blob,
    BlobStat,
    Bucket,
    BucketClient,
    BucketClientFS,
    BucketEntry,
    ClientError,
    Pathy,
    PurePathy,
    use_fs,
)
from ..about import __version__


def test_base_package_declares_version() -> None:
    assert __version__ is not None


def test_base_not_supported(monkeypatch: Any) -> None:
    monkeypatch.setattr(Pathy._flavour, "is_supported", False)
    with pytest.raises(NotImplementedError):
        Pathy()


def test_base_cwd() -> None:
    with pytest.raises(NotImplementedError):
        Pathy.cwd()


def test_base_home() -> None:
    with pytest.raises(NotImplementedError):
        Pathy.home()


def test_base_expanduser() -> None:
    path = Pathy("gs://fake-bucket/fake-key")
    with pytest.raises(NotImplementedError):
        path.expanduser()


def test_base_chmod() -> None:
    path = Pathy("gs://fake-bucket/fake-key")
    with pytest.raises(NotImplementedError):
        path.chmod(0o666)


def test_base_lchmod() -> None:
    path = Pathy("gs://fake-bucket/fake-key")
    with pytest.raises(NotImplementedError):
        path.lchmod(0o666)


def test_base_group() -> None:
    path = Pathy("gs://fake-bucket/fake-key")
    with pytest.raises(NotImplementedError):
        path.group()


def test_base_is_mount() -> None:
    assert not Pathy("gs://fake-bucket/fake-key").is_mount()


def test_base_is_symlink() -> None:
    assert not Pathy("gs://fake-bucket/fake-key").is_symlink()


def test_base_is_socket() -> None:
    assert not Pathy("gs://fake-bucket/fake-key").is_socket()


def test_base_is_fifo() -> None:
    assert not Pathy("gs://fake-bucket/fake-key").is_fifo()


def test_base_is_block_device() -> None:
    path = Pathy("gs://fake-bucket/fake-key")
    with pytest.raises(NotImplementedError):
        path.is_block_device()


def test_base_is_char_device() -> None:
    path = Pathy("gs://fake-bucket/fake-key")
    with pytest.raises(NotImplementedError):
        path.is_char_device()


def test_base_lstat() -> None:
    path = Pathy("gs://fake-bucket/fake-key")
    with pytest.raises(NotImplementedError):
        path.lstat()


def test_base_symlink_to() -> None:
    path = Pathy("gs://fake-bucket/fake-key")
    with pytest.raises(NotImplementedError):
        path.symlink_to("file_name")


def test_base_path_check_mode() -> None:
    tmp_dir = tempfile.mkdtemp()
    root = Pathy.fluid(tmp_dir)

    assert root.is_dir() is True

    # Ignores OSErrors about not a directory and returns false
    def not_dir_fn(mode: int) -> bool:
        err = OSError()
        err.errno = ENOTDIR
        raise err

    assert root._check_mode(not_dir_fn) is False

    # Ignores ValueError
    def value_error_fn(mode: int) -> bool:
        raise ValueError("oops")

    assert root._check_mode(value_error_fn) is False

    # Raises from OSError with unknown code
    def other_os_error_fn(mode: int) -> bool:
        err = OSError()
        err.errno = 1337
        raise err

    with pytest.raises(OSError):
        root._check_mode(other_os_error_fn)

    # Raises other unrelated exceptions
    def other_error_fn(mode: int) -> bool:
        raise BaseException()

    with pytest.raises(BaseException):
        root._check_mode(other_error_fn)


def test_base_path_stat_helpers() -> None:
    tmp_dir = tempfile.mkdtemp()
    root = Pathy.fluid(tmp_dir)

    assert root.is_dir() is True

    file = root / "file.txt"
    file.write_text("hello world")

    assert file.is_file() is True
    assert file.is_dir() is False
    assert file.is_mount() is False
    assert file.is_symlink() is False
    assert file.is_block_device() is False
    assert file.is_char_device() is False
    assert file.is_fifo() is False
    assert file.is_socket() is False

    file.unlink()
    root.rmdir()


def test_pathy_mro() -> None:
    assert PurePathy in Pathy.mro()
    assert Path in Pathy.mro()


def test_path_truediv_operator_overload_with_subclass() -> None:
    class MyPathy(Pathy):
        pass

    custom_pathy = MyPathy("gs://foo/bar")
    base_pathy = Pathy("gs://bar/baz")

    out_pathy: Pathy = base_pathy / custom_pathy
    other_pathy: Pathy = custom_pathy / base_pathy
    assert isinstance(out_pathy, Pathy)
    assert isinstance(other_pathy, Pathy)


def test_buckets_rename_replace(temp_folder: Path) -> None:
    use_fs(temp_folder)
    Pathy.from_bucket("foo").mkdir()
    from_path = Pathy("gs://foo/bar")
    to_path = Pathy("gs://foo/baz")
    # Source foo/bar does not exist
    with pytest.raises(FileNotFoundError):
        from_path.rename(to_path)
    with pytest.raises(FileNotFoundError):
        from_path.replace(to_path)


def test_client_create_bucket(temp_folder: Path) -> None:
    bucket_target = temp_folder / "foo"
    assert bucket_target.exists() is False
    cl = BucketClientFS(temp_folder)
    cl.create_bucket(Pathy("gs://foo/"))
    assert bucket_target.exists() is True


def test_client_base_bucket_raises_not_implemented() -> None:
    bucket: Bucket = Bucket()
    blob: Blob = Blob(bucket, "foo", -1, -1, None, None)
    with pytest.raises(NotImplementedError):
        bucket.copy_blob(blob, bucket, "baz")
    with pytest.raises(NotImplementedError):
        bucket.get_blob("baz")
    with pytest.raises(NotImplementedError):
        bucket.delete_blobs([blob])
    with pytest.raises(NotImplementedError):
        bucket.delete_blob(blob)
    with pytest.raises(NotImplementedError):
        bucket.exists()


def test_client_base_blob_raises_not_implemented() -> None:
    blob: Blob = Blob(Bucket(), "foo", -1, -1, None, None)
    with pytest.raises(NotImplementedError):
        blob.delete()
    with pytest.raises(NotImplementedError):
        blob.exists()


def test_client_base_bucket_client_raises_not_implemented() -> None:
    client: BucketClient = BucketClient()
    with pytest.raises(NotImplementedError):
        client.exists(Pathy("gs://foo"))
    with pytest.raises(NotImplementedError):
        client.is_dir(Pathy("gs://foo"))
    with pytest.raises(NotImplementedError):
        client.get_bucket(Pathy("gs://foo"))
    with pytest.raises(NotImplementedError):
        client.list_blobs(Pathy("gs://foo"))
    with pytest.raises(NotImplementedError):
        client.scandir(Pathy("gs://foo"))
    with pytest.raises(NotImplementedError):
        client.create_bucket(Pathy("gs://foo"))
    with pytest.raises(NotImplementedError):
        client.delete_bucket(Pathy("gs://foo"))


def test_bucket_client_rmdir() -> None:
    client: BucketClient = BucketClient()
    client.rmdir(Pathy("gs://foo/bar"))


def test_bucket_client_get_blob() -> None:
    client: BucketClient = BucketClient()
    assert client.get_blob(Pathy("gs://foo")) is None


def test_bucket_client_make_uri() -> None:
    client: BucketClient = BucketClient()
    assert client.make_uri(Pathy("gs://foo/bar")) == "gs://foo/bar"


def test_client_error_repr() -> None:
    error = ClientError("test_message", 1337)
    assert repr(error) == "(1337) test_message"
    assert f"{error}" == "(1337) test_message"


def test_bucket_entry_defaults() -> None:
    entry: BucketEntry = BucketEntry("name")
    assert entry.is_dir() is False
    assert entry.is_file() is True
    entry.inode()
    assert "BucketEntry" in repr(entry)
    assert "last_modified" in repr(entry)
    assert "size" in repr(entry)
    stat = entry.stat()
    assert isinstance(stat, BlobStat)
    assert stat.last_modified is None
    assert stat.size == -1
