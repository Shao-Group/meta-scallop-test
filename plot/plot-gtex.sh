#!/bin/bash

dir=`pwd`
outdir=$dir/gtex-figures
datadir=$dir/gtex-results

for k in `echo "2377 500 100 20"`
do
	datafile=$datadir/gtex"$k"-roc-all.list
	$dir/roc-curve.sh $outdir $datafile gtex"$k"-roc
done

datafile=$datadir/gtex-aletsch-roc-all.list
$dir/roc-curve.sh $outdir $datafile gtex-aletsch-roc

exit

datafile=$datadir/gtex2377-scallop-aletsch.all
$dir/hist-original.sh $outdir $datafile gtex2377-scallop-aletsch Scallop Aletsch
$dir/hist-adjusted.sh $outdir $datafile gtex2377-scallop-aletsch Scallop Aletsch

datafile=$datadir/gtex2377-stringtie-aletsch.all
$dir/hist-original.sh $outdir $datafile gtex2377-stringtie-aletsch StringTie Aletsch
$dir/hist-adjusted.sh $outdir $datafile gtex2377-stringtie-aletsch StringTie Aletsch

exit

tmpfile=$dir/tmpfile.R
rm -rf $tmpfile
echo "source(\"$dir/summarize.R\")" > $tmpfile
echo "summarize.3(\"$rawdata\", \"$tmpoutfile\")" >> $tmpfile
R CMD BATCH $tmpfile
rm -rf $tmpfile

outputfile=$outdir/summary.gtex
cat $tmpoutfile | sed 's/.U.*gtex-//g' | sed 's/  */ /g' | sed 's/-/,/g' | sed 's/,0/,WO/g' | sed 's/,A/,WR/g' | sed 's/stringtie/ST/g' | sed 's/star/SR/g' | sed 's/scallop/SC/g' | sed 's/hisat/HI/g'  > $outputfile

$dir/errorbar.sh $outdir $outputfile 0.23
