#!/bin/bash

cat tex.R | sed 's/AAA/gtex-aletsch.list/g' | sed 's/BBB/gtex-aletsch.tex/g' > gtex-aletsch.R
R CMD BATCH gtex-aletsch.R
./wrap.sh gtex-aletsch.tex
pdflatex gtex-aletsch.tex

exit

cat tex.R | sed 's/AAA/egeuv6.list/g' | sed 's/BBB/egeuv6.tex/g' > egeuv6.R
R CMD BATCH egeuv6.R
./wrap.sh egeuv6.tex
pdflatex egeuv6.tex

pdflatex combine.tex


cat tex.R | sed 's/AAA/mixed.list/g' | sed 's/BBB/mixed.tex/g' > mixed.R
R CMD BATCH mixed.R
./wrap.sh mixed.tex
pdflatex mixed.tex

