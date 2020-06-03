#!/bin/bash

if [ "$#" != "1" ]; then
	echo "usage $0 run-id"
	exit
fi

dir=/home/mxs2589/shao/project/meta-scallop-test
list=$dir/data/mixed.list3

ref=/home/mxs2589/shared/data/ensembl/release-97/GRCh38/Homo_sapiens.GRCh38.97.gtf
#ref=/home/mxs2589/shao/project/meta-scallop-test/data/ensembl/GRCh38.gtf
gffcompare=/home/mxs2589/shared/tools/gffcompare/gffcompare-0.11.2.Linux_x86_64/gffcompare
metadir=/home/mxs2589/shao/project/meta-scallop
#metadir=/home/mxs2589/shao/project/meta-scallop-test/meta-scallop

n=`cat $list | wc -l`
threads=0
let threads=$n+$n

bin=$dir/programs
mkdir -p $bin

cd $metadir
mid=`git log | grep commit | head -n 1 | cut -f 2 -d " " | cut -c 1-6`
cd -

meta=$bin/meta-scallop-$mid

cp $metadir/meta/meta-scallop $meta

cur=$dir/results/mixed-$1
mkdir -p $cur

cd $cur

mkdir -p gtf
mkdir -p bam
cp $list bam.list
{ /usr/bin/time -v $meta -i bam.list -o $cur/meta.gtf -t $threads -b $n -c $n -s 0.3 -m -d gtf > $cur/meta.log ; } 2> $cur/meta.time

let num=$n-1

ln -sf $ref .
ln -sf $gffcompare .
./gffcompare -M -N -r `basename $ref` meta.gtf
gtfcuff roc gffcmp.meta.gtf.tmap 199669 cov > roc

./gffcompare -r `basename $ref` meta.gtf -o gffall

cd gtf
rm -rf gff-scripts

for k in `seq 0 $num`
do
	echo "./gffcompare -M -N -r `basename $ref` -o $k $k.gtf" >> gff-scripts
	echo "./gffcompare -r `basename $ref` -o $k.all $k.gtf" >> gff-scripts
done

ln -sf $ref .
ln -sf $gffcompare .

cat gff-scripts | xargs -L 1 -I CMD -P $n bash -c CMD 1> /dev/null 2> /dev/null &
cd -

cd bam
rm -rf bam-scripts

for k in `seq 0 $num`
do
	echo "$dir/results/run-scallop.sh $cur/bam $k" >> bam-scripts
done

ln -sf $ref .
ln -sf $gffcompare .

cat bam-scripts | xargs -L 1 -I CMD -P $n bash -c CMD 1> /dev/null 2> /dev/null &
