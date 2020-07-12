#!/bin/bash

if [ "$#" != "1" ]; then
	echo "usage $0 run-id"
	exit
fi

dir=/home/mxs2589/shao/project/aletsch-test
rdir=$dir/results
cur=$rdir/$1

list=$dir/data/sra-100-star-ref.list
chrs=$dir/data/sra-chr.list

ref=/home/mxs2589/shared/data/ensembl/release-97/GRCh38/Homo_sapiens.GRCh38.97.gtf
numref=199669

threads=8
numjobs=10

metadir=/home/mxs2589/shao/project/aletsch
meta=$cur/aletsch-$mid
cd $metadir
mid=`git log | grep commit | head -n 1 | cut -f 2 -d " " | cut -c 1-6`
cp $metadir/build/aletsch $meta
cd -

$rdir/aletsch-step3.sh $rdir $threads $numjobs $list $chrs $cur $meta $ref $refnum
