#!/bin/bash

if [ "$#" != "6" ]; then
	echo "usage $0 run-id threads bam-list chrm pro-dir cur-dir"
	exit
fi

id=$1
threads=$2
list=$3
chrm=$4
pro=$5
cur=$6
mkdir -p $cur

dir=/gpfs/group/mxs2589/default/shared/projects/aletsch-test
metadir=/gpfs/group/mxs2589/default/shared/projects/aletsch

cd $metadir
mid=`git log | grep commit | head -n 1 | cut -f 2 -d " " | cut -c 1-6`
cd -

meta=$cur/aletsch-$mid
cp $metadir/build/aletsch $meta

cd $cur

mkdir -p gtf
mkdir -p bam
cp $list bam.list
{ /usr/bin/time -v $meta -i bam.list -l $chrm -o meta.gtf -p $pro -t $threads -d gtf > $cur/meta.log ; } 2> $cur/meta.time
#{ /usr/bin/time -v $meta -i bam.list -l $chrm -o meta.gtf -p $pro -t $threads -d gtf --boost_precision > $cur/meta.log ; } 2> $cur/meta.time
