import pytest


def pytest_addoption(parser):
    parser.addoption("--slow", action="store_true", help="include slow tests")


@pytest.fixture()
def pathy_fixture():
    pytest.importorskip("pathy")
    import shutil
    import tempfile

    from pathy import Pathy, use_fs

    temp_folder = tempfile.mkdtemp(prefix="thinc-pathy")
    use_fs(temp_folder)

    root = Pathy("gs://test-bucket")
    root.mkdir(exist_ok=True)

    yield root
    use_fs(False)
    shutil.rmtree(temp_folder)
