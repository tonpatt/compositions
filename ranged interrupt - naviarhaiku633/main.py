# pylint: disable=C0114, C0116, R0917, R0913
from mm4.score import Score, Instr, Nota
from mm4.rnd import Rnd
from mm4.uti import gen1001


def main():
    sco = Score(80)
    pchs = [6.06, 6.11, 7.01, 7.03, 7.06, 7.11, 8.01, 8.03, 8.06, 8.11, 9.01, 9.03]
    durs = [5, 4.5, 4, 3.5, 3.25, 3]
    ats = [0, 0.125, 0.25, 2.25]
    amps = [-12, -10, -15, -18]
    instrs = [
        Instr("tab3o", "0 2   .8 1 3 0 0 0"),
        Instr("tab3o", "0 1   .8 1 1 0 0 0"),
        Instr("tab3o", "0 .05 .8 2 6 0 0 0"),
        Instr("tab3o", "0 .05 .8 5 6 0 0 0"),
        Instr("tab3o", "0 .01 .8 1 4 0 0 0"),
        Instr("fm01", "0 2 3    0 0 0   0 0 0 0"),
        Instr("fm01", "0 1 2    0 0 0.1 0 0 0 0"),
        Instr("fm01", "0 3 2    0 0 0   0 0 0 0"),
        Instr("fm01", "0 3 0.5  0 0 0.2 0 0 0 0"),
        Instr("fm01", "0 1 0.75 0 0 0.5 0 0 0 0"),
        Instr("pm01", "0 1 5 1 0 0 0.2 0 -1 2 0 0 0"),
        Instr("pm01", "0 4 2 1.5 0 0 0 0 -1 3 0 0 0"),
        Instr("pm01", "0 4 3 1.2 0 0 0 0 -1 4 0 0 0"),
        Instr("pm01", "0 3 4 1.4 0 0 0 0 -1 6 0 0 0"),
    ]
    sco.append(gen1001(1, 0, 513, 1, 12, 0, 106, 1, 300, -1, 106, 0, fsize=4097))
    sco.append(gen1001(2, 0, 513, 1, 12, 1, 256, 1, 0, -1, 256, -1, fsize=4097))
    sco.append(
        "f3 0 4097 10 1 .05 -.1 -.15 0 .05 0 0 .02 0 0 -.01\n"
        + "f4 0 4097 10 1 .05 .01 -.02 0 .003\n"
        + "f5 0 4097 10 .5 -1 .05 .01 -.05 0 0 0 -.023"
    )
    sco.append(
        gen1001(6, 0, 513, 1, 12, 0, 30, 1, 176, 1, 100, -1, 186, -1, 20, 0, fsize=4097)
    )
    parms = (instrs, ats, durs, amps, pchs)
    atime = gen_score(62, Rnd(1), sco, 0, parms)
    Rnd(2).shuffle(instrs)
    atime = gen_score(62, Rnd(1), sco, atime + 5, parms)
    Rnd(3).shuffle(amps)
    Rnd(4).shuffle(instrs)
    atime = gen_score(62, Rnd(1), sco, atime + 3, parms)
    sco.write("score.sco", 1)


def gen_score(nnote, rgen, sco, atime, parms):
    sco.append("; -----")
    for ins, at, dur, amp, pch in rgen.mess(parms, nnote):
        sco.append(Nota(ins, atime, dur, amp, pch))
        atime += at
    return atime


if __name__ == "__main__":
    main()
