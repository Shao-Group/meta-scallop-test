#!/bin/bash

if [ "$#" != "6" ]; then
	echo "usage $0 run-id threads bam-list chrm-list ref-annotation ref-number"
	exit
fi

id=$1
threads=$2
list=$3
chrm=$4
ref=$5
refnum=$6

dir=/gpfs/group/mxs2589/default/shared/projects/aletsch-test
gffcompare=/gpfs/group/mxs2589/default/shared/tools/gffcompare/gffcompare-0.11.2.Linux_x86_64/gffcompare

samples=`cat $list | wc -l`
let maxid=$samples-1

cur=$dir/results/$id
mkdir -p $cur

cd $cur

mkdir -p gtf
rm -rf meta.gtf
rm -rf gtf/*
for k in `cat $chrm`
do
	cat $cur/$k/meta.gtf >> $cur/meta.gtf
	for j in `seq 0 $maxid`
	do
		cat $cur/$k/gtf/$j.gtf >> $cur/gtf/$j.gtf
	done
done

ln -sf $ref .
ln -sf $gffcompare .
./gffcompare -M -N -r `basename $ref` meta.gtf
gtfcuff roc gffcmp.meta.gtf.tmap $refnum cov > roc

./gffcompare -r `basename $ref` meta.gtf -o gffall

cd gtf
rm -rf gff-scripts

for k in `seq 0 $maxid`
do
	echo "./gffcompare -M -N -r `basename $ref` -o $k $k.gtf" >> gff-scripts
	echo "./gffcompare -r `basename $ref` -o $k.all $k.gtf" >> gff-scripts
done

ln -sf $ref .
ln -sf $gffcompare .

cat gff-scripts | xargs -L 1 -I CMD -P $threads bash -c CMD 1> /dev/null 2> /dev/null &
cd -

cd bam
rm -rf bam-scripts

for k in `seq 0 $maxid`
do
	echo "$dir/results/run-scallop.sh $cur/bam $k" >> bam-scripts
done

ln -sf $ref .
ln -sf $gffcompare .

cat bam-scripts | xargs -L 1 -I CMD -P $threads bash -c CMD 1> /dev/null 2> /dev/null &
