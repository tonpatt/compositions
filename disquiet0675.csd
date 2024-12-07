<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>

;;; For license information, see the README.md file

;;; Csound Orchestra for "a cohered front - disquiet0675"
;;; Gianantonio Patella -- December 2024

sr      =   44100
kr      =   4410
0dbfs   =   1
nchnls  =   2

zakinit 1, 1

opcode seg3,k,iiiii
    ; 3-segment envelope
    ; iamp   :  amplitude
    ; iatk   :  attack time
    ; idur   :  duration
    ; ilev   :  level at decay
    ; idec   :  decay time
    iamp,iatk,idur,ilev,idec xin
    kenv  linseg 0, iatk, iamp,idur - iatk - idec, ilev * iamp, idec, 0
    xout kenv
endop

opcode fadeout,a,io
    ; idur   :  duration
    ; idec   :  decay time (default = 0.01)
    idur, idec xin
    idec = (idec == 0? 0.01: idec)
    aenv linseg 1, idur - idec, 1, idec, 0
    xout aenv
endop

opcode frq,i,i
    ; ifreq  :  frequency in pch or in hz if < 0
    ifreq xin
    xout (ifreq < 0? -ifreq: cpspch(ifreq))
endop

; 3 oscillators with random vibrato
instr tab3o
    iamp    = ampdb(p4)/3          ; amp in Db
    icps    = frq(p5)              ; freq in in pch or in Hz if < 0
    iatk    = p6                   ; attack time
    ilev    = (p7 == 0? .7: p7)    ; level at decay
    idec    = p8                   ; decay time
    ifn     = p9                   ; audio function
    ivdep = (p10 == 0 ? 1.7 : p10) ; vibrato deviation in Hz
    ivmin = (p11 == 0 ? 4 : p11)   ; min speed in Hz of the vibrato
    ivmax = (p12 == 0 ? 9 : p12)   ; max speed in Hz of the vibrato
    ibus    = p13                  ; output bus

    kspl    jspline icps * ivdep / 1000, ivmin, ivmax
    kenv    seg3    iamp, iatk, p3, ilev, idec
    aosc1   oscili  kenv, icps + kspl, ifn
    aosc2   oscili  kenv, icps - kspl, ifn
    ksweep  line    icps * 1.001, p3, icps
    aosc3   oscili  kenv, ksweep, ifn
    zawm    (aosc1+aosc2+aosc3) * fadeout(p3), ibus
endin

; delay with 2 combs and cross feedback
; adapted for the track
instr comb
    ibus = p4               ; input bus
    iGain  = p5             ; gain
    irvt1  = p6             ; comb1 reverb time
    ilpt1  = p7             ; comb1 loop time
    irvt2  = p8             ; comb2 reverb time
    ilpt2  = p9             ; comb2 loop time
    imixWet  = p10          ; wet signal  0 <= gain <= 1
    imixDry  = 1 - imixWet
    ifdb   = p11            ; cross feedback

    asig   zar ibus
    asig   *=  iGain
    acmbR  init 0
    acmbL  init 0

    kdep   linseg 0.1, p3/2, .25, p3/2, 0.1
    kvep   linseg 0.1, p3/2, 1, p3/2, 0.1
    kpan   randi kdep, kvep
    aL, aR pan2 asig, kpan + 0.5
    ktri   expseg 150, p3/2, 1900, p3/2, 150
    krnd1  randh ktri, .43
    krnd2  randh ktri, .49
    acmbL  comb aL + oscil(acmbR, krnd1) * ifdb, irvt1, ilpt1
    acmbR  comb aR + oscil(acmbL, krnd2) * ifdb, irvt2, ilpt2

    outs1 (aL * imixDry + acmbL * imixWet) * fadeout(p3, 0.5)
    outs2 (aR * imixDry + acmbR * imixWet) * fadeout(p3, 0.5)
    zacl ibus
endin

</CsInstruments>

<CsScore>
;;; Csound Score for "a cohered front - disquiet0675"
;;; Gianantonio Patella -- December 2024

t0 40

#define MRATIO #1.5#

f1 0 512 7 0 106 1 300 -1 106 0
; f2 0 512 7 1 256 1 0 -1 256 -1
f3 0 512 10 1 .05 -.1 -.15 0 .05 0 0 .02 0 0 -.01
f4 0 512 10 1 .05 .01 -.02 0 .003
; f5 0 512 10 .5 -1 .05 .01 -.05 0 0 0 -.023
f6 0 512 7 0 30 1 176 1 100 -1 186 -1 20 0

;              bus gain rvt1 lpt1
;                       rvt2 lpt2                wet   fdb
i "comb" 0 144 0   1.7  30   [ 3/2 * $MRATIO ]
                        30   [ 5/2 * $MRATIO ]   0.04  0.35


i "tab3o" 0 7.975 -6 6.01 2 .8 1 3 0 0 0 0
i "tab3o" 7.25 3.850 -12 6.011 2 .8 1 3 0 0 0 0
i "tab3o" 10.75 3.575 -10 6.01 2 .8 1 3 0 0 0 0
i "tab3o" 14.0 4.400 -15 6.011 2 .8 1 3 0 0 0 0
i "tab3o" 18.0 4.950 -6 6.01 2 .8 1 3 0 0 0 0
i "tab3o" 22.5 3.850 -12 6.011 2 .8 1 3 0 0 0 0
i "tab3o" 26.0 7.975 -10 6.01 2 .8 1 3 0 0 0 0
i "tab3o" 33.25 3.850 -15 6.011 2 .8 1 3 0 0 0 0
i "tab3o" 36.75 3.575 -6 6.01 2 .8 1 3 0 0 0 0
i "tab3o" 40.0 4.400 -12 6.011 2 .8 1 3 0 0 0 0
i "tab3o" 44.0 4.950 -10 6.01 2 .8 1 3 0 0 0 0
i "tab3o" 48.5 3.850 -15 6.011 2 .8 1 3 0 0 0 0
i "tab3o" 52.0 7.975 -6 6.01 2 .8 1 3 0 0 0 0
i "tab3o" 59.25 3.850 -12 6.011 2 .8 1 3 0 0 0 0
i "tab3o" 62.75 3.575 -10 6.01 2 .8 1 3 0 0 0 0
i "tab3o" 66.0 4.400 -15 6.011 2 .8 1 3 0 0 0 0
i "tab3o" 72.0 4.950 -6 6.01 2 .8 1 3 0 0 0 0
i "tab3o" 76.5 3.850 -12 6.011 2 .8 1 3 0 0 0 0
i "tab3o" 80.0 7.975 -10 6.01 2 .8 1 3 0 0 0 0
i "tab3o" 87.25 3.850 -15 6.011 2 .8 1 3 0 0 0 0
i "tab3o" 90.75 3.575 -6 6.01 2 .8 1 3 0 0 0 0
i "tab3o" 94.0 4.400 -12 6.011 2 .8 1 3 0 0 0 0
i "tab3o" 98.0 4.950 -10 6.01 2 .8 1 3 0 0 0 0
i "tab3o" 102.5 3.850 -15 6.011 2 .8 1 3 0 0 0 0
i "tab3o" 106.0 7.975 -6 6.01 2 .8 1 3 0 0 0 0
i "tab3o" 113.25 3.850 -12 6.011 2 .8 1 3 0 0 0 0
i "tab3o" 116.75 3.575 -10 6.01 2 .8 1 3 0 0 0 0
i "tab3o" 120.0 4.400 -15 6.011 2 .8 1 3 0 0 0 0
i "tab3o" 124.0 4.950 -6 6.01 2 .8 1 3 0 0 0 0
i "tab3o" 128.5 3.850 -12 6.011 2 .8 1 3 0 0 0 0
i "tab3o" 132.0 7.975 -10 6.01 2 .8 1 3 0 0 0 0
i "tab3o" 139.25 3.850 -15 6.011 2 .8 1 3 0 0 0 0
i "tab3o" 15 3.375 -27 9.11 1 .8 1 1 0 0 0 0
i "tab3o" 19.0 3.375 -32 9.112 1 .8 1 1 0 0 0 0
i "tab3o" 23.0 3.375 -27 9.11 1 .8 1 1 0 0 0 0
i "tab3o" 27.0 3.375 -32 9.112 1 .8 1 1 0 0 0 0
i "tab3o" 31.0 3.375 -27 9.11 1 .8 1 1 0 0 0 0
i "tab3o" 35.0 3.375 -32 9.112 1 .8 1 1 0 0 0 0
i "tab3o" 39.0 3.375 -27 9.11 1 .8 1 1 0 0 0 0
i "tab3o" 43.0 3.375 -32 9.112 1 .8 1 1 0 0 0 0
i "tab3o" 47.0 3.375 -27 9.11 1 .8 1 1 0 0 0 0
i "tab3o" 51.0 3.375 -32 9.112 1 .8 1 1 0 0 0 0
i "tab3o" 55.0 3.375 -27 9.11 1 .8 1 1 0 0 0 0
i "tab3o" 59.0 3.375 -32 9.112 1 .8 1 1 0 0 0 0
i "tab3o" 63.0 3.375 -27 9.11 1 .8 1 1 0 0 0 0
i "tab3o" 67.0 3.375 -32 9.112 1 .8 1 1 0 0 0 0
i "tab3o" 73.0 3.375 -27 9.11 1 .8 1 1 0 0 0 0
i "tab3o" 77.0 3.375 -32 9.112 1 .8 1 1 0 0 0 0
i "tab3o" 81.0 3.375 -27 9.11 1 .8 1 1 0 0 0 0
i "tab3o" 85.0 3.375 -32 9.112 1 .8 1 1 0 0 0 0
i "tab3o" 89.0 3.375 -27 9.11 1 .8 1 1 0 0 0 0
i "tab3o" 93.0 3.375 -32 9.112 1 .8 1 1 0 0 0 0
i "tab3o" 97.0 3.375 -27 9.11 1 .8 1 1 0 0 0 0
i "tab3o" 101.0 3.375 -32 9.112 1 .8 1 1 0 0 0 0
i "tab3o" 105.0 3.375 -27 9.11 1 .8 1 1 0 0 0 0
i "tab3o" 109.0 3.375 -32 9.112 1 .8 1 1 0 0 0 0
i "tab3o" 113.0 3.375 -27 9.11 1 .8 1 1 0 0 0 0
i "tab3o" 30 7.200 -10 5.01 .05 .8 2 6 0 0 0 0
i "tab3o" 37.25 7.200 -18 5.011 .05 .8 2 6 0 0 0 0
i "tab3o" 44.5 7.200 -10 5.01 .05 .8 2 6 0 0 0 0
i "tab3o" 51.75 7.200 -18 5.011 .05 .8 2 6 0 0 0 0
i "tab3o" 59.0 7.200 -10 5.01 .05 .8 2 6 0 0 0 0
i "tab3o" 66.25 7.200 -18 5.011 .05 .8 2 6 0 0 0 0
i "tab3o" 75.5 7.200 -10 5.01 .05 .8 2 6 0 0 0 0
i "tab3o" 82.75 7.200 -18 5.011 .05 .8 2 6 0 0 0 0
i "tab3o" 90.0 7.200 -10 5.01 .05 .8 2 6 0 0 0 0
i "tab3o" 97.25 7.200 -18 5.011 .05 .8 2 6 0 0 0 0
i "tab3o" 104.5 7.200 -10 5.01 .05 .8 2 6 0 0 0 0
i "tab3o" 111.75 7.200 -18 5.011 .05 .8 2 6 0 0 0 0
i "tab3o" 45 5.750 -15 7.01 .01 .8 1 4 0 0 0 0
i "tab3o" 50.75 2.250 -22 7.011 .01 .8 1 4 0 0 0 0
i "tab3o" 55.25 5.750 -15 7.01 .01 .8 1 4 0 0 0 0
i "tab3o" 61.0 2.250 -22 7.011 .01 .8 1 4 0 0 0 0
i "tab3o" 65.5 5.750 -15 7.01 .01 .8 1 4 0 0 0 0
i "tab3o" 73.25 2.250 -22 7.011 .01 .8 1 4 0 0 0 0
i "tab3o" 77.75 5.750 -15 7.01 .01 .8 1 4 0 0 0 0
i "tab3o" 83.5 2.250 -22 7.011 .01 .8 1 4 0 0 0 0
i "tab3o" 88.0 5.750 -15 7.01 .01 .8 1 4 0 0 0 0
i "tab3o" 93.75 2.250 -22 7.011 .01 .8 1 4 0 0 0 0
i "tab3o" 98.25 5.750 -15 7.01 .01 .8 1 4 0 0 0 0
i "tab3o" 104.0 2.250 -22 7.011 .01 .8 1 4 0 0 0 0
e

</CsScore>
</CsoundSynthesizer>


