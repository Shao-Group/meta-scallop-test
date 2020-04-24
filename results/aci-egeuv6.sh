#!/bin/bash

if [ "$#" != "2" ]; then
	echo "usage $0 run-id param"
	exit
fi

#ref=/home/mxs2589/shared/data/ensembl/release-97/GRCh38/Homo_sapiens.GRCh38.97.gtf
ref=/storage/home/mxs2589/shared/data/gencode/GRCh37/gencode.v33lift37.annotation.gtf
gffcompare=/storage/home/mxs2589/shared/tools/gffcompare/gffcompare-0.11.2.Linux_x86_64/gffcompare
metadir=/storage/home/mxs2589/shao/projects/meta-scallop
dir=/storage/home/mxs2589/shao/projects/meta-scallop-test

list=$dir/data/egeuv6.list

bin=$dir/programs
mkdir -p $bin

cd $metadir
mid=`git log | grep commit | head -n 1 | cut -f 2 -d " " | cut -c 1-6`
cd -

meta=$bin/meta-scallop-$mid

if [ ! -f $meta ]; then
	cp $metadir/meta/meta-scallop $meta
fi

cur=$dir/results/egeuv6-$1
mkdir -p $cur

cd $cur
{ /usr/bin/time -v $meta -i $list -o $cur/meta.gtf -t 19 -b 100 -c $2 -s 0.3  > $cur/meta.log ; } 2> $cur/meta.time

ln -sf $ref .
ln -sf $gffcompare .
./gffcompare -M -N -r `basename $ref` meta.gtf
gtfcuff roc gffcmp.meta.gtf.tmap 200827 cov > roc
