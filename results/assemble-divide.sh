#!/bin/bash

if [ "$#" != "1" ]; then
	echo "usage $0 run-id"
	exit
fi

dir=/home/mxs2589/shao/project/aletsch-test


list=$dir/data/sra-100-hisat-ref.list
ref=/home/mxs2589/shared/data/ensembl/release-97/GRCh38/Homo_sapiens.GRCh38.97.gtf
numref=199669

n=`cat $list | wc -l`
threads=10

metadir=/home/mxs2589/shao/project/aletsch
cd $metadir
mid=`git log | grep commit | head -n 1 | cut -f 2 -d " " | cut -c 1-6`
cd -
meta=$bin/aletsch-$mid
cp $metadir/build/aletsch $meta

for kk in `seq 1 10`
do
	cur=$dir/results/$1/$kk
	let aa=$kk*10
	cat $list | head -n $aa | tail -n 10 > $cur/list

	$dir/results/assemble-list.sh $1 $threads $cur/list $cur $meta $ref $refnum
done
