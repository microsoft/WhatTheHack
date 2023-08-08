from pkg_resources import resource_filename

DATA_ROOT = resource_filename('langcodes', 'data')
import os


def data_filename(filename):
    return os.path.join(DATA_ROOT, filename)
