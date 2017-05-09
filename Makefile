# Makefile for ThuThesis

# Compiling method: latexmk/xelatex/pdflatex
METHOD = latexmk
# Set opts for latexmk if you use it
LATEXMKOPTS = -xelatex
# Basename of thesis
THESISMAIN = main
# Basename of shuji
SHUJIMAIN = shuji
# Basename of temp
TEMPMAIN = temp

PACKAGE=thuthesis
SOURCES=$(PACKAGE).ins $(PACKAGE).dtx
THESISCONTENTS=$(THESISMAIN).tex data/*.tex $(FIGURES)
# NOTE: update this to reflect your local file types.
FIGURES=$(wildcard figures/*.eps figures/*.pdf)
BIBFILE=ref/*.bib
SHUJICONTENTS=$(SHUJIMAIN).tex
CLSFILES=dtx-style.sty $(PACKAGE).cls $(PACKAGE).cfg

# make deletion work on Windows
ifdef SystemRoot
	RM = del /Q
	OPEN = start
else
	RM = rm -f
	OPEN = open
endif

.PHONY: all clean distclean dist thesis viewthesis shuji viewshuji doc viewdoc cls check FORCE_MAKE

all: doc thesis shuji

cls: $(CLSFILES)

$(CLSFILES): $(SOURCES)
	latex $(PACKAGE).ins

viewdoc: doc
	$(OPEN) $(PACKAGE).pdf

doc: $(PACKAGE).pdf

viewthesis: thesis
	$(OPEN) $(THESISMAIN).pdf

thesis: $(THESISMAIN).pdf

viewshuji: shuji
	$(OPEN) $(SHUJIMAIN).pdf

shuji: $(SHUJIMAIN).pdf

viewdata-%: data-%
	$(OPEN) $(TEMPMAIN).pdf

data-%:
	@sed -e "s/TEX_FILE/`cut -c6- <<< $@`/" template.tex > $(TEMPMAIN).tex
	$(METHOD) $(LATEXMKOPTS) $(TEMPMAIN).tex
	-@$(RM) $(TEMPMAIN).tex

ifeq ($(METHOD),latexmk)

$(PACKAGE).pdf: $(CLSFILES) FORCE_MAKE
	$(METHOD) $(LATEXMKOPTS) $(PACKAGE).dtx

$(THESISMAIN).pdf: $(CLSFILES) FORCE_MAKE
	$(METHOD) $(LATEXMKOPTS) $(THESISMAIN)

$(SHUJIMAIN).pdf: $(CLSFILES) FORCE_MAKE
	$(METHOD) $(LATEXMKOPTS) $(SHUJIMAIN)

else ifneq (,$(filter $(METHOD),xelatex pdflatex))

$(PACKAGE).pdf: $(CLSFILES)
	$(METHOD) $(PACKAGE).dtx
	makeindex -s gind.ist -o $(PACKAGE).ind $(PACKAGE).idx
	makeindex -s gglo.ist -o $(PACKAGE).gls $(PACKAGE).glo
	$(METHOD) $(PACKAGE).dtx
	$(METHOD) $(PACKAGE).dtx

$(THESISMAIN).pdf: $(CLSFILES) $(THESISCONTENTS) $(THESISMAIN).bbl
	$(METHOD) $(THESISMAIN)
	$(METHOD) $(THESISMAIN)

$(THESISMAIN).bbl: $(BIBFILE)
	$(METHOD) $(THESISMAIN)
	-bibtex $(THESISMAIN)
	$(RM) $(THESISMAIN).pdf

$(SHUJIMAIN).pdf: $(CLSFILES) $(SHUJICONTENTS)
	$(METHOD) $(SHUJIMAIN)

else
$(error Unknown METHOD: $(METHOD))

endif

clean:
	latexmk -c $(PACKAGE).dtx $(THESISMAIN) $(SHUJIMAIN)
	-@$(RM) $(TEMPMAIN).*
	-@$(RM) *~

cleanpdf: clean
	-@$(RM) $(PACKAGE).pdf $(THESISMAIN).pdf $(SHUJIMAIN).pdf $(TEMPMAIN).pdf

distclean: cleanpdf
	-@$(RM) $(CLSFILES)
	-@$(RM) -r dist

cleanall: distclean
	-@$(RM) $(PACKAGE).xdv $(THESISMAIN).xdv $(SHUJIMAIN).xdv

check: FORCE_MAKE
	ag 'Tsinghua University Thesis Template|\\def\\version|"version":' thuthesis.dtx package.json

dist: all
	@if [ -z "$(version)" ]; then \
		echo "Usage: make dist version=[x.y.z | ctan]"; \
	else \
		npm run build -- --version=$(version); \
	fi
