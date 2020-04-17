#!/bin/bash

if [ "$#" != "1" ]; then
	echo "usage $0 run-id"
	exit
fi

#ref=/home/mxs2589/shared/data/ensembl/release-97/GRCh38/Homo_sapiens.GRCh38.97.gtf
ref=/home/mxs2589/shared/data/gencode/GRCh37/gencode.v33lift37.annotation.gtf
gffcompare=/home/mxs2589/shared/tools/gffcompare/gffcompare-0.11.2.Linux_x86_64/gffcompare
metadir=/home/mxs2589/shao/project/meta-scallop
dir=/home/mxs2589/shao/project/meta-scallop-test
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
{ /usr/bin/time -v $meta -i $list -o $cur/meta.gtf -t 60 -m 50 --merge_threshold 0.3 --max_combined 50 --single_sample_multiple_threading > $cur/meta.log ; } 2> $cur/meta.time

ln -sf $ref .
ln -sf $gffcompare .
./gffcompare -M -N -r `basename $ref` meta.gtf
gtfcuff roc gffcmp.meta.gtf.tmap 200827 cov > roc
