//////////////////////////////////////////////////////////////////////////////
// DTOSC

/*
Sum 'iN' oscillators each spaced 'idet' Hz apart.

kamp: 		amplitude
kfrq:		frequency
idet: 		detune applied to each oscillator
iN: 		number of oscillators
ifn: 		oscillator function
*/
#define OSCDT(NAME'OSC') #
opcode $NAME,a,kkiiiio
    asig init 0
    kamp, kfrq, idet, iphs, iN, ifn, icnt xin
    iph  init iphs / (iN - 1)
    if icnt >= iN - 1 goto syn
        asig $NAME kamp, kfrq, idet, iphs, iN, ifn, icnt + 1
    syn:
    aosc $OSC kamp / iN, kfrq + idet * icnt, ifn, iph * icnt
        xout asig + aosc
endop
#

$OSCDT(u_oscdt'oscil')
$OSCDT(u_ioscdt'oscili')

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
// PHASE AND FREQUENCY MODULATION

giOned2PI  init 1 / ($M_PI * 2)

opcode u_ph, a, kkaio
    kamp, kcps, amod, ifn, iphs xin
    aph   phasor kcps, iphs
    atab  table aph + amod * giOned2PI, ifn, 1, 0, 1
    xout  atab * kamp
endop

opcode u_iph, a, kkaio
    kamp, kcps, amod, ifn, iphs xin
    aph   phasor kcps, iphs
    atab  tablei aph + amod * giOned2PI, ifn, 1, 0, 1
    xout  atab * kamp
endop

//////////////////////////////////////////////////////////////////////////////
// U_FM1
#define FM1(NAME'OSC')#
opcode $NAME,a,kkkkkjj
    kamp, kcps, kcar, kmod, kndx, ifncar, ifnmod xin
    kcar    = kcps * kcar
    kmod    = kcps * kmod
    amod    $OSC kmod * kndx, kmod, ifnmod, 0
    afm     $OSC kamp, kcar + amod, ifncar, 0
            xout afm
endop
#

$FM1(u_fm1'oscil')
$FM1(u_ifm1'oscili')

//////////////////////////////////////////////////////////////////////////////
// U_PM1
#define PM1(NAME'OSC'OP')#
opcode $NAME,a,kkkkkjj
    kamp, kcps, kcar, kmod, kndx, ifncar, ifnmod xin
    kcar    = kcps * kcar
    amod    $OSC kndx, kcps * kmod, ifnmod
    apm     $OP kamp, kcar, amod, ifncar, 0.25
            xout    apm
endop
#

$PM1(u_pm1'oscil'u_ph')
$PM1(u_ipm1'oscili'u_iph')

//////////////////////////////////////////////////////////////////////////////
// U_FMM
#define FMM(NAME'OSC')#
opcode $NAME,a,kkkkkkkjjj
    kamp, kcps, kcar, kmod1, kmod2, kndx1, kndx2, ifncar, ifnmod1, ifnmod2 xin
    kcar    = kcps * kcar
    kmod1   = kcps * kmod1
    kmod2   = kcps * kmod2
    amod1   $OSC kmod1 * kndx1, kmod1, ifnmod1, 0
    amod2   $OSC kmod2 * kndx2, kmod2 + amod1, ifnmod2, 0
    afm     $OSC kamp, kcar + amod2, ifncar, 0
            xout afm
endop
#

$FMM(u_fmm'oscil')
$FMM(u_ifmm'oscili')

//////////////////////////////////////////////////////////////////////////////
// U_PMM
#define PMM(NAME'OSC'OP')#
opcode $NAME,a,kkkkkkkjjj
    kamp, kcps, kcar, kmod1, kmod2, kndx1, kndx2, ifncar, ifnmod1, ifnmod2 xin
    kcar    = kcps * kcar
    kmod1   = kcps * kmod1
    kmod2   = kcps * kmod2
    amod1   $OSC kndx1, kmod1, ifnmod1
    apm2    $OP kndx2, kmod2, amod1, ifnmod2
    afm     $OP kamp, kcar, apm2, ifncar, 0.25
            xout afm
endop
#

$PMM(u_pmm'oscil'u_ph')
$PMM(u_ipmm'oscili'u_iph')
