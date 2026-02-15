# pylint: disable=C0116, C0115, C0114

from dataclasses import dataclass
from sys import argv
from score import Score, Instr, Loop, Nota


def main():
    sco = Score(50)
    sco.include(argv[1])
    pchs = Loop((6.01, 6.011, 7.03))
    durs = Loop((4, 4.5, 3.5, 7.25, 3.5, 3.25))
    durs.index = 3
    amps = Loop((-6, -12, -10, -15))
    ins_a = Instr("tab3o", "2 .8 1 3 0 0 0 0")
    ins_b = Instr("tab3o", "1 .8 1 1 0 0 0 0")
    ins_c = Instr("tab3o", ".05 .8 2 6 0 0 0 0")
    ins_d = Instr("tab3o", ".01 .8 1 4 0 0 0 0")
    main.sco = sco
    repeat(0, 190, ins_a, LData(durs, amps, pchs, 1.1))
    repeat(
        15,
        170,
        ins_b,
        LData(Loop((2.25, -1.75)), Loop((-27, -32)), Loop((9.1097, 8.1101)), 1.5),
    )
    repeat(
        30,
        140,
        ins_c,
        LData(Loop((4.5, -2.75)), Loop((-10, -18)), Loop((5.01, 5.011)), 1.6),
    )
    repeat(
        45,
        60,
        ins_d,
        LData(Loop((5.75, 2.25, -2.25)), Loop((-15, -22)), Loop((7.01, 7.011, 8.0202))),
    )
    sco.write(argv[2], 7)


@dataclass
class LData:

    durs: Loop
    amps: Loop
    pchs: Loop
    dmolt: float = 1.0
    amolt: float = 1.0


def repeat(start: float, dur: float, ins: Instr, ld: LData):
    atime = start
    stop = dur + start
    while atime < stop:
        dur = ld.durs.next()
        if dur > 0:
            main.sco.append(
                Nota(ins, atime, dur * ld.dmolt, ld.amps.next(), ld.pchs.next())
            )
        atime += abs(dur) * ld.amolt


if __name__ == "__main__":
    main()
