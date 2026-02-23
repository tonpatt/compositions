"""Utility classes and methods for Csound score generation."""

from dataclasses import dataclass, field
from typing import Any, Union, List, Tuple


@dataclass
class Loop:
    """
    Class for rotating/looping through elements of a list or tuple.

    Attributes:
        values: The sequence of elements to loop over.
        start: The starting index (default 0).
    """

    values: Union[List, Tuple]
    start: int = 0
    _cnt: int = field(init=False)
    _len: int = field(init=False)

    def __post_init__(self):
        self._len = len(self.values)
        if not 0 <= self.start < self._len:
            raise ValueError(
                f"Start index {self.start} is out of boundary for length {self._len}"
            )
        self._cnt = self.start

    def next(self, incr: int = 1) -> Any:
        """Returns the next item and increments the counter."""
        value = self.values[self._cnt]
        self._cnt = (self._cnt + incr) % self._len
        return value


def gen1001(
    nfun: int, atime: float, size: int, minh: int, maxh: int, *args, **opts
) -> str:
    """
    Simplifies the use of the gen30. Creates a Csound f-statement sequence
    using a temporary GEN routine to be transformed.

    Args:
        nfun: Final function number.
        atime: Action time.
        size: Size of the function.
        minh: Lowest harmonic number.
        maxh: Highest harmonic number.
        args: Parameters for the temporary function.
        opts:
            tfun: The number of the temporary function (default=1001).
            ngen: The GEN routine number for the temporary function (default=7).
            fsize: The actual size of the function (default=size).

    Returns:
        A string containing the f-statements.
    """
    diff = set(opts.keys()) - {"tfun", "ngen", "fsize"}
    assert len(diff) == 0, f"invalid options: {diff}"

    tmp_fun = opts.get("tfun", 1001)
    gen_num = opts.get("ngen", 7)
    f_size = opts.get("fsize", size)
    s = f"f {tmp_fun} {atime} {size} {gen_num}"
    for f_parm in args:
        s += f" {f_parm}"
    s += "\n"
    s += f"f {nfun} {atime} {f_size} 30 {tmp_fun} {minh} {maxh}\n"
    s += f"f -{tmp_fun}"
    return s
