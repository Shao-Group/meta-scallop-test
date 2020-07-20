#!/bin/bash

dir=`pwd`

outdir=$1
datafile=$2
prefix=$3
algo1=$4
algo2=$5

mkdir -p $outdir
cd $outdir

# draw precision
id="$prefix-adjusted-precision"
texfile=$outdir/$id.tex
tmpfile=$dir/tmpfile.R
rm -rf $tmpfile

echo "source(\"$dir/hist.R\")" > $tmpfile
echo "hist.2(\"$datafile\", \"$texfile\", 11, 12, \"$algo1\", \"$algo2\", \"Adjusted Precision\", 1)" >> $tmpfile
R CMD BATCH $tmpfile
$dir/wrap.sh $id.tex
pdflatex $id.tex

# draw correct
id="$prefix-adjusted-recall"
texfile=$outdir/$id.tex
tmpfile=$dir/tmpfile.R
rm -rf $tmpfile

echo "source(\"$dir/hist.R\")" > $tmpfile
echo "hist.2(\"$datafile\", \"$texfile\", 14, 15, \"$algo1\", \"$algo2\", \"Adjusted Sensitivity\", 1)" >> $tmpfile
R CMD BATCH $tmpfile
$dir/wrap.sh $id.tex
pdflatex $id.tex

exit

id="$prefix"
cp $dir/combine1.tex $id.tex
sed -i "" "s/AAA/${id}-precision/" $id.tex
sed -i "" "s/BBB/${id}-correct/" $id.tex
pdflatex $id.tex

rm -rf $tmpfile
