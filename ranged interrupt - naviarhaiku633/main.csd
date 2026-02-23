<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>

sr      =   44100
kr      =   4410
0dbfs   =   1.0
nchnls  =   2

zakinit 1, 1

#include "instrs.orc"

</CsInstruments>

<CsScore>

#include "score.sco"

;                       bus gain           rvt1  lpt1
;                                          rvt2  lpt2                 wet      fdb      fadeout
i "combs01" 0 [$TOTDUR] 0  [0.5 / 0.553]   30    [ 19/8 * $MRATIO ]
                                           30    [ 23/8 * $MRATIO ]   0.08     -0.05    1

</CsScore>
</CsoundSynthesizer>


