.PHONY: all test build install

doc_root = texblend-doc
doc_tex  = $(doc_root).tex
doc_pdf  = $(doc_root).pdf
doc_html = $(doc_root).html

tex_sources = $(doc_tex) intro.tex usage.tex
readme_ctan = readme-ctan.txt
SCRIPT = texblend
BUILD_DIR = build
BUILD_TEXBLEND = $(BUILD_DIR)/$(SCRIPT)
BUILD_SCRIPT = $(BUILD_TEXBLEND)/$(SCRIPT)
BUILD_README = $(BUILD_TEXBLEND)/README


REPLACE_VERSION = sed -e "s/{{version}}/${VERSION}/"

ifeq ($(strip $(shell git rev-parse --is-inside-work-tree 2>/dev/null)),true)
	VERSION:= $(shell git --no-pager describe --abbrev=0 --tags --always )
	DATE:= $(firstword $(shell git --no-pager show --date=short --format="%ad" --name-only))
endif

all: $(doc_pdf) $(doc_html)
	
$(doc_pdf): $(tex_sources)
	lualatex "\def\version{${VERSION}}\def\gitdate{${DATE}}\input{$<}"
	lualatex "\def\version{${VERSION}}\def\gitdate{${DATE}}\input{$<}"

$(doc_html): $(tex_sources)
	make4ht -la debug $< 


test:
	texlua spec/test.lua

build: test $(doc_pdf) 
	@rm -rf $(BUILD_DIR)
	mkdir -p $(BUILD_TEXBLEND)
	cp $(tex_sources) $(BUILD_TEXBLEND)
	cp $(doc_pdf) $(BUILD_TEXBLEND)
	cat $(readme_ctan) | $(REPLACE_VERSION) > $(BUILD_README)
	cat $(SCRIPT) | $(REPLACE_VERSION)	> $(BUILD_SCRIPT)
	chmod +x $(BUILD_SCRIPT)
	cd $(BUILD_DIR) && zip -r  $(SCRIPT).zip $(SCRIPT)

install:
	ln -s `realpath texblend` ${HOME}/.local/bin/texblend






