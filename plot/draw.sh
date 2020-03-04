#!/bin/bash

R CMD BATCH time.R
./wrap.sh time.tex
pdflatex time.tex

pdflatex combine.tex
exit


cat tex.R | sed 's/AAA/gtex.list/g' | sed 's/BBB/gtex.tex/g' > gtex.R
R CMD BATCH gtex.R
./wrap.sh gtex.tex
pdflatex gtex.tex



cat tex.R | sed 's/AAA/egeuv6.list/g' | sed 's/BBB/egeuv6.tex/g' > egeuv6.R
R CMD BATCH egeuv6.R
./wrap.sh egeuv6.tex
pdflatex egeuv6.tex

cat tex.R | sed 's/AAA/mixed.list/g' | sed 's/BBB/mixed.tex/g' > mixed.R
R CMD BATCH mixed.R
./wrap.sh mixed.tex
pdflatex mixed.tex

