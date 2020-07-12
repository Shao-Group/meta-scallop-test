#!/bin/bash

if [ "$#" != "6" ]; then
	echo "usage $0 run-id threads bam-list cur-dir pro-name exe"
	exit
fi

id=$1
threads=$2
list=$3
cur=$4
pro=$5
meta=$6

mkdir -p $cur
cd $cur

cp $list bam.list
{ /usr/bin/time -v $meta -i bam.list -p $pro -t $threads --profile > $cur/meta.log ; } 2> $cur/meta.time

cd -
