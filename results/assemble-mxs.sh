#!/bin/bash

if [ "$#" != "1" ]; then
	echo "usage $0 run-id"
	exit
fi

dir=/home/mxs2589/shao/project/aletsch-test
cur=$dir/results/$1
mkdir -p $cur

gffcompare=/home/mxs2589/shared/tools/gffcompare/gffcompare-0.11.2.Linux_x86_64/gffcompare

list=$dir/data/sra-100-star-ref.list
chrs=$dir/data/sra-chr.list

ref=/home/mxs2589/shared/data/ensembl/release-97/GRCh38/Homo_sapiens.GRCh38.97.gtf
numref=199669

n=`cat $list | wc -l`
let maxid=$n-1

threads=10
numjobs=8

metadir=/home/mxs2589/shao/project/aletsch
meta=$cur/aletsch-$mid
cd $metadir
mid=`git log | grep commit | head -n 1 | cut -f 2 -d " " | cut -c 1-6`
cp $metadir/build/aletsch $meta
cd -

# step 1: generate profiles
$dir/results/aletsch-profile.sh $1 $threads $list $cur pro $meta


# step 2: assemble individual chrms
rm -rf $cur/chrs.jobs
for k in `cat $chrs`
do
	id=`echo $k | cut -c 1-6`
	echo "$dir/results/aletsch-chrm.sh $1 $threads $list $k $cur/pro $cur/$id $meta $ref $refnum" >> $cur/chrs.jobs
done
cat $cur/chrs.jobs | xargs -L 1 -P $numjobs -I CMD bash -c CMD

# step 3: merge and evaluate
$dir/results/aletsch-combine.sh $1 $threads $list $chrs $cur $ref $refnum
