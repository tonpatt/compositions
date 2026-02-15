FLAC=drone1.flac
OGG=drone1.ogg
PYFILES=score.py drone1.py
CSD=drone1.csd
CSOUND=csound

.PHONY: ogg flac

ogg: $(OGG)

flac: $(FLAC)

$(FLAC): $(CSD) $(PYFILES)
	$(CSOUND) $(CSD) -o $(FLAC) --format=flac

$(OGG): $(CSD) $(PYFILES)
	$(CSOUND) $(CSD) -o $(OGG) --ogg

test: $(CSD) $(PYFILES)
	$(CSOUND) $(CSD) --i-only

