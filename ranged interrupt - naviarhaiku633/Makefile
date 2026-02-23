WAVEDIR=.
FLAC=$(WAVEDIR)/test.flac
OGG=$(WAVEDIR)/test.ogg
PYFILES=main.py
CSD=main.csd
CSFILES=$(CSD) score.sco instrs.orc udos.udo generators.udo
PYTHON=python
CSOUND=csound

.PHONY: ogg flac

ogg: $(OGG)

flac: $(FLAC)

$(FLAC): $(CSFILES) $(PYFILES)
	$(CSOUND) $(CSD) -o $(FLAC) --format=flac

$(OGG): $(CSFILES) $(PYFILES)
	$(CSOUND) $(CSD) -o $(OGG) --ogg

score.sco: main.py
	$(PYTHON) $<
