;;; For license information, see the README.md file

;;; Csound Orchestra for "line agitate (1994)"
;;; Gianantonio Patella -- Rev. January 2025

sr		=	44100
kr		=	4410
nchnls	=	2

ga1	init	0

; Table instrument contains two functions with vibrato
; driven by Randi.
instr	1
	iamp = p4 * 0.97194
	k2	randi	p5*.006,1,-1
	a1	oscili	iamp,p5+k2,p6
	a2	oscili	iamp,p5+k2,p7
	k1	line	1,p3,0
	a3	linen	a1*k1+a2*(1-k1),p9,p3,p10
	outs	a3*p8,a3*(1-p8)
	ga1	=	ga1+a3
endin


instr 99

irevfactor	= p4
ilowpass	= 9000
ioutputscale	= p5

idel1 = 1237.000/sr
idel2 = 1381.000/sr
idel3 = 1607.000/sr
idel4 = 1777.000/sr
idel5 = 1949.000/sr
idel6 = 2063.000/sr
idel7 = 307.000/sr
idel8 = 97.000/sr
idel9 = 71.000/sr
idel10 = 53.000/sr
idel11 = 47.000/sr
idel12 = 37.000/sr
idel13 = 31.000/sr

icsc1 = .822 * irevfactor
icsc2 = .802 * irevfactor
icsc3 = .773 * irevfactor
icsc4 = .753 * irevfactor
icsc5 = .753 * irevfactor
icsc6 = .753 * irevfactor

icsc7 = .7 * irevfactor


acomb1  comb 	ga1, icsc1, idel1, p8
acomb2  comb 	ga1, icsc2, idel2, p8
acomb3  comb 	ga1, icsc3, idel3, p8
acomb4  comb 	ga1, icsc4, idel4, p8
acomb5  comb 	ga1, icsc5, idel5, p8
acomb6  comb 	ga1, icsc6, idel6, p8

acomball = acomb1 + acomb2 + acomb3 + acomb4 + acomb5 + acomb6

allp1 		alpass 	acomball, icsc7, idel7, p8
allp2		alpass 	allp1, icsc7, idel8, p8
allp3		alpass	allp2, icsc7, idel9, p8
alow		tone		allp3, ilowpass, p8
allp4		alpass	alow, icsc7, idel10, p8
allp5		alpass	allp4, icsc7, idel12, p8
arevout1	=  allp5 * ioutputscale

k1		line	p6,p3,p7
k2		line	ampdb(p9),p3,ampdb(p10)
k3		=	1-k2
ach1		oscil	k2,k1,31,p8

outs arevout1*(ach1+k3), arevout1*(k2-ach1+k3)


ga1 = 0
endin


