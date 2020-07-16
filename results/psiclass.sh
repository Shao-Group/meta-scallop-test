#!/bin/bash

if [ "$#" != "4" ]; then
	echo "usage $0 threads bam-list cur-dir ref"
	exit
fi

threads=$1
list=$2
cur=$3
ref=$4

#gtfcuff=/home/mxs2589/shared/bin/gtfcuff
#gffcompare=/home/mxs2589/shared/tools/gffcompare/gffcompare-0.11.2.Linux_x86_64/gffcompare
psi=/storage/home/mxs2589/shared/tools/PsiCLASS/psiclass
gtfcuff=/storage/home/mxs2589/shared/bin/gtfcuff
gffcompare=/storage/home/mxs2589/shared/tools/gffcompare/gffcompare-0.11.2.Linux_x86_64/gffcompare

mkdir -p $cur
cd $cur

cat $list | cut -f 1 -d " " > bam.list
{ /usr/bin/time -v $psi --lb bam.list -p $threads -o psiclass.gtf > psiclass.log; } 2> time.log

ln -sf psiclass.gtf_vote.gtf psiclass.gtf

ln -sf $ref .
ln -sf $gffcompare .
./gffcompare -M -N -r `basename $ref` psiclass.gtf
./gffcompare -r `basename $ref` psiclass.gtf -o gffall

refnum1=`cat gffcmp.stats | grep Reference | grep mRNA | head -n 1 | awk '{print $5}'`
refnum2=`cat gffall.stats | grep Reference | grep mRNA | head -n 1 | awk '{print $5}'`

$gtfcuff roc gffcmp.psiclass.gtf.tmap $refnum1 cov > roc.mul
$gtfcuff roc gffall.psiclass.gtf.tmap $refnum2 cov > roc.all

cd -
