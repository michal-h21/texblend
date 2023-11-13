.PHONY: all test build

doc_root = texblend-doc
doc_tex  = $(doc_root).tex
doc_pdf  = $(doc_root).pdf
tex_sources = $(doc_tex) intro.tex

ifeq ($(strip $(shell git rev-parse --is-inside-work-tree 2>/dev/null)),true)
	VERSION:= $(shell git --no-pager describe --abbrev=0 --tags --always )
	DATE:= $(firstword $(shell git --no-pager show --date=short --format="%ad" --name-only))
endif

all: $(doc_pdf)
	
$(doc_pdf): $(tex_sources)
	lualatex $<

test:
	texlua spec/test.lua

build: test $(doc_pdf) 
	@rm -rf build

