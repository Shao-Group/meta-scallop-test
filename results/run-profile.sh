#!/bin/bash

if [ "$#" != "4" ]; then
	echo "usage $0 run-id threads bam-list cur-dir"
	exit
fi

id=$1
threads=$2
list=$3
cur=$4

dir=/gpfs/group/mxs2589/default/shared/projects/aletsch-test
metadir=/gpfs/group/mxs2589/default/shared/projects/aletsch

cd $metadir
mid=`git log | grep commit | head -n 1 | cut -f 2 -d " " | cut -c 1-6`
cd -

meta=$cur/aletsch-$mid
cp $metadir/build/aletsch $meta

mkdir -p $cur
cd $cur

mkdir -p profiles
cp $list bam.list

{ /usr/bin/time -v $meta -i bam.list -p profiles -t $threads --profile > $cur/meta.log ; } 2> $cur/meta.time
