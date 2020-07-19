#!/bin/bash

if [ "$#" != "4" ]; then
	echo "usage $0 threads gtf-list cur-dir ref"
	exit
fi

threads=$1
gtflist=$2
cur=$3
ref=$4

stringtie=/storage/home/mxs2589/shared/tools/stringtie/stringtie-2.1.3b.Linux_x86_64/stringtie
gtfcuff=/storage/home/mxs2589/shared/bin/gtfcuff
gffcompare=/storage/home/mxs2589/shared/tools/gffcompare/gffcompare-0.11.2.Linux_x86_64/gffcompare

#gtfcuff=/home/mxs2589/shared/bin/gtfcuff
#gffcompare=/home/mxs2589/shared/tools/gffcompare/gffcompare-0.11.2.Linux_x86_64/gffcompare

cd $cur
{ /usr/bin/time -v $stringtie --merge -o stringtie.gtf $gtflist > stringtie.log ; } 2> stringtie.time

#cat stringtie/assembly.gtf | sed 's/expr/cov/g' > stringtie.gtf

ln -sf $ref .
ln -sf $gffcompare .
./gffcompare -M -N -r `basename $ref` stringtie.gtf
./gffcompare -r `basename $ref` stringtie.gtf -o gffall

refnum1=`cat gffcmp.stats | grep Reference | grep mRNA | head -n 1 | awk '{print $5}'`
refnum2=`cat gffall.stats | grep Reference | grep mRNA | head -n 1 | awk '{print $5}'`

$gtfcuff roc gffcmp.stringtie.gtf.tmap $refnum1 cov > roc.mul
$gtfcuff roc gffall.stringtie.gtf.tmap $refnum2 cov > roc.all

cd -
