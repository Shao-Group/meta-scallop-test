#!/bin/bash

if [ "$#" != "1" ]; then
	echo "usage $0 run-id"
	exit
fi

dir=/home/mxs2589/shao/project/aletsch-test
rdir=$dir/results
cur=$rdir/$1
mkdir -p $cur

list=$dir/data/sra-100-hisat-ref.list
chrs=$dir/data/sra-chr.list

ref=/home/mxs2589/shared/data/ensembl/release-97/GRCh38/Homo_sapiens.GRCh38.97.gtf
refnum=199669

threads=4
numjobs=5

metadir=/home/mxs2589/shao/project/aletsch
cd $metadir
mid=`git log | grep commit | head -n 1 | cut -f 2 -d " " | cut -c 1-6`
meta=$cur/aletsch-$mid
cp $metadir/build/aletsch $meta
cd -

scripts=$cur/split.jobs
rm -rf $scripts
for kk in `seq 1 10`
do
	cdir=$cur/$kk
	mkdir -p $cdir
	let aa=$kk*10
	cat $list | head -n $aa | tail -n 10 > $cdir/list

	echo "$rdir/aletsch-step3.sh $rdir $threads $numjobs $cdir/list $chrs $cdir $meta $ref $refnum" >> $scripts
done

cat $scripts | xargs -L 1 -P 10 -I CMD bash -c CMD
