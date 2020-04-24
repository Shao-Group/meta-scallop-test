#!/bin/bash

if [ "$#" != "1" ]; then
	echo "usage $0 run-id"
	exit
fi

#ref=/home/mxs2589/shared/data/ensembl/release-97/GRCh38/Homo_sapiens.GRCh38.97.gtf
ref=/home/mxs2589/shao/project/meta-scallop-test/data/ensembl/GRCh38.gtf
gffcompare=/home/mxs2589/shared/tools/gffcompare/gffcompare-0.11.2.Linux_x86_64/gffcompare
metadir=/home/mxs2589/shao/project/meta-scallop
#metadir=/home/mxs2589/shao/project/meta-scallop-test/meta-scallop
dir=/home/mxs2589/shao/project/meta-scallop-test
list=$dir/data/encode10.star.list

bin=$dir/programs
mkdir -p $bin

cd $metadir
mid=`git log | grep commit | head -n 1 | cut -f 2 -d " " | cut -c 1-6`
cd -

meta=$bin/meta-scallop-$mid

if [ ! -f $meta ]; then
	cp $metadir/meta/meta-scallop $meta
fi

cur=$dir/results/encode10-$1
mkdir -p $cur

cd $cur

#mkdir -p gtf
#{ /usr/bin/time -v $meta -i $list -o $cur/meta.gtf -t 20 -b 10 -c 10 -s 0.3 -d gtf --single_sample_multiple_threading > $cur/meta.log ; } 2> $cur/meta.time
#
#ln -sf $ref .
#ln -sf $gffcompare .
#./gffcompare -M -N -r `basename $ref` meta.gtf
#gtfcuff roc gffcmp.meta.gtf.tmap 199669 cov > roc

cd gtf
rm -rf gff-scripts

for k in `seq 0 9`
do
	echo "./gffcompare -M -N -r `basename $ref` -o $k $k.gtf" >> gff-scripts
done

ln -sf $ref .
ln -sf $gffcompare .

cat gff-scripts | xargs -L 1 -I CMD -P 10 bash -c CMD 1> /dev/null 2> /dev/null &
