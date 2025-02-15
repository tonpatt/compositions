
.PHONY: clean

linee.flac: section1.flac section2.flac section3.flac
	csound --format=flac -o linee.flac mixer.orc mixer.sco


section1.flac : section1.orc section1.sco
	csound --format=flac -o section1.flac section1.orc section1.sco

section2.flac : section2.orc section2.sco
	csound --format=flac -o section2.flac section2.orc section2.sco

section3.flac : section3.orc section3.sco
	csound --format=flac -o section3.flac section3.orc section3.sco


clean:
	-rm *.flac