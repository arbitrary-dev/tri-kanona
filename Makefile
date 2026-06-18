.PHONY: all clean text.pdf

VERSION := 1.6.4

all: standalone.pdf booklet.pdf
	cp standalone.pdf tri-kanona-$(VERSION).pdf
	cp booklet.pdf    tri-kanona-$(VERSION)b.pdf

text.pdf: text.tex
	lualatex "\relax                \
		\def\Version{$(VERSION)}     \
		\def\WithMarks{$(WITH_MARKS)} \
		\input{$<}"

standalone.pdf: text.tex
	$(MAKE) WITH_MARKS=0 text.pdf
	mv text.pdf $@

booklet.pdf: text.tex
	$(MAKE) WITH_MARKS=1 text.pdf

	pdfjam --outfile rotated.pdf --angle 180 --fitpaper true text.pdf

	# --papersize have to be specified explicitly
	# since pdfpages-0.6c mistakenly enlarges page width.
	# Apparently fixed in pdfpages-0.6f.
	pdfjam --nup 3x2 --outfile $@   \
		--papersize '{210mm,297mm}' --no-landscape \
		rotated.pdf     1,6,5 \
		text.pdf     2,3,4 \
		rotated.pdf   7,12,11 \
		text.pdf    8,9,10 \
		rotated.pdf  13,18,17 \
		text.pdf  14,15,16 \
		rotated.pdf  19,24,23 \
		text.pdf  20,21,22

	# Update versions for latest PDF downloads
	sed -i -E "s/[0-9]+\.[0-9]+(\.[0-9]+|)/$(VERSION)/g" README.md

clean:
	rm -f *.log *.aux *.out {text,rotated,booklet,standalone}.pdf
