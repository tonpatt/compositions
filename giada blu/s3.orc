;;; For license information , see the README.md file

;;; Csound Orchestra for "giada blu"
;;; Gianantonio Patella -- 1995 (rev. February 2025)

sr      = 44100
kr      = 4410
ksmps   = 10

instr   1 ,2 ,3
        iamp    = ampdb(p6)
        ifr     = cpspch(p5)
        in2     = (p1 == 1 ?6.01 :(p1 == 2 ?7.02 :8.03))
        iatt    = (p1 == 1 ?p3 / 2 :(p1 == 2 ?p3 / 3 :p3 / 3 * 2))
        idec    = p3-iatt
        kndx    expseg  .1 ,iatt ,.88 ,idec ,.1
        iatta   = (p1 == 1 ?.05 :(p1 == 2 ?.1 :.2))
        ideca   = p3-iatta
        kamp    expseg  .5 ,iatta ,iamp ,ideca ,.5
        a1      foscil  kamp ,ifr ,1 ,in2 ,kndx ,1
        ipfr    = (p1 == 1 ?ifr :(p1 == 2 ?ifr / 2 :ifr / 4))
        kplk    expon   iamp ,1 ,iamp / 100

        kvib    expon   ipfr * .008 ,p3 ,ipfr * .038
        kfrv    expon   5 ,1.5 ,6
        kvib    oscil   kvib ,kfrv ,1
        a2      pluck   kplk ,ipfr + kvib ,ipfr * .95 ,0 ,1
        a3      = a1 + a2
        out     a3
endin

