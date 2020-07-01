#!/bin/bash

if [ "$#" != "3" ]; then
	echo "usage $0 run-id threads bam-list"
	exit
fi

id=$1
threads=$2
list=$3

dir=/gpfs/group/mxs2589/default/shared/projects/aletsch-test
metadir=/gpfs/group/mxs2589/default/shared/projects/aletsch

samples=`cat $list | wc -l`

bin=$dir/programs
mkdir -p $bin

cd $metadir
mid=`git log | grep commit | head -n 1 | cut -f 2 -d " " | cut -c 1-6`
cd -

cur=$dir/results/$id
mkdir -p $cur

meta=$cur/aletsch-$mid
cp $metadir/build/aletsch $meta

cd $cur

mkdir -p pro
cp $list bam.list

{ /usr/bin/time -v $meta -i bam.list -p pro -t $threads --profile > $cur/meta.log ; } 2> $cur/meta.time
