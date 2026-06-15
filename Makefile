.PHONY: all clean text.pdf

VERSION := 1.6

all: tri-kanona-$(VERSION).pdf tri-kanona-$(VERSION)b.pdf

text.pdf: text.tex
	lualatex "\relax                \
		\def\Version{$(VERSION)}     \
		\def\WithMarks{$(WITH_MARKS)} \
		\input{$<}"

text-no-marks.pdf: text.tex
	$(MAKE) WITH_MARKS=0 text.pdf
	mv "text.pdf" "$@"

text-with-marks.pdf: text.tex
	$(MAKE) WITH_MARKS=1 text.pdf
	mv "text.pdf" "$@"

tri-kanona-$(VERSION).pdf: text-no-marks.pdf
	mv "$<" "$@"

tri-kanona-$(VERSION)b.pdf: text-with-marks.pdf
	pdfjam --outfile "rotated.pdf" --angle 180 --fitpaper true "text-with-marks.pdf"

	# --papersize have to be specified explicitly
	# since pdfpages-0.6c mistakenly enlarges page width.
	# Apparently fixed in pdfpages-0.6f.
	pdfjam --nup 3x2 --outfile $@   \
		--papersize '{210mm,297mm}' --no-landscape \
		rotated.pdf       1,6,5 \
		text-with-marks.pdf     2,3,4 \
		rotated.pdf     7,12,11 \
		text-with-marks.pdf    8,9,10 \
		rotated.pdf    13,18,17 \
		text-with-marks.pdf  14,15,16 \
		rotated.pdf    19,24,23 \
		text-with-marks.pdf  20,21,22

	# Update version for latest pdf download
	sed -i -E "s/[0-9]+\.[0-9]+(\.[0-9]+|)/$(VERSION)/g" README.md

clean:
	rm -f *.log *.aux *.out {text*,rotated}.pdf
