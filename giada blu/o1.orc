;;; For license information,  see the README.md file

;;; Csound Orchestra for "giada blu"
;;; Gianantonio Patella ---  1995 (rev. February 2025)

sr      = 44100
kr      = 4100
nchnls  = 2

ga1     init    0
ga2     init    0
ga3     init    0

instr   2
	iamp    = ampdb(p6)
	ifr     = cpspch(p5)
	iperc   = p7/100
	iform1  = p8
	igr1    = p9
	ifn1    = p10
	iform2  = p11
	igr2    = p12
	ifn2    = p13
	iatt    = p14
	idec    = p15
	ich1    = p16
	kbw1    randi   0.333,  0.333,  1
	kbw1    = (kbw1 + 0.664) * iform1
	kbw2    randi   0.333,  0.4,  1
	kbw2    = (kbw2 + 0.664) * iform2
	kgr1    randi   0.25,  0.67,  - 1
	kgr1    = (kgr1 + 0.75) * igr1
	kgr2    randi   0.25,  0.1, - 1
	kgr2    = (kgr2 + 0.75) * igr2
	ktr     randi   6,  3, - 1
	ktrem   oscil   0.15,  8 + ktr,  1
	ktrem   = (ktrem + 0.85) * iamp
	a1      fof   ktrem * iperc,  ifr,  iform1,  0,  kbw1,  kgr1 * 0.3,  kgr1,  kgr1 *.3,  12,  ifn1,  2,  p3
	a2      fof   ktrem *(1 - iperc),  ifr * 0.5,  iform2,  0,  kbw2,  kgr2 * 0.2,  kgr2,  kgr2 * 0.3,  12,  ifn2,  2,  p3
	a3      linen   a1 + a2,  iatt,  p3,  idec
  	a1za  	= a3 * ich1
  	a1zb  	= a3 * (1 - ich1)
	outs	a1za,  a1zb
	ga1 	= ga1 + a1za
	ga2 	= ga1 + a1zb
endin

instr   3
	ifr     = cpspch(p5)
	iamp    = ampdb(p6)
	iprvamp = ampdb(p7)
	ich1    = p8
	ibw     = 0.004
	iseg1   = (p3 / 6> 0.03? p3 / 6: 0.03)
	iseg3   = iseg1
	iseg2   = p3 - iseg1 - iseg3
	iamp2   = iamp
	if      p4!=0   igoto   giu1
	iamp1   = 0
	iamp3   = 0
		igoto   last
giu1:   if      p4!=1   igoto   giu2
	iamp1   = 0
	iamp3   = iamp/4
		igoto   last
giu2:   if      p4!=2   igoto   giu3
	iamp1   = iprvamp/4
	iamp3   = 0
		igoto   last
giu3:   if      p4!=2   igoto   last
	iamp1   = iprvamp/4
	iamp3   = iamp/4
last:
	a1      = ga1
	a2      reson   a1,  ifr,  ifr * ibw,  0,  - 1
	a3      reson   a2,  ifr,  ifr * ibw,  0,  - 1
	a4      balance  a3,  a1
	k1      linseg  iamp1,  iseg1,  iamp2,  iseg2,  iamp2,  iseg3,  iamp3
	a5      = dcblock(a4) * k1
  	a3za  	= a5 * ich1
  	a3zb  	= a5 * (1 - ich1)
	outs	a3za,  a3zb
	ga1 	= ga1 + a3za
	ga2 	= ga1 + a3zb
endin

instr   4
	ifr     = cpspch(p5)
	iamp    = ampdb(p6)
	ifr2    = cpspch(p7)
	iatt    = p8
	idec    = p9
	ifn     = int(p10)
	ich1    = frac(p10)
	k1      expon   ifr,  p3,  ifr2
	a1      oscili  iamp,  k1,  ifn
	a2      linen   a1,  iatt,  p3,  idec
  	a5za  	= a2 * ich1
  	a5zb  	= a2 * (1 - ich1)
	outs	a5za,  a5zb
	ga1 	= ga1 + a5za
	ga2 	= ga1 + a5zb
endin

; stopped strings
instr   5
	ich1    = p9
	ifr     = cpspch(p5)
	k1      expon   ampdb(p6),  p3,  1
	a1      pluck   k1,  ifr,  ifr,  0,  3,  p7
	a2      tone    a1,  p8
	  outs	a2 * ich1,  a2 * (1 - ich1)
	ga3 	= ga3 + a2
endin

instr   6
; p5	pch
; p6	amp/db
; p7	ch1
	ifr     = cpspch(p5)
	ifr2    = ifr * 2 + 0.5
	ifr3    = ifr/2 - 0.5
	iamp    = ampdb(p6)
	ich1    = p7
	ap1     pluck   iamp,  ifr,  ifr,  0,  1
	ap2     pluck   iamp,  ifr2,  ifr2,  0,  1
	ap3     pluck   iamp,  ifr3,  ifr3,  0,  1
	k1      line    0,  p3,  1
	k2      linseg  0,  p3/2,  1,  p3/2,  0
	a3      tone    ap3 * k1 + ap2 * (1 - k1) + ap1 * k2,  1900
	a4      linen   a3,  0.002,  p3,  0.03
  	a9za  	= a4 * ich1
  	a9zb  	= a4 * (1 - ich1)
	outs	a9za,  a9zb
	ga1 	= ga1 + a9za
	ga2 	= ga1 + a9zb
endin

instr   7
	ifr     = cpspch(p5)
	ifr2    = ifr * 2 + 0.5
	iamp    = ampdb(p6)
	ich1    = p7
	a1      pluck   iamp * 0.666,  ifr,  ifr,  0,  3,  0.001
	a2      pluck   iamp * 0.334,  ifr2,  ifr2,  0,  1
	a3      tone    a1 + a2,  1800
	a4      linen   a3,  0.002,  p3,  0.03
  	a11za  	= a4 * ich1
  	a11zb  	= a4 * (1 - ich1)
	outs	a11za,  a11zb
	ga1 	= ga1 + a11za
	ga2 	= ga1 + a11zb
endin

; flute n. 2
instr   8,  28
	iamp    = ampdb(p6)
	ifr     = cpspch(p5)
	iform   = ifr * p7
	iband   = iform * p8
	igr     = p9
	igratt  = igr * p10
	igrdec  = igr * p11
	ioct    = p12
	iatt    = p13
	idec    = p14
	ich1    = p16
	kamp    oscili  1,  1/p3,  p15
	a1      fof   iamp * kamp,  ifr,  iform,  ioct,  iband * kamp,  igratt,  igr,  igrdec,  10,  1,  2,  p3
	a3      linen   a1,  iatt,  p3,  idec
  	a13za  	= a3 * ich1
  	a13zb  	= a3 * (1 - ich1)
	outs	a13za,  a13zb
	ga1 	= ga1 + a13za
	ga2 	= ga1 + a13zb
endin

; flute n. 3
instr   9
	iamp    = ampdb(p6)
	ifr     = cpspch(p5)
	iatt    = p7
	idec    = p8
	ifn     = int(p9)
	ivel    = frac(p9) * 100
	isine   = 1
	iprf    = p10
	ipvib   = int(p12)
	ivvib   = frac(p12) * 100
	ich1    = p13
	avib    randi   ipvib/1000 * ifr,  ivvib,  - 1
	arnd    randi   iamp * iprf,  ivel,  - 1
	a2      linen   0.4999,  iatt,  p3,  idec
	a1      oscili   a2,  ifr + avib,  isine
	a3      tablei  a1,  ifn,  1,  0.5
	a4      = a3 * iamp - abs(arnd)
	a5      tone    a4,  p11
	a6      linen   a4,  iatt * 0.5,  p3,  idec * 0.5
  	a15za  	= a6 * ich1
  	a15zb  	= a6 * (1 - ich1)
	outs	a15za,  a15zb
	ga1 	= ga1 + a15za
	ga2 	= ga1 + a15zb
endin


instr   10
	iamp    = ampdb(p6)
	imol    = p8
	ifr     = cpspch(p5) * imol
	ifn     = int(p9)
	ivel    = frac(p9) * 100
	isine   = 1
	iprf    = p10
	ipvib   = int(p12)
	ivvib   = frac(p12) * 100
	idur    = (p3<10?10:p3)
	ifna    = p7
	ich1    = p13
	avib    randi   ipvib/1000 * ifr,  ivvib,  - 1
	arnd    randi   iamp * iprf,  ivel,  - 1
	a2      oscili  0.4999,  1/idur,  ifna
	a1      oscili   a2,  ifr + avib,  isine
	a3      tablei  a1,  ifn,  1,  0.5
	a4      = a3 * iamp - abs(arnd)
	k2      downsamp a2
	a5      tone    a4,  k2 * p11 * 2
	a6      linen   a5,  0.001,  p3,  0.01
  	a17za  	= a6 * ich1
  	a17zb  	= a6 * (1 - ich1)
	outs	a17za,  a17zb
	ga1 	= ga1 + a17za
	ga2 	= ga1 + a17zb
endin


instr   51
; p4	att. time
; p5	dec. time
; p6	gain ch1
; p7	rvt  ch1
; p8	hdif
; p9	gain ch2
; p10	rvt  ch2
	a1      reverb2  ga1 * p6,  p7,  p8
	al	linen	1,  p4,  p3,  p5
	a2      reverb2  ga2 * p9,  p10,  p8
  	outs    a1 * al,  a2 * al
endin

instr   52
	a1      alpass  ga2 * p4,  p5,  p6
	  kch1  randi   1,  p7,  - 1
	  kch1  = abs(kch1)
	  kch2  = 1 - kch1
	  outs    a1 * kch1,  a1 * kch2
endin

instr   53
	imin    = p7/1000
	imax    = p8/1000
	adel    randi   imax - imin,  p6,  - 1
	adel    = imin + abs(adel)
	kamp    randi   p4,  p10,  - 1
	a11z	delayr  imax
	a1	init	0
	a1	deltapi adel
		delayw  ga1 * kamp + a1 * p5
	a2      delay   a1,  p9
	kch1  randi   1,  p6,  - 1
	kch1  = abs(kch1)
	kch2  = 1 - kch1
	outs    a1 * kch1,  a2 * kch2
endin

instr   54
; p4	gain
; p5	frq. filter cut
; p6	rev time
; P7 	Attack
; P8 	decay
; p9	delay comb
	a1	tone   	ga3 * p4,  p5
	a2	reverb 	a1,  p6
	al	linen	1,  p7,  p3,  p8
	a3	comb   a2,  p6,  p9
	outs	(a3 - a2) * 0.5 * al,  a3 * al
endin

; Tools with Delay Line Network: Three Delay Line with delays
; variable by means of randy units. Ther. 31 is used for
; channel 1 while the rib. 32 is used for channel 2.
instr   31
	a1      init    0
	a2      init    0
	a3      init    0
	a0      = ga1 * p4
	admy1   delayr  p14 * 1.1
	ar1     randi   p17,  p20
	a1      deltapi p14 - abs(ar1)
			delayw  a0 + a1 * p5 + a2 * p6 + a3 * p7
	admy2   delayr  p15 * 1.1
	ar2     randi   p18,  p21
	a2      deltapi p15 - abs(ar2)
			delayw  a0 + a1 * p8 + a2 * p9 + a3 * p10
	admy3   delayr  p16 * 1.1
	ar3     randi   p19,  p22
	a3      deltapi p16 - abs(ar3)
			delayw  a0 + a1 * p11 + a2 * p12 + a3 * p13
	al      linen   1,  p23,  p3,  p24
	outs1   (a1 + a2 + a3) * al
endin

instr   32
	a1      init    0
	a2      init    0
	a3      init    0
	a0      = ga2 * p4
	admy1   delayr  p14 * 1.1
	ar1     randi   p17,  p20
	a1      deltapi p14 - abs(ar1)
			delayw  a0 + a1 * p5 + a2 * p6 + a3 * p7
	admy2   delayr  p15 * 1.1
	ar2     randi   p18,  p21
	a2      deltapi p15 - abs(ar2)
			delayw  a0 + a1 * p8 + a2 * p9 + a3 * p10
	admy3   delayr  p16 * 1.1
	ar3     randi   p19,  p22
	a3      deltapi p16 - abs(ar3)
			delayw  a0 + a1 * p11 + a2 * p12 + a3 * p13
	al      linen   1,  p23,  p3,  p24
	outs2   (a1 + a2 + a3) * al
endin

instr   33
	af1      init    0
	af2      init    0
	af3      init    0
	kgain	oscili	1,  1/p3,  p4,  0
	a0      = ga1 * kgain
	admy1   delayr  p14 * 1.1
	ar1     randi   p17,  p20
	a1      deltapi p14 - abs(ar1)
	af1	tone	a1,  p25
			delayw  a0 + af1 * p5 + af2 * p6 + af3 * p7
	admy2   delayr  p15 * 1.1
	ar2     randi   p18,  p21
	a2      deltapi p15 - abs(ar2)
	af2	tone	a2,  p25
			delayw  a0 + af1 * p8 + af2 * p9 + af3 * p10
	admy3   delayr  p16 * 1.1
	ar3     randi   p19,  p22
	a3      deltapi p16 - abs(ar3)
	af3	tone	a3,  p25
			delayw  a0 + af1 * p11 + af2 * p12 + af3 * p13
	al      linen   1,  p23,  p3,  p24
	outs1   (a1 + a2 + a3) * al
endin

instr   34
	af1      init    0
	af2      init    0
	af3      init    0
	kgain	oscili	1,  1/p3,  p4,  0
	a0      = ga2 * kgain
	admy1   delayr  p14 * 1.1
	ar1     randi   p17,  p20
	a1      deltapi p14 - abs(ar1)
	af1	tone	a1,  p25
			delayw  a0 + af1 * p5 + af2 * p6 + af3 * p7
	admy2   delayr  p15 * 1.1
	ar2     randi   p18,  p21
	a2      deltapi p15 - abs(ar2)
	af2	tone	a2,  p25
			delayw  a0 + af1 * p8 + af2 * p9 + af3 * p10
	admy3   delayr  p16 * 1.1
	ar3     randi   p19,  p22
	a3      deltapi p16 - abs(ar3)
	af3	tone	a3,  p25
			delayw  a0 + af1 * p11 + af2 * p12 + af3 * p13
	al      linen   1,  p23,  p3,  p24
	outs2   (a1 + a2 + a3) * al
endin

instr	100
	ga1	= 0
	ga2	= 0
	ga3	= 0
endin
