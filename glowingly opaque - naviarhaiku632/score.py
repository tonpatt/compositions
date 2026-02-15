# pylint: disable=C0116, C0115, C0114
from dataclasses import dataclass


@dataclass
class Instr:

    name: int | str
    parms: str | None = None

    def _get_instr_name(self) -> str:
        if isinstance(self.name, str):
            return f'"{self.name}"'
        return str(self.name)

    ins_name = property(_get_instr_name)

    def _get_parms(self) -> str:
        if self.parms is None:
            return ""
        return self.parms

    ins_parms = property(_get_parms)


@dataclass
class Nota:

    instr: Instr
    atime: float
    dur: float
    amp: float
    pch: float

    def __str__(self):
        nota = f"i {self.instr.ins_name}"
        nota += f" {self.atime} {self.dur:.3f} {self.amp} {self.pch} "
        nota += self.instr.ins_parms
        return nota


class Score:

    def __init__(self, metronomo=60) -> None:
        self._metronomo: int = metronomo
        self._note = []
        self._totdur = 0

    def append(self, item: Nota | str) -> None:
        if isinstance(item, Nota):
            self._totdur = max(item.atime + item.dur, self._totdur)
        self._note.append(item)

    def write(self, filename: str, tail: float = 0) -> None:
        with open(filename, "w", encoding="utf-8") as fo:
            if self._metronomo != 60:
                print(f"t0 {self._metronomo}", file=fo)
            print(f"#define TOTDUR #{self._totdur + tail}#", file=fo)
            print(f"#define MRATIO #{60/self._metronomo}#", file=fo)
            for item in self._note:
                print(item, file=fo)
            print("e", file=fo)

    def include(self, filename: str) -> None:
        with open(filename, "r", encoding="utf-8") as fi:
            for line in fi:
                self.append(line)


@dataclass
class Loop:

    values: list | tuple

    def __post_init__(self):
        self._len = len(self.values)
        self._cnt = 0

    def next(self, incr=1):
        value = self.values[self._cnt]
        self._cnt = (self._cnt + incr) % self._len
        return value

    def _set_cnt(self, index):
        if index == -1:
            self._cnt = self._len - 1
            return
        if 0 <= index < self._len:
            self._cnt = index
            return
        raise ValueError("out of boundary")

    index = property(None, _set_cnt)
