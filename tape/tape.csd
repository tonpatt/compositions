<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>

;;; For license information, see the README.md file

;;; Csound Orchestra for "tape"
;;; Gianantonio Patella -- July 1996 (rev. December 2024)

sr      =       44100
kr      =       4410
ksmps   =       10
nchnls  =       2

gifac   init    1/32768

ga1     init    0
ga2a    init    0
ga2b    init    0
ga3     init    0
ga4     init    0

instr   1
        ;       p4      db
        ;       p5      pch
        ;       p6      n1
        ;       p7      n2
        ;       p8      imin
        ;       p9      imax
        ;       p10     % rnd ind.
        ;       p11     hz rnd ind.
        ;       p12     at ind
        ;       p13     dc ind
        ;       p14     % rnd amp
        ;       p15     hz rnd amp
        ;       p16     at amp
        ;       p17     dc amp
        ;       p18     % rnd fr
        ;       p19     hz rnd fr
        ;       p20     ch1
        ;       p21     fn
        kinvi   linen   p9-p8,p12,p3,p13
        krndi   randi   p9*p10,p11,-1
        kinvi   =       kinvi+krndi
        ifr     =       cpspch(p5)
        iamp    =       ampdb(p4)
        kfr     randi   ifr*p18,p19,-1
        afm     foscili 1,ifr+kfr,p6,p7,kinvi,p21
        arnda   randi   iamp*p14,p15,-1
        aenva   linen   iamp+arnda,p16,p3,p17
        aout    =       aenva*afm
        ga1     =       ga1+aout
                outs    aout*p20,aout*(1-p20)
endin

instr   3
        igain   =       p4
        icfmin  =       p5
        icfmed  =       p6
        icfmax  =       p7
        iseg1   =       p8
        iseg2   =       p9
        iq      =       p10
        ibw     =       1/iq
        ich1    =       p11
        ich2    =       1-p11
        iatt    =       p12
        idec    =       p13
        idetune =       p14

        kcf1    expseg  icfmin,iseg1,icfmed,iseg2,icfmax,p3-iseg2-iseg1,icfmin

        asig    =       ga1*igain
        asig    oscil   asig,idetune,1

        a1      reson   asig,kcf1,kcf1*ibw,1
        a5      linen   a1,iatt,p3,idec
                outs    a5*ich1,a5*ich2
        ga1     =       ga1+a5
endin

instr   5
        iamp    =       ampdb(p4)
        ifr     =       cpspch(p5)
        in1     =       p6
        in2     =       p7
        imin    =       p8
        imax    =       p9
        ipos    =       p10
        ich1    =       ipos
        ich2    =       1-ipos
        ifnamp  =       p11
        ifnind  =       p12
        icf0 =       p13

        kind    oscili  imax-imin,1/p3,ifnind
        kind    =       kind+imin
        kamp    oscili  iamp,1/p3,ifnamp
        aout    foscil  kamp,ifr,in1,in2,kind,1
        afil0   tone    aout,icf0
        afil    tone    afil0,icf0
        ach1    =         afil*ich1
        ach2    =     afil*ich2
                outs    ach1,ach2
        ga2a    =       ga2a+ach1
        ga2b    =       ga2b+ach2

endin

; FM instrument with double modulating, the peak deviation
; is not given by the modulating * index but by a base value (1200) for index.
; The instrument is filtered by a stereo flanger driven by a randi.
instr   6
        imodbase=       1200
        iamp    =       ampdb(p4)
        iport   =       cpspch(p5)
        imod1   =       iport*p6
        idev1   =       imodbase*p7
        ifni1   =       p8
        imod2   =       iport*p9
        idev2   =       imodbase*p10
        ifni2   =       p11
        ifnamp  =       p12
        ivel    =       p13
        imaxdel =       .006*(p14/100)

        kind1   oscili  idev1,1/p3,ifni1
        amod1   oscil   kind1,imod1,1,.25
        kind2   oscili  idev2,1/p3,ifni2
        amod2   oscil   kind2,imod2,1,.25
        kamp    oscili  iamp,1/p3,ifnamp
        ax      oscili  kamp,iport+amod1+amod2,1
        alnn    linen   1,.003,p3,.01
        alfo    randi   imaxdel,ivel,.5
        adel    =       abs(alfo)
        adump   delayr  imaxdel+2/kr
        av1     deltapi adel+1/kr
        av2     deltapi imaxdel-adel+1/kr
                delayw  ax
        outs1   (av1+ax)*alnn
        outs2   (av2+ax)*alnn

endin

instr   7
        iamp    =       ampdb(p4)
        ifr     =       cpspch(p5)
        in1     =       p6
        in2     =       p7
        imin    =       p8
        imax    =       p9
        ipos    =       p10
        ich1    =       ipos
        ich2    =       1-ipos
        ifnamp  =       p11
        ifnind  =       p12
        irnd    =       p13

        kind    oscili  imax-imin,1/p3,ifnind
        kind    =       kind+imin
        kamp    oscili  iamp,1/p3,ifnamp
        aout    foscil  kamp,ifr,in1,in2,kind,1
        arnd    randi   aout,irnd
        ach1    =       arnd*ich1
        ach2    =       arnd*ich2
                outs    ach1,ach2
        ga2a    =       ga2a+ach1
        ga2b    =       ga2b+ach2

endin

; FM instrument with triple carrier
instr   8
        ; imodbase=       700
        iamp    =       ampdb(p4)
        iport1  =       cpspch(p5)*6
        iport2  =       iport1*3.03
        iport3  =       iport1*5.01
        imod1   =       iport1*p6
        idev1   =       imod1*p7
        ifni1   =       p8
        ifnamp  =       p9
        ivel    =       p10

        kind1   oscili  idev1,1/p3,ifni1
        amod1   oscil   kind1,imod1,1,.25
        kamp    oscili  iamp,1/p3,ifnamp
        ax1     oscili  kamp,iport1+amod1,1
        ax2     oscili  kamp*.5,iport2+amod1,1
        ax3     oscili  kamp*.5,iport3+amod1,1
        alnn    linen   1,.003,p3,.01
        kl      line    1,p3,0
        axx     =       (ax1*kl+(ax2+ax3)*(1-kl))*alnn

        kmov    randi   1,ivel,-1
        kmov    =       abs(kmov)
        ach1    =       axx*kmov
        ach2    =       axx*(1-kmov)

                outs    ach1,ach2
        ga2a    =       ga2a+ach1
        ga2b    =       ga2b+ach2

endin

instr   9
        iamp    =       ampdb(p4)
        ifr     =       cpspch(p5)
        in1     =       p6
        in2     =       p7
        imin    =       p8
        imax    =       p9
        ipos    =       p10
        ich1    =       ipos
        ich2    =       1-ipos
        ifnamp  =       p11
        ifnind  =       p12
        iform2  =       p13
        iform3  =       p14
        ibw3    =       p15
        ivel    =       p16

        kind    oscili  imax-imin,1/p3,ifnind
        kind    =       kind+imin
        kamp    oscili  iamp,1/p3,ifnamp
        aout    foscil  kamp,ifr,in1,in2,kind,1
        kl      line    0,p3,1
        aout2   oscil   aout,iform2,1
        arh     randi   aout,iform3
        aout3   reson   arh,iform3,iform3*ibw3,2
        afil     =      aout*kl+(aout2+aout3)*(.5-kl*.5)

        kmov    randi   1,ivel,-1
        kmov    =       abs(kmov)
        ach1    =       afil*kmov
        ach2    =       afil*(1-kmov)
                outs    ach1,ach2
        ga2a    =       ga2a+ach1
        ga2b    =       ga2b+ach2

endin

instr   51
        ; p4    gain
        ; p5    rvt comb
        ; p6    lpt comb
        ; p7    rvt reverb
        ; p8    delay ch2
        ; p9    vel. randi
        ; p10   att.
        ; p11   dec.
        a1      comb    ga1,p5,p6
        a2      reverb  a1,p7
        a4      delay   a2,p8

        kgn     linen   p4,p10,p3,p11
        kcha    randi   1,p9
        kcha    =       abs(kcha)
        kchb    =       (1-kcha)*kgn
        kcha    =       kcha*kgn

        outs    a2*kcha+a4*kchb,a4*kcha+a1*kchb
        ga1     =       0

endin

instr   61
        igain   =       p4
        irvt    =       p5
        ilpt    =       p6
        ivel    =       p7
        asig     =     ga2a+ga2b
        a1      comb    asig*igain,irvt,ilpt
        k1      randi   1,ivel
        k1      =       abs(k1)
        k2      =       1-k1
        outs    a1*k1,a1*k2
        ga2a    =       0
        ga2b     =     0

endin

instr   63
        igain   =       p4
        ivel    =       p5
        imaxdel =       p6/1000
        ivel2   =       p7
        idelosc =       imaxdel*(p8/100)

        klrno   randi   imaxdel-idelosc,ivel,.5
        klfo    oscili  idelosc,ivel2,1

        adel    interp  abs(klfo+klrno)

        adump   delayr  imaxdel+2/kr
        av1     deltapi adel+1/kr
                delayw  ga2a*igain

        adump2  delayr  imaxdel+2/kr
        av2     deltapi imaxdel-adel+1/kr
                delayw  ga2b*igain

                outs    av1,av2
        ga2a    =       0
        ga2b    =       0

endin

</CsInstruments>

<CsScore>
;;; Csound Score for "tape"
;;; Gianantonio Patella -- July 1996 (rev. December 2024)

a0      0       20

f1      0       4096    10      1
f2      0       4096    10      1       -.04
f3      0       4096    10      1       -.055   .027

; Reverberation
;i51    start   dur     gain    rvtc    lptc    rvtr    dlch2   vel     att
;dec
i51     0.000   408     .46     3.9     .637    .65     .179    .73     .1
4

;i3     start   dur     gain    cfmin   cfmed   cfmax   seg1    seg2    q
;chpos  att     dec     detune
i3     35.900   15      6.0     1000    300     3400    3       2       7
.8      1       3       100
i3     36.120   .       .       .       500     1900    .       .       .
.3      .       .       101
i3     100.900  12      5.6     1000    300     3400     3      2       7
.8      1       3       100
i3     101.120  .       .       .       500     1900     .      .       .
.3      .       .       101
i3     137.000  13      3.0     100     300     2000    2.5     1.8     7
.8      .6      4       77
i3     137.700  .       .       .       500     3200    .       .       .
.3      .       .       78
i3     145.500  14      3.0     600     300     2000    3.5     3.5     7
.8      .5      4       78
i3     146.100  .       .       .       700     3200    .       .       .
.2      .       .       79
i3     191.000  16      3.0     950     700     2000    3.5     3.5     7
.8      .5      4       90
i3     191.100     .     .      1200    1000    3200    .       .       .
.2      .       .       91
i3     234.000  16      3.5     950     700     2000    3.5     3.5     7
.8      .5      2       90
i3     240.100  .       3.8     1200    1000     3200   4       5       .
.2      1       2       91
i3     250.100     18   4.2     200     2000     1200   6       3       .
.2      1       2       92

; --------------------------------------------------------------------------
; env amp
f11     0       513     5       .001    10      1       90      .3      212
.45     100     .3      100     .001
f17     0       513     5       1       512     .001

; env ind
f12     0       513     7       0       400     1       112     0
f16     0       513     5       1000    400     100     112     1

;i61    start     dur    gain    rvt     lpt     vel
i61     99.700    9      .75     2.6     .277    .8

;i5    start       dur   db      pch     n1     n2      min     max    ch1
;fnamp  fnind   cf0
i5     99.700     6      59      7.01    1       16     -.2     .7      1
11      12      5000
i5     99.780     .      57      5.04    .       28     .       .       0
i5     100.060    .      56      7.011   .       15     .       .       0
i5     100.570    .      54      5.0405  .       27     .       .       0

;i61    start     dur    gain    rvt     lpt     vel
i61     131.000   15     .75     6.9     .75     1.1

;i5    start       dur   db      pch     n1     n2      min     max    ch1
;fnamp  fnind   cf0
i5     131.000     8     48     7.00     1      16      -.2     .7     1
11      12      5000
i5     131.100     .     <     5.02      .      28      .       .      0
i5     131.460     .     <     7.001     .      15      .       .      0
i5     131.870     .     <     5.021     .      27      .       .      1
i5     132.120     .     <     6.002     .      20      .       .      1
i5     132.820     .     62    6.023     .      21      .       .      0

;i61    start     dur      gain    rvt     lpt     vel
i61     178.000     20     .75     3.2     .467    1.3

;i5    start       dur   db      pch     n1     n2      min     max    ch1
;fnamp  fnind   cf0
i5     178.000     12    55     6.01     1     16     -.2   .7     1
11      16      8000
i5     178.300     .     <     5.02      .     28     .     .      0
i5     178.770     .     <     7.011     .     15     .     .      0
i5     179.370     .     <     5.031     .     27     .     .      1
i5     179.940     .     <     6.012     .     20     .     .      1
i5     180.800     .     <     6.033     .     21     .     .      0
i5     181.610     .     <     4.034     .     31     .     .      0
i5     182.450     .     68    5.035     .     29     .     .      1

;i61    start     dur      gain    rvt     lpt     vel
i61     228.000   32       .89     9.3     .767    1.8

;i5    start       dur   db      pch     n1     n2      min     max    ch1
;fnamp  fnind   cf0
i5     228.000     20    57     6.01     1.05    16     -.2   .9    1
11      12      5000
i5     228.050     18    56     6.03     .       20     .     .     0
i5     228.110     16    64     5.10     .       15     .     .     0
i5     228.350     14    65     5.04     .       27     .     .     1
i5     228.740     12    58     6.02     .       20     .     .     1
i5     229.040     10    56     6.05     .       21     .     .     0
i5     229.610     8     60     5.10     .       31     .     .     0
i5     229.950     7     61     5.08     .       29     .     .     1
i5     230.140     6     62     6.06     .       21     .     .     0
i5     230.310     5     59     6.01     .       31     .     .     0
i5     230.750     4     55     7.09     .       29     .     .     1

;                           gain     vel1     del/ms     velosc     delosc%
i63     320.000     180     -.35     .24      22        1.5         3

;i5    start       dur   db      pch     n1     n2      min     max    ch1
;fnamp  fnind   cf0
i5     320.000     7     57     6.01     1.05   16      -.2     .7      1
11      12      5000
i5     321.000     .     <      6.03    .       20      .       .       0
i5     322.000     .     <      6.05    .       15      .       .       0
i5     323.000     .     <      7.08    .       27      .       .       1
i5     324.000     .     <      7.10    .       20      .       .       1
i5     325.000     .     63     8.00    .       21      .       .       0
i5     326.000     .     79     5.03    .       11      .       .       0
i5     327.000     .     80     5.05    .       19      .       .       1
i5     328.000     .     82     5.02    .       11      .       .       0
i5     329.000     .     75     6.04    .       31      .       .       0
i5     330.000     .     74     6.06    .       29      .       .       1

;i9    start       dur   db      pch      n1    n2      min  max   ch1
;fnamp  fnind   form1     form2     bw     vel
i9     342.000     6.5     48    5.01     1.05  16      -.1  .7    1
17      12      4800      1300      .01    .5
i.     343.320     .     <       5.04     .     20     .     .     0
i.     345.100     .     <       5.06     .     15     .     .     0
i.     346.300     .     <       5.09     .     27     .     .     1
i.     348.000     .     <       7.11     .     20     .     .     1
i.     349.410     .     <       7.10     .     21     .     .     0
i.     351.040     .     <       7.07     .     31     .     .     0
i.     352.100     .     <       6.09     .     29     .     .     1
i.     353.830     .     <       7.00     .     21     .     .     0
i.     355.070     .     <       7.02     .     31     .     .     0
i.     356.200     .     69      6.11     .     29     .     .     1

;i9    start       dur   db      pch      n1    n2      min  max   ch1
;fnamp  fnind   form1     form2     bw     vel
i9     376.000     8.75  53      8.01     3.05  16      -.05 .65   1
11      12      4500      1400      .009   .8
i.     379.000     .     <       7.04     .     20     .     .     0
i.     382.500     .     <       6.06     .     15     .     .     0
i.     384.900     6     <       5.09     .     27     .     .     1
i.     387.600     .     <       6.11     .     20     .     .     1
i.     390.230     .     <       7.10     .     21     .     .     0
.       16
i.     394.000     5     <       6.07     .     31     .     .     0
i.     397.100     .     <       6.09     .     29     .     .     1
i.     400.200     4.5   <       8.00     .     21     .     .     0
i.     403.400     .     <       7.02     .     31     .     .     0
i.     406.200     .     64      6.11     .     29     .     .     1

;i9    start       dur   db      pch      n1    n2      min  max   ch1
;fnamp  fnind   form1     form2     bw     vel
i9     417.000     6     69      6.01      5.05 16      -.03 .6    1
11      12      4000      1500      .008   1
i.      +          .     <       6.04      .    20      .    .     0
i.      +          .     <       6.06      .    15      .    .     0
i.      +          .     <       7.09      .    27      .    .     1
i.      +          .     <       6.11      .    20      .    .     1
i.      +          .     <       6.10      .    21      .    .     0
i.      +          .     <       6.07      .    31      .    .     0
i.      +          .     <       7.09      .    29      .    .     1
i.      +          .     <       6.00      .    21      .    .     0
i.      +          .     <       6.02      .    31      .    .     0
i.      +          .     64      6.11      .    29      .    .     1

;i9    start       dur   db      pch      n1    n2      min  max   ch1
;fnamp  fnind   form1     form2     bw     vel
i9     435.000     5     60      6.01     1.41  6       -.03 .9    1
17      12      3200      1600      .007   1.3
i.      +          .     <       6.04     .     10      .    .     0
i.      +          .     <       6.06     .     5       .    .     0
i.      +          .     <       7.09     .     7       .    .     1
i.      +          .     <       6.11     .     10      .    .     1
i.      +          .     <       6.10     .     11      .    .     0
i.      +          .     <       6.07     .     12      .    .     0
i.      +          .     <       7.09     .     19      .    .     1
i.      +          .     <       6.02     .     21      .    .     0
i.      +          .     55      6.11     .     19      .    .     1

;i8    start    dur     db      pch     mod     dev     fnind   fnamp   vel
i8     450.000  5.2     60      7.01    5.41    .6      17      17     .3
i.      +       .       <       6.04    .       .       .       .       <
i.      +       .       <       6.06    .       .       .       .       <
i.      +       .       <       7.09    .       .       .       .       <
i.      +       .       <       6.11    .       .       .       .       <
i.      +       .       <       6.10    .       .       .       .       <
i.      +       .       <       6.07    .       .       .       .       <
i.      +       .       <       7.09    .       .       .       .       <
i.      +       .       55      7.11    .       .       .       .       2

;i8    start    dur     db      pch     mod     dev     fnind   fnamp   vel
i8     455.500  5.3     55      6.01    17.01     .5     17     12     .5
i.      +       .       <       6.04    .       .       .       .       <
i.      +       .       <       6.06    .       .       .       .       <
i.      +       .       <       7.09    .       .       .       .       <
i.      +       .       <       6.11    .       .       .       .       <
i.      +       .       <       6.10    .       .       .       .       <
i.      +       .       <       7.07    .       .       .       .       <
i.      +       .       61      7.09    .       .       .       .       1.3

;i8    start    dur     db      pch     mod     dev     fnind   fnamp   vel
i8     432.000  5       61      7.01    16.05   .45     11      12      .2
i.     439.000  .       <       6.04    .       .       .       .        <
i.     445.500  .       <       7.06    .       .       .       .        <
i.     451.500  6       <       6.09    .       .       .       .        <
i.     457.000  .       <       6.11    .       .       .       .        <
i.     462.000  .       <       6.10    .       .       .       .        <
i.     466.500  .       <       6.07    .       .       .       .        <
i.     470.500  .       <       6.09    .       .       .       .        <
i.     474.000  9       52      6.00    .       .       .       .        <

;i8    start    dur     db      pch     mod     dev     fnind   fnamp   vel
i8     434.000  5       64      7.02    7.05    1.6     11      12      .5
i.     440.100  .       <       6.03    .       .       .       .       <
i.     445.900  .       <       6.05    .       .       .       .       <
i.     450.300  .       <       6.08    .       .       .       .       <
i.     456.700  .       <       7.10    .       .       .       .       <
i.     461.500  .       <       6.11    .       .       .       .       <
i.     464.500  .       <       7.08    .       .       .       .       <
i.     466.200  6       <       6.10    .       .       .       .       <
i.     469.000  .       <       6.03    .       .       .       .       <
i.     474.200  .       45      7.04    .       .       .       .       1.4

;i7                     db      pch     mod     dev    min     max     ch1
;fnamp  fnind   frq.rnd
i7     429.100     5    43      6.00    8.05    16     0       .45     1
11      16      80
i.     436.200     .     <      6.04    .       20     .       .       0
i.     443.700     5.4   <      7.06    .       15     .       .       0
i.     446.200     .     <      7.09    .       27     .       .       1
i.     455.300     .     <      6.11    .       20     .       .       1
i.     458.100     6     <      6.10    .       21     .       .       0
i.     466.700     .     <      7.07    .       31     .       .       0
i.     470.800     8     <      6.09    .       29     .       .       1
i.     473.450     .     <      6.00    .       21     .       .       0
i.     475.000     10     52    6.02    .       31     .       .       0

;i5    start       dur   db      pch     n1     n2      min     max    ch1
;fnamp  fnind   cf0
i5     447.100     5     43      6.00    9.05   16      0       .4     1
11      12      5000
i5     451.200     .     <       6.04    .      20      .       .      0
i5     453.700     5.4   <       7.06    .      15      .       .      0
i5     456.200     .     <       6.09    .      27      .       .      1
i5     457.300     .     <       7.11    .      20      .       .      1
i5     458.100     6     <       6.10    .      21      .       .      0
i5     462.700     .     <       6.07    .      31      .       .      0
i5     464.800     8     <       7.09    .      29      .       .      1
i5     466.450     .     <       7.00    .      21      .       .      0
i5     467.000     10    <       6.02    .      31      .       .      0
i5     469.200     .     <       7.01    .      29      .       .      1
i5     470.820     .     <       6.10    .      29      .       .      1
i5     472.810     .     50      7.11    .      29      .       .      0

;i5    start       dur   db      pch     n1     n2      min     max    ch1
;fnamp  fnind   cf0
i5     449.760     8     64      6.02    10.05  16      -.01    .35    1
11      12
i5     452.300     .     <       6.03    .     20       .       .      0
i5     454.940     .     <       7.05    .     15       .       .      0
i5     455.300     .     <       7.08    .     27       .       .      1
i5     456.670     .     <       6.10    .     20       .       .      1
i5     460.450     .     <       7.01    .     21       .       .      0
i5     464.500     .     <       6.08    .     31       .       .      0
i5     465.120     12    <       7.10    .     29       .       .      1
i5     466.760     .     <       7.03    .     21       .       .      0
i5     471.600     14    <       6.02    .     31       .       .      0
i5     472.250     .     50      7.09    .     29       .       .      1

; --------------------------------------------------------------------------
; plink special

; env amp
f13     278     513     7       .05     256     1      256      0
; env ind 1
f14     278     513     7       0       256      1      256     0
; env ind 2
f15     278     513     7       0      512      1

;i6    start       dur    db      pch     mod1    dev1    fn1     mod2    dev2
;fn2    fnamp   ivel    maxdel%
i6     278.000     19     47      6.01    6       1.1     15      16.001  1.3
15     13       1.8     20
i6     280.000     20     46      6.11
i6     291.000     21     49      8.07
i6     294.100     22     49      7.10
i6     297.200     23     48      8.06
i6     311.000     24     47      6.02
i6     315.200     25     47      8.05
i6     319.400     27     46      6.01
i6     323.600     30     45      7.07

;i6    start       dur    db      pch     mod1    dev1    fn1     mod2    dev2
;fn2    fnamp   ivel    maxdel%
i6     332.100     34     49      8.09    5       .86
i6     350.100     49     50      7.06    .       .       .       15.002  1.26
i6     470.000     45     31      7.07    .       .       .       .       1.
.       .       .333    45

; --------------------------------------------------------------------------

;i1    start    dur   db      pch     n1      n2      imin    imax    %rni
;vrni   ati     dci     %rna    vrna    ata     dca     %vfr    vrnfr   ch1   fn
i1     35.000   12    50      5.07    1       4       .2      .5      .2
8       1       1       .3      21      .5      .5      .007    .31     .2    1
i1     36.000   12    48      5.0703  .       .       .       .5      .3
9.1     .       .       .32     23      .       .       .008    .38     .6
i1     37.300   14    47      5.0901  .       .       .       .5      .3
9.1     .       .       .32     23      .       .       .008    .48     .6
i1     42.210   39    48      4.0902  .       9       .       .5      .3
10.1    .       .       .32     32      .       22      .008    1.38    .6

;i1    start    dur    db      pch     n1      n2      imin    imax    %rni
;vrni   ati     dci     %rna    vrna    ata     dca     %vfr    vrnfr   ch1   fn
i1     20.000   84.6   45      8.0834  3       1       .       .5      .4
13.1    10      2       .32     35      18      7       .009    2.38    .3
i1     20.000   84.6   43      8.1045  3       1       .       .53     .4
14.5    10      2       .32     37      18      4       .009    3.85    .68

;i1    start    dur   db      pch     n1      n2      imin    imax    %rni
;vrni   ati     dci     %rna    vrna    ata     dca     %vfr    vrnfr   ch1   fn
i1     80.300   35    51      6.0137  1       4       .1      .55     .37
15.1    1       1       .32     39      15      6       .011    4.57    .43   2
i1     103.100  32    54      6.0329  1       1       .02     .56     .42
17.3    2       2       .41     44      8       6       .012    6.03    .71   2
i1     116.000  31    57      6.0477  1       1       .02     .56     .42
18      4       7       .43     48      5       6       .012    7.11    .25   3

f4      96      4096    10      1       -.065   .037    -.026

;i1    start    dur   db      pch     n1      n2      imin    imax    %rni
;vrni   ati     dci     %rna    vrna    ata     dca     %vfr    vrnfr   ch1   fn
i1     131.000  57    60      6.1009  1       2       .04     .51     .4
21      1       1       .3      50      8       11      .013    9.18    .9    4
i1     164.500  42    55      6.0954  1       2       .04     .51     .4
21      1       1       .3      50      8       11      .013    9.18    .9    4

f5      145.8   4096    10      1       -.078   .042    -.033   .023

;i1    start    dur   db      pch     n1      n2      imin    imax    %rni
;vrni   ati     dci     %rna    vrna    ata     dca     %vfr    vrnfr   ch1   fn
i1     180.800  37    56      7.0011  1       2       .04     .51     .4
21      1       1       .3      50      8       11      .013    9.18    .16   5
i1     198.200  59    57      7.0233  1       2       .04     .51     .4
21      1       1       .3      51      22      15      .013    9.88    .16   5
i1     213.800  45    40      9.072   2       1       .04     .51     .4
23      1       1       .3      50      16      12      .014    10.1    .94   1
i1     232.000  35    48      9.0873  3       2       .1     .61      .5
24      1       1       .3      52      10      7       .015    11.2    .55   1
i1     270.300  24    44      9.0643  3       2       .1     .61      .5
24      1       1       .3      52      6       6       .015    11.4    .55   1
i1     270.350  24    43      9.0634  3       2       .1     .61      .5
24      1       1       .3      52      6       6       .015    11.1    .35   1

;i1    start    dur   db      pch     n1      n2      imin    imax    %rni
;vrni   ati     dci     %rna    vrna    ata     dca     %vfr    vrnfr   ch1   fn
i1     282.230  29    70      5.0163  1       5       .14     .56     .4
21      1       1       .3      51      8       5       .013    9.88    .16   5
i1     293.110  32    72      5.0337  1       6       .14     .61     .41
21      1       1       .32     52      7       5       .013    9.97    .96   4
i1     298.150  35    72      5.0546  1       7       .14     .61     .41
21      1       1       .32     52      6       6       .013    9.97    .6    3
i1     304.150  38    71      5.0768  1       8       .21     .72     .41
21      1       1       .32     52      6       6       .013    9.97    .37   2
i1     347.150  40    71      6.0068  1       7       .21     .72     .41
21      1       1       .32     52      6       6       .013    10.01   .37   1
i1     352.160  34    44      9.1108  1       2       .21     .72     .41
21      1       1       .32     52      6       6       .013    10.01   .37   1

f6      228.1   4096    10      1       0       0       0       -.098   .053
-.14   .137     .03     -.02

; variante
;i1    start    dur   db      pch     n1      n2      imin    imax    %rni
;vrni   ati     dci     %rna    vrna    ata     dca     %vfr    vrnfr   ch1   fn
i1     263.100  8.5   60      4.0703  1       13.     .5      2.81    .5
24      1       1       .3      52      3       3       .016    81.2    .55   6
i1     263.210  8.5   62      4.0713  1       13.     .5      2.81    .5
24      1       1       .3      52      3       3       .016    81.2    .85   6
i1     263.320  8.5   64      4.0723  1       13.     .5      2.81    .5
24      1       1       .3      52      3       3       .016    81.2    .25   6

;i1    start    dur   db      pch     n1      n2      imin    imax    %rni
;vrni   ati     dci     %rna    vrna    ata     dca     %vfr    vrnfr   ch1   fn
i1     340.100  6.5   56      4.1103  1       15.     .5      2.81    .5
24      1       1       .3      52      3       3       .016    81.2    .55   6
i1     340.110  6.5   58      4.1114  1       15.     .5      2.81    .5
24      1       1       .3      52      3       3       .016    81.2    .85   6
i1     340.120  6.5   60      4.1126  1       15.     .5      2.81    .5
24      1       1       .3      52      3       3       .016    81.2    .25   6

;i1    start    dur   db      pch     n1      n2      imin    imax    %rni
;vrni   ati     dci     %rna    vrna    ata     dca     %vfr    vrnfr   ch1   fn
i1     376.600  6.5   52      5.0303  1       15.     .5      2.81    .5
26      1       1       .3      52      2       3       .016    81.2    .55   6
i1     376.650  6.5   56      5.0314  1       15.     .5      2.81    .5
25      1       1       .3      52      2       3       .016    81.2    .85   6
i1     376.700  6.5   49      6.0326  1       15.     .5      2.81    .5
24      1       1       .3      52      2       3       .016    81.2    .25   6

;i1    start    dur   db      pch     n1      n2      imin    imax    %rni
;vrni   ati     dci     %rna    vrna    ata     dca     %vfr    vrnfr   ch1   fn
i1     390.010  9.5   50      5.0733  1      15.      .5      2.81    .5
24      1       1       .3      52      6       3       .016    83.2    .55   6
i1     390.110  9.5   51      4.0754  1      15.      .5      2.81    .5
26      1       1       .3      52      6       3       .016    82.2    .85   6
i1     390.320  9.5   48       6.0766  1      15.      .5      2.81    .5
28      1       1       .3      52      6       3       .016    81.2    .25   6

e


</CsScore>
</CsoundSynthesizer>


