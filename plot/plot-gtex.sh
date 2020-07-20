#!/bin/bash

dir=`pwd`
outdir=$dir/gtex-figures
datadir=$dir/gtex-results

datafile=$datadir/gtex-aletsch-roc-all.list
$dir/roc-curve.sh $outdir $datafile gtex-aletsch-roc

for k in `echo "20 100 500 2377"`
do
	datafile=$datadir/gtex"$k"-roc-all.list
	$dir/roc-curve.sh $outdir $datafile gtex"$k"-roc
done

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

done

outputfile=$outdir/summary.gtex
cat $tmpoutfile | sed 's/.U.*gtex-//g' | sed 's/  */ /g' | sed 's/-/,/g' | sed 's/,0/,WO/g' | sed 's/,A/,WR/g' | sed 's/stringtie/ST/g' | sed 's/star/SR/g' | sed 's/scallop/SC/g' | sed 's/hisat/HI/g'  > $outputfile

$dir/errorbar.sh $outdir $outputfile 0.23
