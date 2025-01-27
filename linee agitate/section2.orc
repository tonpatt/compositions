;;; For license information, see the README.md file

;;; Csound Orchestra for "line agitate (1994)"
;;; Gianantonio Patella -- Rev. January 2025

sr		=	44100
kr		=	4410
nchnls	=	2

ga1	init	0
ga2	init	0

; Table synthesis tool with two oscillators for
; flanging effect, with vibrato done with randi.
instr	1
	k2	randi	p5*.006,1,-1
	k3	randi	p5*.006,2.01,-1
	a1	oscili	p4*.5,p5+k2,p6
	a2	oscili	p4*.5,1+p5+k3,p6
	a3	linen	a1+a2,p9,p3,p10
	kseg	line	p7,p3,p8
	kch1	=	sin(kseg/2)
	kch2	=	sin((1-kseg)/2)
	ach1	=	a3*kch1
	ach2	=	a3*kch2
	outs	ach1,ach2
	ga1	=	ga1+ach1
	ga2	=	ga2+ach2
endin

instr 99

irevfactor		= p4
ilowpass		= 9000
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


acomb1  comb 	ga1, icsc1, idel1
acomb2  comb 	ga1, icsc2, idel2
acomb3  comb 	ga1, icsc3, idel3
acomb4  comb 	ga1, icsc4, idel4
acomb5  comb 	ga1, icsc5, idel5
acomb6  comb 	ga1, icsc6, idel6

acomball = acomb1 + acomb2 + acomb3 + acomb4 + acomb5 + acomb6

allp1 		alpass 	acomball, icsc7, idel7
allp2		alpass 	allp1, icsc7, idel8
allp3		alpass	allp2, icsc7, idel9
alow		tone		allp3, ilowpass
allp4		alpass	alow, icsc7, idel10
allp5		alpass	allp4, icsc7, idel12
arevout1	=  allp5 * ioutputscale



acomb1  comb 	ga2, icsc1, idel1
acomb2  comb 	ga2, icsc2, idel2
acomb3  comb 	ga2, icsc3, idel3
acomb4  comb 	ga2, icsc4, idel4
acomb5  comb 	ga2, icsc5, idel5
acomb6  comb 	ga2, icsc6, idel6

acomball = acomb1 + acomb2 + acomb3 + acomb4 + acomb5 + acomb6

allp1 	alpass 	acomball, icsc7, idel7
allp2		alpass 	allp1, icsc7, idel8
allp3		alpass	allp2, icsc7, idel9
alow		tone		allp3, ilowpass
allp4		alpass	alow, icsc7, idel10
allp6		alpass	allp4,icsc7, idel13
arevout2	=  allp6 * ioutputscale

outs arevout1, arevout2


ga1 = 0
ga2 = 0
endin
