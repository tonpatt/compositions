;;; For license information,  see the README.md file

;;; Csound Orchestra for "giada blu"
;;; Gianantonio Patella -- 1995 (rev. February 2025)

sr      = 44100
kr      = 4410
ksmps   = 10
nchnls  = 2

gidmol1 = 32767
gidmol2 = 1 / gidmol1


instr   1
        iamp    = ampdb(p8)
        iatt    = p9
        idec    = p10
        icicli  = p6
        ifunz   = p7
        idelay  = p5
        istart  = p4
        idist   = p11
        ifilt   = p12

        a1      soundin "s3.wav", istart
        if      idist == 0 goto del
        a1      table   a1 * gidmol2, idist, 1, 0.5
        a1      = a1 * gidmol1
del:
        a2      delay  a1, idelay
        if      int(p7 + 0.00001) == 2 goto rnh
        kch1    randi   1, icicli
        kch1    = abs(kch1)
        goto    giu
rnh:
        ihpt    = frac(p7)
        kch1    randh   1, icicli
        kch1    port    abs(kch1), ihpt
giu:
        kch2    = 1-abs(kch1)
        k4      linen   iamp, iatt, p3, idec
        outs    (a1 * kch1 + a2 * kch2) * k4, (a1 * kch2 + a2 * kch1) * k4
endin

instr   2, 3
        iamp    = ampdb(p8)
        iatt    = p9
        idec    = p10
        icicli  = p6
        ifunz   = p7
        idelay  = p5
        istart  = p4
        idist   = p11
        ifilt   = p12
        if      p1!=2   igoto   ins3
        ia1a    = 1
        ia2a    = 0.85
        ia3a    = 0.35
        ia4a    = 0
        ia1b    = 0
        ia2b    = 0.35
        ia3b    = 0.85
        ia4b    = 1
                igoto   perf
ins3:
        ia1a    = 0
        ia2a    = 0.35
        ia3a    = 0.85
        ia4a    = 1
        ia1b    = 1
        ia2b    = 0.85
        ia3b    = 0.35
        ia4b    = 0
perf:
        a1      soundin "s3.wav", istart
        if      idist == 0 goto del
        a1      table   a1 * gidmol2, idist, 1, 0.5
        a1      = a1 * gidmol1
del:
        a2      delay  a1 * 0.5, idelay
        a3      delay  a2 * 0.5, idelay / 2
        a4      delay  a3 * 0.5, idelay / 4

        k4      linen   iamp, iatt, p3, idec
        outs1   (a1 * ia1a + a2 * ia2a + a3 * ia3a + a4 * ia4a) * k4
        outs2   (a1 * ia1b + a2 * ia2b + a3 * ia3b + a4 * ia4b) * k4

end: endin

instr   4, 5, 6, 7
        iamp    = ampdb(p8)
        iatt    = p9
        idec    = p10
        icicli  = p6
        ibw     = p7
        idelay  = p5
        istart  = p4
        idist   = p11
        ifilt   = p12
        if      p1!=5 igoto ins5
        ia1a    = 1
        ia2a    = 0.85
        ia3a    = 0.35
        ia4a    = 0
        ia1b    = 0
        ia2b    = 0.35
        ia3b    = 0.85
        ia4b    = 1
                igoto perf
ins5:
        if      p1!=5   igoto   ins6
        ia1a    = 0
        ia2a    = 0.35
        ia3a    = 0.85
        ia4a    = 1
        ia1b    = 1
        ia2b    = 0.85
        ia3b    = 0.35
        ia4b    = 0
                igoto   perf
ins6:
        if      p1!=6   igoto   ins7
        ia1a    = 1
        ia2a    = 1
        ia3a    = 1
        ia4a    = 1
        ia1b    = 0
        ia2b    = 0.35
        ia3b    = 0.85
        ia4b    = 1
                igoto   perf
ins7:
        ia1a    = 0
        ia2a    = 0.35
        ia3a    = 0.85
        ia4a    = 1
        ia1b    = 1
        ia2b    = 1
        ia3b    = 1
        ia4b    = 1
perf:
        a1      soundin "s3.wav", istart
        if      idist == 0 goto del
        a1      table   a1 * gidmol2, idist, 1, 0.5
        a1      = a1 * gidmol1
del:
        a2      delay  a1 * 0.75, idelay
        a3      delay  a2 * 0.75, idelay / 2
        a4      delay  a3 * 0.75, idelay / 4

        k4      linen   iamp, iatt, p3, idec
        kcf     randi   ifilt * 0.49, icicli
        kcf1    = ifilt + kcf
        kcf2    = ifilt-kcf
        as1     butterbr   (a1 * ia1a + a2 * ia2a + a3 * ia3a + a4 * ia4a) * k4, kcf1, ibw
        as2     butterbr  (a1 * ia1b + a2 * ia2b + a3 * ia3b + a4 * ia4b) * k4, kcf2, ibw
        outs    as1, as2
end: endin
