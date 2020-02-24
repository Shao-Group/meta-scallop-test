#!/bin/bash

cat tex.R | sed 's/AAA/gtex.list/g' | sed 's/BBB/gtex.tex/g' > gtex.R
R CMD BATCH gtex.R
./wrap.sh gtex.tex
pdflatex gtex.tex


cat tex.R | sed 's/AAA/egeuv6.list/g' | sed 's/BBB/egeuv6.tex/g' > egeuv6.R
R CMD BATCH egeuv6.R
./wrap.sh egeuv6.tex
pdflatex egeuv6.tex


pdflatex combine.tex
