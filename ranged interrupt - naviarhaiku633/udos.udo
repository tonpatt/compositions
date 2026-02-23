opcode u_seg3,k,iiiii
    iamp,iatk,idur,ilev,irel xin
    iatk = (iatk > 0 ? iatk : 0.001)
    irel = (irel > 0 ? irel : 0.01)
    kout = linseg(0, iatk, iamp,idur - iatk - irel, ilev * iamp, irel, 0)
    xout kout
endop

opcode u_fadeout,a,io
    idur, idec xin
    idec = (idec == 0? 0.01: idec)
    afadeout linseg 1, idur - idec, 1, idec, 0
    xout afadeout
endop

opcode u_frq,i,i
    ifreq xin
    xout (ifreq < 0? -ifreq: cpspch(ifreq))
endop

