#!/bin/bash

if [ "$#" != "6" ]; then
	echo "usage $0 run-id threads bam-list cur-dir exe ref"
	exit
fi

id=$1
threads=$2
list=$3
cur=$4
meta=$5
ref=$6

gtfcuff=/home/mxs2589/shared/bin/gtfcuff
gffcompare=/home/mxs2589/shared/tools/gffcompare/gffcompare-0.11.2.Linux_x86_64/gffcompare
#ref=/home/mxs2589/shared/data/ensembl/release-97/GRCh38/Homo_sapiens.GRCh38.97.gtf
#numref=199669

mkdir -p $cur
cd $cur

mkdir -p gtf
mkdir -p bam
cp $list bam.list

{ /usr/bin/time -v $meta -i bam.list -o meta.gtf -t $threads -d gtf > $cur/meta.log ; } 2> $cur/meta.time

ln -sf $ref .
ln -sf $gffcompare .
./gffcompare -M -N -r `basename $ref` meta.gtf
./gffcompare -r `basename $ref` meta.gtf -o gffall

refnum1=`cat gffcmp.stats | grep Reference | grep mRNA | head -n 1 | awk '{print $5}'`
refnum2=`cat gffall.stats | grep Reference | grep mRNA | head -n 1 | awk '{print $5}'`

$gtfcuff roc gffcmp.meta.gtf.tmap $refnum1 cov > roc.mul
$gtfcuff roc gffall.meta.gtf.tmap $refnum2 cov > roc.all

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
