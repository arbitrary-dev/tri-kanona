.PHONY: all clean

VERSION := 1.0

all: output.pdf

text.pdf: text.tex
	xelatex "\def\Version{${VERSION}} \input{$<}"

rotated.pdf: text.pdf
	pdfjam --outfile $@ --angle 180 --fitpaper true $<

output.pdf: text.pdf rotated.pdf
	# --papersize have to be specified explicitly
	# since pdfpages-0.6c mistakenly enlarges page width.
	# Apparently fixed in pdfpages-0.6f.
	pdfjam --nup 3x2 --outfile $@   \
		--papersize '{210mm,297mm}' --no-landscape \
		rotated.pdf 1,6,5 \
		text.pdf    2,3,4 \
		rotated.pdf   7,12,11 \
		text.pdf       8,9,10 \
		rotated.pdf 13,18,17 \
		text.pdf    14,15,16 \
		rotated.pdf   19,24,23 \
		text.pdf      20,21,22

clean:
	rm -f *.log *.aux *.out {output,text,rotated}.pdf
