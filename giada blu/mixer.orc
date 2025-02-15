;;; For license information, see the README.md file

;;; Csound Orchestra for "giada blu"
;;; Gianantonio Patella -- 1995 (rev. February 2025)

sr      =       44100
kr      =       4410
nchnls  =       2

giGain  init    2.95
ga1     init    0
ga2     init    0

instr   1
    ich1    = p5 * giGain
    ich2    = p6 * giGain
    a1,a2   soundin "s1.wav", p4
    a0      oscili  1, 1 / (p3 / p7), 1, 0
    outs    dcblock(a0 * a1) * ich1, dcblock(a0 * a2) * ich2
endin

instr   12
    a1,a2   soundin "s2.wav", p4
    a0      expseg  p7 / p8,  p5, p7, p3-p5-p6, p7,p6, p7/p8
    outs    a0 * a1 * giGain, a0 * a2 * giGain
endin

instr   13
    a1,a2   soundin "s3mix.wav",p4
    a0      expseg  p7 / p8, p5, p7, p3 - p5 - p6, p7, p6, p7 / p8
    ga1     = a0*a1*giGain
    ga2     = a0*a2*giGain
    outs    ga1,ga2
endin

instr   73
    ifc     = p8
    a0      linen p4, p6, p3 ,p7
    a1      tone ga1 * a0, ifc
    a2      tone ga2 * a0, ifc
    ar1     reverb  a1, p5
    ar2     reverb  a2, p5
    outs    ar1, ar2
endin

