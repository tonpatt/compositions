<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>

;;; For license information, see the README.md file

;;; Csound Orchestra for "dialoghi sottaceto"
;;; Gianantonio Patella -- Rev. January 2025


0dbfs 	= 1
nchnls	= 2
A4 		= 415

zakinit 6,1

giMasterL init 0
giMasterR init 1
giBusRevL init 2
giBusRevR init 3
giBusDelL init 4
giBusDelR init 5


gkPluck1Master  init 1
gkPluck1Rev     init .2
gkPluck1Del     init .4

gkPm1Master  init .6
gkPm1Rev     init .1
gkPm1Del     init .4

gkSub1Master  init .35
gkSub1Rev     init .1
gkSub1Del     init .4

gkFlux1Master  init .1
gkFlux1Rev     init .1
gkFlux1Del     init .2

opcode u_gpreset,i[],i[]i
	ipr[],ipreset xin
	ilen lenarray  ipr
    iN  = ipr[0]
	if ilen < (iN + 1) * ipreset + 1 || (ilen - 1) % iN != 0 igoto error
	xout slicearray(ipr, 1 + iN * ipreset, iN + iN * ipreset)
	igoto end
error:
	prints "ERROR: u_gpreset\n"
	exitnow
end:
endop

opcode u_masterSend,0,aak
	aoutL, aoutR, kgain xin
	zawm aoutL * kgain , giMasterL
	zawm aoutR * kgain , giMasterR
endop

opcode u_revSend,0,aak
	aoutL, aoutR, kgain xin
	zawm aoutL * kgain, giBusRevL
	zawm aoutR * kgain, giBusRevR
endop

opcode u_delSend,0,aak
	aoutL, aoutR, kgain xin
	zawm aoutL * kgain, giBusDelL
	zawm aoutR * kgain, giBusDelR
endop

opcode u_autopan,aa,ai
	aout, ivel_ch xin
	kch1 randi .5, ivel_ch, -1
	kch1 = .5 + kch1
	aoutL = aout * kch1
	aoutR = aout * (1 - kch1)
	xout aoutL, aoutR
endop


#include "opcodes.udo"

;					    ncol attack vib_dep vib_vel vel_ch
gipluck1[] fillarray    4,   .01,   4,      6,      8,
                             .02,   4.5,    7,      10,
                             .1,    5,      8,      14

instr pluck1
	ip[]	u_gpreset gipluck1,p6
		iat 	 = (ip[0] >= p3 - 0.1? p3 - 0.1: ip[0])
		ivib_dep = ip[1]
		ivib_vel = ip[2]
		ivel_ch  = ip[3]

	iamp = ampdb(p4) / 2
	ifr = cpspch(p5)
	iat = (p6 >= p3 - 0.1? p3 - 0.1: p6)
	ipch = pchoct(octcps(ifr))
	idetune = 3 / p3
	a1  u_ioscdt  iamp, ifr, idetune,1, 3, 1
	kls expseg 0.01,iat,1,p3-iat,0.001
	a2  u_pluck iamp, ifr, ifr*6, 2.35
	a3   dcblock a1 + a2
	aout linen kls * (a3),.0001,p3,.05

	aoutL, aoutR u_autopan aout, ivel_ch

	u_masterSend aoutL, aoutR, gkPluck1Master
	u_revSend    aoutL, aoutR, gkPluck1Rev
	u_delSend    aoutL, aoutR, gkPluck1Del

endin

;					 ncol attack port  mod  ind  vib_dep vib_vel vel_ch
gipm1[] fillarray    7,   .01,   1.5,  .5,  .9,  4,      6,      8,
                          .02,   2,    1,   .8,  4.5,    7,      10,
                          .1,    1,    .5,  .95, 5,      8,      14

instr pm1
	iamp = ampdb(p4) / 2
	ifr = cpspch(p5)
	ipch = pchoct(octcps(ifr))
	idetune = 3 / p3

	ip[]	u_gpreset gipm1,p6
		iat 	 = (ip[0] >= p3 - 0.1? p3 - 0.1: ip[0])
		iport 	 = ip[1]
		imod  	 = ip[2]
		iind  	 = ip[3]
		ivib_dep = ip[4]
		ivib_vel = ip[5]
		ivel_ch  = ip[6]

	kls  expseg 0.01,iat,1,p3-iat,0.001
	kvib randi ivib_dep, ivib_vel, -1
	a1  u_ipm1  iamp, ifr+kvib, iport, imod, kls * iind
	a2  u_ioscdt  iamp, ifr, idetune,1, 3, 1

	; noise block
	irdur = rnd(.015) + .015
	timout irdur,p3-irdur,down
	arn  rand iamp
	krn line 1,irdur,0
down:

	a3  = tanh(kls * (a1+a2+arn*krn) * 1.2)
	aout linen a3*.8,.0001,p3,.05

	aoutL, aoutR u_autopan aout, ivel_ch

	u_masterSend aoutL, aoutR, gkPm1Master
	u_revSend    aoutL, aoutR, gkPm1Rev
	u_delSend    aoutL, aoutR, gkPm1Del

endin

;				   ncol  att  dec,  port  mod  ind  pregain postgain minff  maxff fdbfil vibdep vibvel velch
gisub1[] fillarray 13,   .81, .5,   2.5,  .5,  1.2, 2.1,    .4,      400,   900,  -3.1,  6,     6,     1,
                         1,   .4,   2,    1,   1.0, 2.5,    .25,     300,   2700, -2.7,  5,     8,     2,
                         .1,  .3,   1.5,  1,   1.0, 2.9,    .41,     1900,  200,  -2.7,  5,     7,     2.3,
                         .21, .1,   2,    3,   2.0, 2.8,    .45,     1100,  100,  -1.7,  5,     5,     2.5

instr sub1
	iamp = ampdb(p4)
	ifrq = cpspch(p5)
	ip[]	u_gpreset gisub1,p6
		iat            = (ip[0] >= p3 - 0.1? p3 - 0.1: ip[0])
		idec           = ip[1]
		iport          = ip[2]
		imod           = ip[3]
		iind           = ip[4]
		idist_gain     = ip[5]
		ipost_gain     = ip[6]
		imin_filt      = ip[7]
		imax_filt      = ip[8]
		ifeedback_filt = ip[9]
		ivib_dep       = ip[10]
		ivib_vel       = ip[11]
		ivel_ch        = ip[12]

	kls  expseg 0.01, iat, 1, p3 - iat - idec, .1, idec, 0.001
	kvib randi ivib_dep, ivib_vel, -1
	a1  u_ipm1  iamp, ifrq + kvib, iport, imod, kls * iind
	kl  expon  imin_filt,p3,imax_filt
	a2  u_ladder a1, kl, ifeedback_filt
	a3  = tanh(a2 * idist_gain)
	aout linen a3*ipost_gain * kls, .0001, p3, .05

	aoutL, aoutR u_autopan aout, ivel_ch

	u_masterSend aoutL, aoutR, gkSub1Master
	u_revSend    aoutL, aoutR, gkSub1Rev
	u_delSend    aoutL, aoutR, gkSub1Del

endin

gifx1 ftgen 0,0,8192,10,1,.03,0,-.02,.005,-.003,.001

instr flux1
	iamp = ampdb(p4)
	ifrq = cpspch(p5)
	ifrq = (ifrq < 220? ifrq * 4: ifrq)
	iatt = .12
	idec = .2
	ivel_ch = 3
	ij_dep = 2
	ij_min = 6
	ij_max = 8
	kj2  jitter ij_dep, ij_min, ij_max
	a1 oscili iamp, ifrq + kj2, gifx1
	krn  expseg 1,.05,.05,p3-.15,.08,.1,.6
	a2 rand iamp*.6
	kenv expseg .01,iatt,1,p3-iatt-idec,.15,idec,.01
	aout linen (a1 + a2*krn)*kenv,.01,p3,.01

	aoutL, aoutR u_autopan aout, ivel_ch

	u_masterSend aoutL, aoutR, gkFlux1Master
	u_revSend    aoutL, aoutR, gkFlux1Rev
	u_delSend    aoutL, aoutR, gkFlux1Del

endin

instr rev1
	iRoomSize = p4
	iDamp = p5
	aInL zar giBusRevL
	aInR zar giBusRevR
	aL, aR  freeverb aInL, aInR, iRoomSize, iDamp, sr, 0
	outs aL, aR
endin

instr del1
	aInL zar giBusDelL
	aInR zar giBusDelR
	igain = p4
	iRevTime1 = 3
	iLoopTime1 = .333
	iRevTime2 = 3
	iLoopTime2 = .125
	iRevTime3 = 3
	iLoopTime3 = .25
	iRevTime4 = 3
	iLoopTime4 = .666
	aL dcblock aInL * igain
	aR dcblock aInR * igain
	aL1, aR1  u_comb2 aL, iRevTime1, iLoopTime1, iRevTime2, iLoopTime2, 1
	aL2, aR2  u_comb2 aR, iRevTime3, iLoopTime3, iRevTime4, iLoopTime4, 1
	outs  aL1 + aL2, aR1 + aR2
endin

instr mixer
	iMasterGain = p4
	aL zar giMasterL
	aR zar giMasterR

	outs1  aL * iMasterGain
	outs2  aR * iMasterGain

	zacl 0, 6
endin

</CsInstruments>
<CsScore>
f100 0 8192 7 1 8192 -1
f1 0 8192 30 100 0 6
f-100
f2 0 8192 7 1 8192 -1


#include "score.sco"

;rev1                  RoomSize  Damp
i "rev1"  0  $DURTOT   0.99      0.45

;del1                  gain
i "del1"  0  $DURTOT   0.4

;						   Bus1   Bus2   Bus3
i "iOutBusGain" 0 $DURTOT  1      0      .6

;mixer                  gain
i "mixer" 0    $DURTOT  2.168

</CsScore>
</CsoundSynthesizer>


