<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr      =   44100
kr      =   4410
0dbfs   =   1
nchnls  =   2


zakinit 5, 1

#include "instrs.orc"

instr dryout

    ibus    = p4
    igain   = p5
    iclean  = p6
    asig    zar ibus
    asig    *= igain
            outs asig, asig
    if iclean != 0 goto noclean
            zacl ibus, ibus
noclean:

endin

instr combs

    ibus    = p4
    igain   = p5
    iclean  = p6
    ifdb    = 0.015
    irvt1   = 30
    irvt2   = 30
    ilpt1   = 0.711
    ilpt2   = 0.513
    iwet    = ampdb(-28)
    idry    = 1 - iwet
    asig    zar ibus
    asig    *= igain
    iatk    = 0.01
    idec    = 0.01
    ideldel = 5

    aenv    linseg 0, iatk, 1, p3 - idec - iatk, 1, idec, 0

    acmb1x  init 0
    acmb2   init 0

    acmb1   comb asig + acmb2 * ifdb, irvt1, ilpt1
    acmb1x  delay acmb1x, ideldel
    acmb2   comb asig + acmb1x * ifdb, irvt2, ilpt2

            outs1 (asig * idry + acmb1 * iwet) * aenv
            outs2 (asig * idry + acmb2 * iwet) * aenv

    acmb1x  tone acmb1, 700
    acmb2   tone acmb2, 700


    if iclean != 0 goto noclean
            zacl ibus, ibus
noclean:

endin

</CsInstruments>

<CsScore>

#include "score.sco"
;                        bus gain             clean_flag
i "combs"  0  $DURTOT    0   [0.1 / 0.245]    0

</CsScore>
</CsoundSynthesizer>


