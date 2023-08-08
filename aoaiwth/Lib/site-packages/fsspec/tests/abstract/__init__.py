import os

import pytest

from fsspec.implementations.local import LocalFileSystem
from fsspec.tests.abstract.copy import AbstractCopyTests  # noqa
from fsspec.tests.abstract.get import AbstractGetTests  # noqa
from fsspec.tests.abstract.put import AbstractPutTests  # noqa


class BaseAbstractFixtures:
    """
    Abstract base class containing fixtures that are used by but never need to
    be overridden in derived filesystem-specific classes to run the abstract
    tests on such filesystems.
    """

    @pytest.fixture
    def fs_bulk_operations_scenario_0(self, fs, fs_join, fs_path):
        """
        Scenario on remote filesystem that is used for many cp/get/put tests.

        Cleans up at the end of each test it which it is used.
        """
        source = self._bulk_operations_scenario_0(fs, fs_join, fs_path)
        yield source
        fs.rm(source, recursive=True)

    @pytest.fixture
    def fs_target(self, fs, fs_join, fs_path):
        """
        Return name of remote directory that does not yet exist to copy into.

        Cleans up at the end of each test it which it is used.
        """
        target = fs_join(fs_path, "target")
        yield target
        if fs.exists(target):
            fs.rm(target, recursive=True)

    @pytest.fixture
    def local_bulk_operations_scenario_0(self, local_fs, local_join, local_path):
        """
        Scenario on local filesystem that is used for many cp/get/put tests.

        Cleans up at the end of each test it which it is used.
        """
        source = self._bulk_operations_scenario_0(local_fs, local_join, local_path)
        yield source
        local_fs.rm(source, recursive=True)

    @pytest.fixture
    def local_target(self, local_fs, local_join, local_path):
        """
        Return name of local directory that does not yet exist to copy into.

        Cleans up at the end of each test it which it is used.
        """
        target = local_join(local_path, "target")
        yield target
        if local_fs.exists(target):
            local_fs.rm(target, recursive=True)

    def _bulk_operations_scenario_0(self, some_fs, some_join, some_path):
        """
        Scenario that is used for many cp/get/put tests. Creates the following
        directory and file structure:

        📁 source
        ├── 📄 file1
        ├── 📄 file2
        └── 📁 subdir
            ├── 📄 subfile1
            ├── 📄 subfile2
            └── 📁 nesteddir
                └── 📄 nestedfile
        """
        source = some_join(some_path, "source")
        subdir = some_join(source, "subdir")
        nesteddir = some_join(subdir, "nesteddir")
        some_fs.makedirs(nesteddir)
        some_fs.touch(some_join(source, "file1"))
        some_fs.touch(some_join(source, "file2"))
        some_fs.touch(some_join(subdir, "subfile1"))
        some_fs.touch(some_join(subdir, "subfile2"))
        some_fs.touch(some_join(nesteddir, "nestedfile"))
        return source


class AbstractFixtures(BaseAbstractFixtures):
    """
    Abstract base class containing fixtures that may be overridden in derived
    filesystem-specific classes to run the abstract tests on such filesystems.

    For any particular filesystem some of these fixtures must be overridden,
    such as ``fs`` and ``fs_path``, and others may be overridden if the
    default functions here are not appropriate, such as ``fs_join``.
    """

    @pytest.fixture
    def fs(self):
        raise NotImplementedError("This function must be overridden in derived classes")

    @pytest.fixture
    def fs_join(self):
        """
        Return a function that joins its arguments together into a path.

        Most fsspec implementations join paths in a platform-dependent way,
        but some will override this to always use a forward slash.
        """
        return os.path.join

    @pytest.fixture
    def fs_path(self):
        raise NotImplementedError("This function must be overridden in derived classes")

    @pytest.fixture(scope="class")
    def local_fs(self):
        # Maybe need an option for auto_mkdir=False?  This is only relevant
        # for certain implementations.
        return LocalFileSystem(auto_mkdir=True)

    @pytest.fixture
    def local_join(self):
        """
        Return a function that joins its arguments together into a path, on
        the local filesystem.
        """
        return os.path.join

    @pytest.fixture
    def local_path(self, tmpdir):
        return tmpdir

    def supports_empty_directories(self):
        """
        Return whether this implementation supports empty directories.
        """
        return True
