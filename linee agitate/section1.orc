;;; For license information, see the README.md file

;;; Csound Orchestra for "line agitate (1994)"
;;; Gianantonio Patella -- Rev. January 2025

sr	=	44100
kr	=	4410
nchnls	=	2

ga1	init	0
ga2	init	0

instr	1
	k2	randi	p5*.009,1,-1
	k3	randi	p7,2.01,-1
	ires	=	1-p7
	k3	=	abs(k3)
	iamp	=	ampdb(p4)
	a1	oscili	iamp,p5+k2,p6
	a3	linen	a1,p8,p3,p9
	ach1	=	a3*k3+ires
	ach2	=	a3*(p7-k3)+ires
	outs	ach1,ach2
	ga1	=	ga1+ach1
	ga2	=	ga2+ach2
endin

instr	3
	k2	randi	p5*.006,1,-1
	k3	randi	p5*.006,2.01,-1
	k4	randi	p5*.0063,.34,-1
	iamp	=	ampdb(p4)/3
	a1	oscili	iamp,p5+k2,p6
	a2	oscili	iamp,1+p5+k3,p6
	a4	oscili	iamp,p5-.1+k4,p6
	a3	linen	a1+a2+a4,p8,p3,p9
	ich1	=	sin(p7/2)
	ich2	=	sin((1-p7)/2)
	ach1	=	a3*ich1
	ach2	=	a3*ich2
	outs	ach1,ach2
	ga1	=	ga1+ach1
	ga2	=	ga2+ach2
endin

instr	31
	a1	init	0
	a2	init	0
	a3	init	0
	a0	=	ga1*p4
	admy1	delayr	p14*1.1
	ar1	randi	p17,p20
	a1	deltapi	p14-abs(ar1)
		delayw	a0+a1*p5+a2*p6+a3*p7
	admy2	delayr	p15*1.1
	ar2	randi	p18,p21
	a2	deltapi	p15-abs(ar2)
		delayw	a0+a1*p8+a2*p9+a3*p10
	admy3	delayr	p16*1.1
	ar3	randi	p19,p22
	a3	deltapi	p16-abs(ar3)
		delayw	a0+a1*p11+a2*p12+a3*p13
	al	linen	1,.1,p3,.1
	outs1	(a1+a2+a3)*al
	ga1	=	0
endin

instr	32
	a1	init	0
	a2	init	0
	a3	init	0
	a0	=	ga2*p4
	admy1	delayr	p14*1.1
	ar1	randi	p17,p20
	a1	deltapi	p14-abs(ar1)
		delayw	a0+a1*p5+a2*p6+a3*p7
	admy2	delayr	p15*1.1
	ar2	randi	p18,p21
	a2	deltapi	p15-abs(ar2)
		delayw	a0+a1*p8+a2*p9+a3*p10
	admy3	delayr	p16*1.1
	ar3	randi	p19,p22
	a3	deltapi	p16-abs(ar3)
		delayw	a0+a1*p11+a2*p12+a3*p13
	al	linen	1,.1,p3,.1
	outs2	(a1+a2+a3)*al
	ga2	=	0
endin

