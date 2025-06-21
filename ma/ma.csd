<CsoundSynthesizer>
<CsOptions>
-o ma.wav
</CsOptions>
<CsInstruments>

;;; For license information, see the README.md file

;;; Csound Orchestra for "ma" (a self-generating music test)
;;; Gianantonio Patella -- 2025

ga1     init    0
gaL     init    0
gaR     init    0

sr      =       44100
kr      =       4410
nchnls  =       2
0dbfs   =       0.61


instr pluck

        idiv    = 24 ; quarti di tono
        ioct    = int(octcps(p5) * idiv) / idiv
        ipch    = pchoct(ioct)
        print   ipch
        icps    = cpsoct(ioct)
        iamp    = ampdb(p4)/2
        ipan    = p6
        icar    = int(p7)
        imod    = int(p8 / 0.5) * 0.5
        iind    = int(p9 / 0.5) * 0.5
        imix    = p10
        igain   = p11
        icf1    = p12
        icf2    = p13
        iQ      = p14
        aplk    pluck iamp, icps, icps * 8, 0, 1
        iatk    = random(0.001, 0.15)
        kenv    expseg 1e-2, iatk, 1, p3 - iatk, 1e-3

        kspl    jspline 1, 3, 14
        afm     foscili iamp * kenv, icps * 0.5 + kspl, icar, imod, iind * kenv
        aplk    dcblock aplk * imix + afm * (1-imix)
        kcf     expon  icf1, p3, icf2
        kbw     = kcf / iQ
        afil    reson  aplk, kcf, kbw, 1
        adist   = tanh(dcblock(afil) * igain)
        aL, aR  pan2 adist, ipan
        outs    aL, aR
        gaL     += aL
        gaR     += aR
        ga1     += adist * 0.5
endin

instr fm
        iamp    = ampdb(p4)
        icps    = cpspch(p5)
        icar    = p6
        imod    = p7
        iind    = p8
        aenv    expseg .001, p3*.05, 1, p3*.6, 0.5, p3*.35, 0.001
        kind    line   iind, p3, 0
        kspl    jspline 0.5, 5, 12

        afm     foscili iamp * aenv, icps + kspl, icar, imod, kind
        ga1     += afm
endin

instr gen
        iminDel init p7
        iperiod = 1/p4
        ithreshold = p5
        iseed   = p6
        istart  = p2
        iend    = istart + p3
        ktime   line istart, p3, iend
        imaxcps = 2900
        imincps = 110
        ideltacps = (imaxcps - imincps) * 0.5
        kcf     randi ideltacps, iperiod, iseed
        kcf     = imincps + abs(kcf)
        kpan    randi 0.5, p4, iseed
        kpan    += 0.5
        asig    = (ga1 + gaL + gaR) * 0.99
        afil    reson asig, kcf, kcf * 0.29, 1
        kfil    = k(afil)
                if kfil < ithreshold goto giu
        su:
                timout 0, iminDel, giu
                reinit su
                rireturn
        igCf    = i(kcf)
                schedulek "pluck",
                          ktime,                ; a-time
                          random(1, 19),        ; dur
                          -9,                   ; db
                          kcf,                  ; cps
                          kpan,                 ; pan
                          random(0.25, 4),      ; car
                          random(0.25, 4),      ; mod
                          random(-1, 1),        ; ind
                          random(0.3, 0.7),     ; mix
                          random(1, 19),        ; gain
                          random(30, 8000),     ; fil cf1
                          random(30, 8000),     ; fil cf2
                          random(0.707, 20)     ; fil Q
        giu:

endin

instr combs
        afm     = 0.45 * ga1
        aL      comb gaR * .041, 29 , 0.109
        aR      comb gaL * .041, 29 , 2.066
                outs aL + afm, aR + afm
        ga1     = 0
        gaL     = 0
        gaR     = 0
endin

</CsInstruments>

<CsScore>

;;; Csound Score for "ma" (a self-generating music test)
;;; Gianantonio Patella -- 2025

;                db    pch  car mod     index
i "fm" 0     75  -30   6.01 1   1.00045 10.5
i .    3     .   .     7.02
i .    7.5   .   .     8.03
i .    11    .   .     6.04
i .    12.3  .   .     9.05
i .    19.1  .   .     8.06
i .    27.2  .   .     8.07
i .    35.45 .   .     7.08
i .    51.72 .   .     7.09
i .    67.23 .   .     9.10
i .    71.61 .   .     6.11
i .    83.72 .   .     6.00

;                period thresh seed mindel
i "gen"  0 90    .39    .020   .11  .166
i "gen"  0 90    .61    .020   .33  .5

i "combs" 0 190

</CsScore>
</CsoundSynthesizer>


