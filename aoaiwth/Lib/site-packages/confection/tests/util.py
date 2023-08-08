"""
Registered functions used for config tests.
"""
import contextlib
import dataclasses
import shutil
import tempfile
from pathlib import Path
from typing import Generator, Generic, Iterable, List, Optional, TypeVar, Union

import catalogue

try:
    from pydantic.v1.types import StrictBool
except ImportError:
    from pydantic.types import StrictBool  # type: ignore

import confection

FloatOrSeq = Union[float, List[float], Generator]
InT = TypeVar("InT")
OutT = TypeVar("OutT")


@dataclasses.dataclass
class Cat(Generic[InT, OutT]):
    name: str
    value_in: InT
    value_out: OutT


my_registry_namespace = "config_tests"


class my_registry(confection.registry):
    namespace = "config_tests"
    cats = catalogue.create(namespace, "cats", entry_points=False)
    optimizers = catalogue.create(namespace, "optimizers", entry_points=False)
    schedules = catalogue.create(namespace, "schedules", entry_points=False)
    initializers = catalogue.create(namespace, "initializers", entry_points=False)
    layers = catalogue.create(namespace, "layers", entry_points=False)


@my_registry.cats.register("catsie.v1")
def catsie_v1(evil: StrictBool, cute: bool = True) -> str:
    if evil:
        return "scratch!"
    else:
        return "meow"


@my_registry.cats.register("catsie.v2")
def catsie_v2(evil: StrictBool, cute: bool = True, cute_level: int = 1) -> str:
    if evil:
        return "scratch!"
    else:
        if cute_level > 2:
            return "meow <3"
        return "meow"


@my_registry.cats("catsie.v3")
def catsie(arg: Cat) -> Cat:
    return arg


@my_registry.optimizers("Adam.v1")
def Adam(
    learn_rate: FloatOrSeq = 0.001,
    *,
    beta1: FloatOrSeq = 0.001,
    beta2: FloatOrSeq = 0.001,
    use_averages: bool = True,
):
    """
    Mocks optimizer generation. Note that the returned object is not actually an optimizer. This function is merely used
    to illustrate how to use the function registry, e.g. with thinc.
    """

    @dataclasses.dataclass
    class Optimizer:
        learn_rate: FloatOrSeq
        beta1: FloatOrSeq
        beta2: FloatOrSeq
        use_averages: bool

    return Optimizer(
        learn_rate=learn_rate, beta1=beta1, beta2=beta2, use_averages=use_averages
    )


@my_registry.schedules("warmup_linear.v1")
def warmup_linear(
    initial_rate: float, warmup_steps: int, total_steps: int
) -> Iterable[float]:
    """Generate a series, starting from an initial rate, and then with a warmup
    period, and then a linear decline. Used for learning rates.
    """
    step = 0
    while True:
        if step < warmup_steps:
            factor = step / max(1, warmup_steps)
        else:
            factor = max(
                0.0, (total_steps - step) / max(1.0, total_steps - warmup_steps)
            )
        yield factor * initial_rate
        step += 1


@my_registry.cats("generic_cat.v1")
def generic_cat(cat: Cat[int, int]) -> Cat[int, int]:
    cat.name = "generic_cat"
    return cat


@my_registry.cats("int_cat.v1")
def int_cat(
    value_in: Optional[int] = None, value_out: Optional[int] = None
) -> Cat[Optional[int], Optional[int]]:
    """Instantiates cat with integer values."""
    return Cat(name="int_cat", value_in=value_in, value_out=value_out)


@my_registry.optimizers.register("my_cool_optimizer.v1")
def make_my_optimizer(learn_rate: List[float], beta1: float):
    return Adam(learn_rate, beta1=beta1)


@my_registry.schedules("my_cool_repetitive_schedule.v1")
def decaying(base_rate: float, repeat: int) -> List[float]:
    return repeat * [base_rate]


@contextlib.contextmanager
def make_tempdir():
    d = Path(tempfile.mkdtemp())
    yield d
    shutil.rmtree(str(d))
