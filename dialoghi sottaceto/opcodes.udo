//////////////////////////////////////////////////////////////////////////////
// DTOSC

/* oscdt

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
// U_LADDER
opcode u_ladder,a,akk
	asig, kfc, kfdb xin
	setksmps 1
	af3  init 0
	af0  tone asig + af3 * kfdb, kfc
	af1  tone af0, kfc
	af2  tone af1, kfc
	af3  tone af2, kfc
	xout af3
endop

//////////////////////////////////////////////////////////////////////////////
// U_PLUCK
opcode u_pluck,a,kkii
	kamp, kcps, icps, ifun xin
	imix1 = ifun - int(ifun)
	imix2 = 1 - imix1
	aplk1 pluck imix1 * kamp, kcps, icps, 0, 1
	aplk2 pluck imix2 * kamp, kcps, icps, int(ifun), 1
	xout aplk1 + aplk2
endop

//////////////////////////////////////////////////////////////////////////////
// U_COMBS2
opcode u_comb2,aa,aiiiii
	asig, irvt1, ilpt1, irvt2, ilpt2, imix xin
	setksmps 1
	ilog001 init log(0.001)
	ifdb1 = exp(ilog001 * ilpt1 / irvt1)
	ifdb2 = exp(ilog001 * ilpt2 / irvt2)
	imix1 = imix
	imix2 = 1 - imix
	ac2  init 0
	ac1  comb asig + ac2 * ifdb1 * imix1, irvt1, ilpt1
	ac2  comb asig + ac1 * ifdb2 * imix2, irvt2, ilpt2
	xout ac1, ac2
endop
