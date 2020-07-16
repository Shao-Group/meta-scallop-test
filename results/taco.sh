#!/bin/bash

if [ "$#" != "5" ]; then
	echo "usage $0 threads gtf-list cur-dir ref attr"
	exit
fi

threads=$1
gtflist=$2
cur=$3
ref=$4
attr=$5

taco=/gpfs/group/mxs2589/default/shared/tools/taco/taco-0.7.3/taco_run
gtfcuff=/storage/home/mxs2589/shared/bin/gtfcuff
gffcompare=/storage/home/mxs2589/shared/tools/gffcompare/gffcompare-0.11.2.Linux_x86_64/gffcompare

#gtfcuff=/home/mxs2589/shared/bin/gtfcuff
#gffcompare=/home/mxs2589/shared/tools/gffcompare/gffcompare-0.11.2.Linux_x86_64/gffcompare

cd $cur
{ /usr/bin/time -v $taco --gtf-expr-attr $attr -o taco -p $threads $gtflist > taco.log ; } 2> taco.time

cat taco/assembly.gtf | sed 's/expr/cov/g' > taco.gtf

ln -sf $ref .
ln -sf $gffcompare .
./gffcompare -M -N -r `basename $ref` taco.gtf
./gffcompare -r `basename $ref` taco.gtf -o gffall

refnum1=`cat gffcmp.stats | grep Reference | grep mRNA | head -n 1 | awk '{print $5}'`
refnum2=`cat gffall.stats | grep Reference | grep mRNA | head -n 1 | awk '{print $5}'`

$gtfcuff roc gffcmp.taco.gtf.tmap $refnum1 cov > roc.mul
$gtfcuff roc gffall.taco.gtf.tmap $refnum2 cov > roc.all

cd -
