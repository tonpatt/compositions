;;; For license information, see the README.md file

;;; Csound Orchestra for "line agitate (1994)"
;;; Gianantonio Patella -- Rev. January 2025

sr		=	44100
kr		=	4410
nchnls	=	2

instr   1
        a1,a2   soundin "section1.flac",0
        a3      linen   p4,p5,p3,p6
        outs    a1*a3,a2*a3
endin

instr   2
        a1,a2   soundin "section2.flac",0
        a3      linen   p4,p5,p3,p6
        outs    a1*a3,a2*a3
endin

instr   3
        a1,a2   soundin "section3.flac",0
        a3      linen   p4,p5,p3,p6
        outs    a1*a3,a2*a3
endin

instr   4
        a1,a2   soundin "section1.flac",p7
        a1b,a2b soundin "section2.flac",0
        a3      linen   p4,p5,p3,p6
        a3r     randi   a3,p8
        a3r     =       abs(a3r)
        outs    a1*a3r+a1b*(1-a3r),a2*a3r+a2b*(1-a3r)
endin

instr   5
        a1,a2   soundin "section2.flac",p7
        a1b,a2b soundin "section3.flac",0
        a3      linen   p4,p5,p3,p6
        a3r     randi   1,p8
        a3r     =       abs(a3r)
        outs    (a1*a3r+a1b*(1-a3r))*a3,(a2*a3r+a2b*(1-a3r))*a3
endin

