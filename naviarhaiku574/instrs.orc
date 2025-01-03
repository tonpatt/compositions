#define PFM1(NAME'OP')#
instr $NAME
    iamp    = ampdb(p4) / 6
    icps    = cpspch(p5)
    ibus    = p6
    icar    = p7
    imod    = p8
    indx1   = p9
    indx2   = p10
    iplkfn  = p11
    idtofn  = p12
    islope  = p13
    imixfm  = p14 * iamp
    imixplk = iamp - imixfm
    idetune = p15
    ismin   = p16
    ismax   = p17
    ifncar  = p18
    ifnmod  = p19

    kspl    jspline idetune, ismin, ismax
    ksfm    = -kspl
    kenv    transeg 1, p3, islope, 0
    kndx    = kenv * (indx2 - indx1) + indx1
    kamp    = kenv * imixfm

    afm     $OP kamp, icps + ksfm, icar, imod, kndx, ifncar, ifnmod
    adosc   u_ioscdt kamp, icps, idetune, 0, 3, idtofn
    aplk    pluck imixplk, icps + kspl, icps * 4, iplkfn, 1
    zawm    linen(dcblock(afm + aplk + adosc), .0001,p3,.01), ibus
endin
#

$PFM1(plkfm1'u_fm1')
$PFM1(plkpm1'u_pm1')

#define PFMM1(NAME'OP')#
instr $NAME
    iamp    = ampdb(p4)
    icps    = cpspch(p5)
    ibus    = p6
    icar    = p7
    imod1   = p8
    imod2   = p9
    indx1a  = p10
    indx2a  = p11
    indx1b  = p12
    indx2b  = p13
    islope1 = p14
    islope2 = p15
    islope3 = p16
    idetune = p17
    ismin   = p18
    ismax   = p19
    ifncar  = p20
    ifnmod1 = p21
    ifnmod2 = p22
    iatk    = p23
    idec    = p24 * p3
    irel    = p25 * p3

    kspl    jspline idetune, ismin, ismax
    ksfm    = -kspl
    kenv    transeg 0, 2e-3, 2, 1, p3 - 2e-3, islope1, 0
    kndx1   transeg indx2a, p3, islope2, indx1a
    kndx2   transeg indx2b, p3, islope3, indx2b
    kamp    = kenv * iamp

    afm     $OP kamp, icps + ksfm, icar, imod1, imod2,
                kndx1, kndx2, ifncar, ifnmod1, ifnmod2

    zawm    linen(dcblock(afm), .0001,p3,.01), ibus
endin
#

$PFMM1(fmm1'u_fmm')
$PFMM1(pmm1'u_pmm')


opcode u_rndenv, k, iiiiiiiii
    iamp, icps, icoef, idur, iatt, idec, isuslev, irel, iseed xin
    kenv    expseg 0.01, iatt, 1, idec, isuslev, idur - iatt - idec - irel, isuslev, irel, 0.01
    krnd    randi  kenv * icoef, iseed
            xout    (krnd + kenv * (1 - icoef)) * iamp
endop


instr tabm1
    iamp    = ampdb(p4)
    icps    = cpspch(p5)
    ibus    = p6
    ifn1    = p7
    ifn2    = p8
    ipmix   = p9
    iatk    = p10 * p3
    idec    = p11 * p3
    idetune = p12
    ismin   = p13
    ismax   = p14
    isuslev = p15
    iseed   = p16
    if0     = p17

    kenv    u_rndenv 1, 1, 0.1, p3, iatk, idec, isuslev, 0.05, iseed
    kmix1   linseg 0, p3 * ipmix, 1, p3 - (1-ipmix), 0
    kmix2   = 1 - kmix1
    kspl    jspline idetune, ismin, ismax
    aosc1   oscili kmix1, icps + kspl, ifn1
    aosc2   oscili kmix2, icps - kspl, ifn2
    kfilt   expon if0, p3, 20
    afilt   tone aosc1 + aosc2, kfilt
    zawm    linen(dcblock(afilt)*kenv, 0.0001, p3, 0.01), ibus
endin

