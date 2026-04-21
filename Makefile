.PHONY: all clean

all: output.pdf

text.pdf: text.tex
	xelatex $<

rotated.pdf: text.pdf
	pdfjam --outfile $@ --angle 180 --fitpaper true $<

output.pdf: text.pdf rotated.pdf
	pdfjam --nup 3x2 --outfile $@ \
		rotated.pdf 1,6,5     \
		text.pdf 2,3,4

clean:
	rm -f *.log *.aux {output,text,rotated}.pdf
