FLAC=t1.flac
OGG=t1.ogg
FILES=cat1.csd score.sco instrs.orc generators.udo
CSOUND=csound

.PHONY: ogg flac

ogg: $(OGG)

flac: $(FLAC)

$(OGG): $(FILES)
	$(CSOUND) cat1.csd -o $(OGG) --ogg

$(FLAC): $(FILES)
	$(CSOUND) cat1.csd -o $(FLAC) --format=flac
