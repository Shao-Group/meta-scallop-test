#!/bin/bash

dir=`pwd`
outdir=$1
datafile=$2
prefix=$3

mkdir -p $outdir

id="$prefix"
texfile=$outdir/$id.tex
tmpfile=$outdir/tmpfile.R
rm -rf $tmpfile

cd $outdir

echo "source(\"$dir/roc-curve.R\")" > $tmpfile
echo "draw.roc(\"$datafile\", \"$texfile\")" >> $tmpfile
R CMD BATCH $tmpfile
$dir/wrap.sh $texfile
pdflatex $texfile

cd -
