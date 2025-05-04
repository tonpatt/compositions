
;;; For license information, see the README.md file

;;; Csound Orchestra for "onde + cric2"
;;; Gianantonio Patella -- 1995 / Rev. 2025

sr      =       44100
kr      =       4410
ksmps   =       10
nchnls  =       2
0dbfs   =       8600

giGain11 init   0.75
gipi2    init   $M_PI/2

instr   11
        iamp    =       ampdb(p4)
		iVcoStrt=       p5
		iVcoEnd =       p6
		iatk	=		p7
		idec    =       p8
		ich1	=		p9
		idfr	= 		p10 / 100
		ifrq    =       p11
		ifn     = 		p12
        kfr     line    iVcoStrt, p3, iVcoEnd
        adev    oscili  ifrq * idfr, kfr, 1, 0
        aosc    oscili  iamp, ifrq + adev, ifn
        aud     linen   aosc * giGain11, iatk, p3, idec
        ich1    =       sin(ich1 * gipi2 + gipi2)
        ich2    =       sin(ich1 * gipi2)
        outs    aud * ich1 ,aud * ich2
endin

giStart init     0
giEnd   init     1

instr	1
	ga1	rand	p4
endin

instr	2
	iamp 	= p4
	ipch    = p5
	ibw		= p6
	ifnEnv	= p7
	iatk	= p8
	idec	= p9
	ka11z	oscil1i	0, iamp, p3, ifnEnv
	ifrq    = cpspch(ipch)
	a1		reson ga1 * ka11z, ifrq, ifrq * ibw, 2
	a2		linen a1, iatk, p3, idec
	kch1	line giStart, p3, giEnd
	aL, aR  pan2 a2, kch1
	outs	aL, aR
	giStart = (giStart == 0? 1: 0)
	giEnd 	= (giEnd == 0? 1: 0)
endin

instr	3
	iamp	=	p4
	irnd1	=	p5
	irnd2	=	p6
	irnd3	=	p7
	imin	=	p8
	imax	=	p9
	idev	=	imin-imax
	ibw	    =	p10
	ifdb	=	p11
	irvt1   =   p12
	ilpt1   = 	p13
	irvt2   =   p14
	ilpt2   = 	p15
	ifosc   =   p16
	ihtim   =   p17
	idec    =   p18
	ihzCh1	=   p19
	asnd	randh	iamp,irnd1,-1
	kfil1	randh	idev,irnd2,-1
	kfil1	=		abs(kfil1) + imin
	kfil1	port	kfil1, ihtim
	kfil2	randh	idev,irnd3,-1
	kfil2	=		abs(kfil2) + imin
	kfil2	port	kfil2, ihtim
	a4		init	0
	a5		init	0
	a6		oscil	1, ifosc, 1
	a1		reson	asnd + a4 * ifdb * a6,kfil1, kfil1 * ibw, 2
	a2		reson	asnd - a5 * ifdb *(1 - a6), kfil2, kfil2 * ibw, 2
	a4		alpass	a1, irvt1, ilpt1
	a5		alpass	a1, irvt2, ilpt2
	a3		atone	a1 + a2, 200
	asig	= 		linen(dcblock(a3 * a6), .01, p3, idec)
	kch1    randi 	0.5, ihzCh1
	kch1    += 		0.5
	aL, aR  pan2 asig, kch1
	outs aL, aR
endin
