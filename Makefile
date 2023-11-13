.PHONY: all

all: texblend-doc.pdf
	
texblend-doc.pdf: texblend-doc.tex intro.tex
	lualatex $<
