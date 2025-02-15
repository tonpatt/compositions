S1=s1.wav
S2=s2.wav
S3=s3.wav
S3MIX=s3mix.wav
GIADA=giada_blu.wav

.PHONY: clean all

all: giada

%.wav:
	csound -o $@ $+

giada : $(S1) $(S2) $(S3) $(S3MIX) $(GIADA)

$(S1): o1.orc s1.sco

$(S2) : o1.orc s2.sco

$(S3) : s3.orc s3.sco

$(S3MIX) : s3mix.orc s3mix.sco

$(GIADA) : mixer.orc mixer.sco

clean:
	rm -f $(S3MIX) $(S1) $(S2) $(S3) $(GIADA)
