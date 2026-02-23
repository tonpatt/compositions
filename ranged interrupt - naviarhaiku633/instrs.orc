
#include "udos.udo"
#include "generators.udo"

instr tab3o
    ; INIT
    iamp    = ampdb(p4)/3
    icps    = u_frq(p5)
    ibus    = p6
    iatk    = p7
    ilev    = (p8 == 0? .7: p8)
    irel    = p9
    ifn     = p10
    ivdep   = (p11 == 0 ? 2.7 : p11)
    ivmin   = (p12 == 0 ? 4 : p12)
    ivmax   = (p13 == 0 ? 14 : p13)

    ; PERF
    kspl    jspline icps * ivdep / 1000, ivmin, ivmax
    kenv    u_seg3   iamp, iatk, p3, ilev, irel
    aosc1   oscili kenv, icps + kspl, ifn
    aosc2   oscili kenv, icps - kspl, ifn
    ksweep  line   icps * 1.001, p3, icps
    aosc3   oscili kenv, ksweep, ifn
    zawm    (aosc1+aosc2+aosc3) * u_fadeout(p3), ibus
endin

instr fm01
    ; INIT
    ifidx   = 1000
    iamp    = ampdb(p4)
    icps    = cpspch(p5)
    ibus    = p6
    icar    = p7
    imod    = p8
    iampAtk = p9
    iampRel = (p10 == 0 ? (p3 - iampAtk) * 0.2: p10)
    indxmod = ifidx / icps * 0.5 * iamp
    indxAtk = p11
    indxRel = (p12 == 0 ? (p3 - indxAtk) * 0.2: p12)
    ifnfm   = -1
    ivdep   = (p13 == 0 ? 3 : p13)
    ivmin   = (p14 == 0 ? 4 : p14)
    ivmax   = (p15 == 0 ? 12 : p15)
    print   icps, indxmod

    ; PERF
    keamp   u_seg3 iamp, iampAtk, p3, iamp, iampRel
    kendx   u_seg3 indxmod, indxAtk, p3, .75, indxRel
    kspl    jspline icps * ivdep / 1000, ivmin, ivmax
    afm     foscili 1, icps + kspl, icar, imod, kendx, ifnfm, .25
    zawm    linen(dcblock(afm*keamp), 1e-3, p3, 1e-2), ibus
endin


instr pm01
    ; INIT
    ifidx   = 1000
    iamp    = ampdb(p4)
    icps    = cpspch(p5)
    ibus    = p6
    icar    = p7
    imod    = p8
    indx    = p9
    iampAtk = p10
    iampRel = (p11 == 0 ? (p3 - iampAtk) * 0.2: p11)
    indxAtk = p12
    indxRel = (p13 == 0 ? (p3 - indxAtk) * 0.2: p13)
    ifnCar  = p14
    ifnMod  = p15
    ivdep   = (p16 == 0 ? 3 : p16)
    ivmin   = (p17 == 0 ? 4 : p17)
    ivmax   = (p18 == 0 ? 12 : p18)

    ; PERF
    keamp   u_seg3 iamp, iampAtk, p3, iamp, iampRel
    kendx   u_seg3 indx, indxAtk, p3, .75, indxRel
    kspl    jspline icps * ivdep / 1000, ivmin, ivmax
    afm     u_ipm1 1, icps + kspl, icar, imod, kendx, ifnCar, ifnMod
    zawm    linen(dcblock(afm*keamp), 1e-3, p3, 1e-2), ibus
endin

instr combs01
    ibus    = p4
    iGain   = p5
    irvt1   = p6
    ilpt1   = p7
    irvt2   = p8
    ilpt2   = p9
    imixWet = p10
    imixDry = 1 - imixWet
    ifdb    = p11
    iFade   = p12

    asig    zar ibus
    asig    *=  iGain
    acmbR   init 0
    acmbL   init 0
    kdep    linseg 0.1, p3/2, .25, p3/2, 0.1
    kvep    linseg 0.1, p3/2, 1, p3/2, 0.1
    kpan    randi kdep, kvep
    aL, aR  pan2 asig, kpan + 0.5
    acmbL   comb aL + acmbR * ifdb, irvt1, ilpt1
    acmbR   comb aR + acmbL * ifdb, irvt2, ilpt2

    outs1   (aL * imixDry + acmbL * imixWet) * u_fadeout(p3, iFade)
    outs2   (aR * imixDry + acmbR * imixWet) * u_fadeout(p3, iFade)
    zacl    ibus
endin
