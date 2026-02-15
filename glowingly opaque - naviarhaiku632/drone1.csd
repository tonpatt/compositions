<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>

sr      =   44100
kr      =   4410
0dbfs   =   1.0
nchnls  =   2

giMonoBus init 3

zakinit giMonoBus, 1

opcode seg3,k,iiiii
    iamp,iatk,idur,ilev,irel xin
    kout = linseg(0, iatk, iamp,idur - iatk - irel, ilev * iamp, irel, 0)
    xout kout
endop

opcode fadeout,a,io
    idur, idec xin
    idec = (idec == 0? 0.01: idec)
    afadeout linseg 1, idur - idec, 1, idec, 0
    xout afadeout
endop

opcode frq,i,i
    ifreq xin
    xout (ifreq < 0? -ifreq: cpspch(ifreq))
endop

instr tab3o
    ; INIT
    iamp    = ampdb(p4)/3
    icps    = frq(p5)
    iatk    = p6
    ilev    = (p7 == 0? .7: p7)
    idec    = p8
    ifn     = p9
    ivdep = (p10 == 0 ? 2.7 : p10)
    ivmin = (p11 == 0 ? 4 : p11)
    ivmax = (p12 == 0 ? 14 : p12)
    ibus    = p13

    ; PERF
    kspl jspline 	icps * ivdep / 1000, ivmin, ivmax
    kenv    seg3   iamp, iatk, p3, ilev, idec
    aosc1   oscili kenv, icps + kspl, ifn
    aosc2   oscili kenv, icps - kspl, ifn
    ksweep  line   icps * 1.001, p3, icps
    aosc3   oscili kenv, ksweep, ifn
    zawm    (aosc1+aosc2+aosc3) * fadeout(p3), ibus
endin

instr comb
    ibus = p4
    iGain  = p5
    irvt1  = p6
    ilpt1  = p7
    irvt2  = p8
    ilpt2  = p9
    imixWet  = p10
    imixDry  = 1 - imixWet
    ifdb   = p11
    iFade  = p12

    asig  zar ibus
    asig  *=  iGain
    acmbR init 0
    acmbL init 0
    kdep  linseg 0.1, p3/2, .25, p3/2, 0.1
    kvep  linseg 0.1, p3/2, 1, p3/2, 0.1
    kpan  randi kdep, kvep
    aL, aR pan2 asig, kpan + 0.5
    ktri  expseg 10, p3*.7, 4900, p3*.3, 600
    krnd1 randh ktri, .73
    krnd2 randh ktri, .39
    acmbL comb aL + randh(acmbR, krnd1) * ifdb, irvt1, ilpt1
    acmbR comb aR + randh(acmbL, krnd2) * ifdb, irvt2, ilpt2

    outs1 (aL * imixDry + acmbL * imixWet) * fadeout(p3, iFade)
    outs2 (aR * imixDry + acmbR * imixWet) * fadeout(p3, iFade)
    zacl ibus
endin

</CsInstruments>

<CsScore bin="python drone1.py">

f1 0 513 7 0 106 1 300 -1 106 0
f2 0 513 7 1 256 1 0 -1 256 -1
f3 0 513 10 1 .05 -.1 -.15 0 .05 0 0 .02 0 0 -.01
f4 0 513 10 1 .05 .01 -.02 0 .003
f5 0 513 10 .5 -1 .05 .01 -.05 0 0 0 -.023
f6 0 513 7 0 30 1 176 1 100 -1 186 -1 20 0

;                    bus gain        rvt1  lpt1
;                                    rvt2  lpt2                 wet      fdb      fadeout
i "comb" 0 [$TOTDUR] 0  [0.87/0.48]  90    [ 39/8 * $MRATIO ]
                                     90    [ 47/8 * $MRATIO ]   0.11      0.8    5

</CsScore>
</CsoundSynthesizer>


