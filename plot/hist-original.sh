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
id="$prefix-original-precision"
texfile=$outdir/$id.tex
tmpfile=$dir/tmpfile.R
rm -rf $tmpfile

echo "source(\"$dir/hist.R\")" > $tmpfile
echo "hist.2(\"$datafile\", \"$texfile\", 5, 9, \"$algo1\", \"$algo2\", \"Raw Precision\", 1)" >> $tmpfile
R CMD BATCH $tmpfile
$dir/wrap.sh $id.tex
pdflatex $id.tex

# draw correct
id="$prefix-original-recall"
texfile=$outdir/$id.tex
tmpfile=$dir/tmpfile.R
rm -rf $tmpfile

echo "source(\"$dir/hist.R\")" > $tmpfile
echo "hist.2(\"$datafile\", \"$texfile\", 4, 8, \"$algo1\", \"$algo2\", \"Raw Correct\", 1)" >> $tmpfile
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
