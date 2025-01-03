<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>

sr      =   44100
kr      =   4410
0dbfs   =   1
nchnls  =   2


zakinit 5, 1

#include "generators.udo"
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
    ifdb    = p7
    irvt1   = p8
    irvt2   = p8
    ilpt1   = p9
    ilpt2   = p10
    iwet    = ampdb(p11)
    idry    = 1 - iwet
    asig    zar ibus
    asig    *= igain
    iatk    = p12
    idec    = p13
    ideldel = p14

    aenv    linseg 0, iatk, 1, p3 - idec - iatk, 1, idec, 0

    acmb1x  init 0
    acmb2   init 0

    acmb1   comb asig + acmb2 * ifdb, irvt1, ilpt1
    acmb1x  delay acmb1x, ideldel
    acmb2   comb asig + acmb1x * ifdb, irvt2, ilpt2

            outs1 (asig * idry + acmb1 * iwet) * aenv
            outs2 (asig * idry + acmb2 * iwet) * aenv

    acmb1x  tone acmb1, 1000
    acmb2   tone acmb2, 1000


    if iclean != 0 goto noclean
            zacl ibus, ibus
noclean:

endin

</CsInstruments>

<CsScore>

#include "score.sco"
;                        bus gain clean fdb   rvt lpt1  lpt2  wet(db) atk dec ddel
i "combs"  0  $DURTOT    0   .52  0     0.015 30  0.711 0.513 -22     .01 0.1 5

</CsScore>
</CsoundSynthesizer>


