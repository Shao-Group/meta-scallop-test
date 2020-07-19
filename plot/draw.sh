#!/bin/bash

cat tex.R | sed 's/AAA/gtex-aletsch.list/g' | sed 's/BBB/gtex-aletsch.tex/g' > gtex-aletsch.R
R CMD BATCH gtex-aletsch.R
./wrap.sh gtex-aletsch.tex
pdflatex gtex-aletsch.tex
