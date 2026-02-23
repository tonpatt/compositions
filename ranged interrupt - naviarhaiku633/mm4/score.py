"""Classes for managing the Csound score."""

from dataclasses import dataclass
from typing import List, Union, Iterable


@dataclass
class Instr:
    """
    Class for managing the Csound instrument definition and its fixed parameters.

    Attributes:
        name: The instrument number or name (string).
        parms: Optional fixed string of parameters (p-fields) for this instrument.
    """

    name: Union[int, str]
    parms: str = ""

    @property
    def ins_name(self) -> str:
        """Returns the formatted instrument name (quoted if it's a string)."""
        return f'"{self.name}"' if isinstance(self.name, str) else str(self.name)

    @property
    def ins_parms(self) -> str:
        """Returns the instrument parameters or an empty string if None."""
        return self.parms if self.parms else ""


@dataclass
class Nota:
    """
    Class that encapsulates the fundamental parameters of a Csound note (i-statement).

    Attributes:
        instr: An instance of the Instr class.
        atime: Start time in beats/seconds (p2).
        dur: Duration in beats/seconds (p3).
        amp: Amplitude (typically p4).
        pch: Pitch/Frequency (typically p5).
    """

    instr: Instr
    atime: float
    dur: float
    amp: float
    pch: float

    def __str__(self) -> str:
        """Returns the formatted Csound i-statement string."""
        base = (
            f"i {self.instr.ins_name} {self.atime} {self.dur:.3f} {self.amp} {self.pch}"
        )
        return " ".join(filter(None, [base, self.instr.ins_parms]))


class Score:
    """
    Class for Csound score management, handling note lists and file generation.
    """

    def __init__(self, metronomo: int = 60) -> None:
        """
        Initializes the score.

        Args:
            metronomo: Tempo in BPM (default 60).
        """
        self._metronomo: int = metronomo
        self._score: List[Union[Nota, str]] = []
        self._totdur: float = 0.0

    def append(self, items: Union[Nota, str, Iterable]) -> None:
        """
        Adds one or more notes or custom strings to the score.
        """
        if not isinstance(items, (list, tuple)):
            items = [items]

        for item in items:
            if isinstance(item, Nota):
                self._totdur = max(item.atime + item.dur, self._totdur)
                self._score.append(item)
            elif isinstance(item, str):
                self._score.append(item)
            else:
                raise TypeError(f"Type not supported: {type(item)}. Only note or str.")

    def write(self, filename: str, tail: float = 0.0) -> None:
        """
        Writes the generated score to a file.

        Args:
            filename: Path to the output file.
            tail: Extra silence (in seconds) to add to the TOTDUR definition.
        """
        with open(filename, "w", encoding="utf-8") as fo:
            if self._metronomo != 60:
                fo.write(f"t 0 {self._metronomo}\n")
            fo.write(f"#define TOTDUR #{self._totdur + tail}#\n")
            fo.write(f"#define MRATIO #{60/self._metronomo}#\n")
            for item in self._score:
                fo.write(f"{item}\n")

    def include(self, filename: str) -> None:
        """
        Reads the contents of an external file and adds it to the current score.

        Args:
            filename: Path to the file to be included.
        """
        with open(filename, "r", encoding="utf-8") as fi:
            for line in fi:
                self._score.append(line.strip())
