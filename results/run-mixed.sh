#!/bin/bash

if [ "$#" != "4" ]; then
	echo "usage $0 run-id threads bam-list chrm-list"
	exit
fi

dir=/gpfs/group/mxs2589/default/shared/projects/aletsch-test
#list=$dir/data/mixed.list1
list=$3
chrm=$4

ref=/gpfs/group/mxs2589/default/shared/data/gencode/GRCh37/gencode.v33lift37.annotation.gtf
#ref=/gpfs/group/mxs2589/default/shared/data/ensembl/release-97/GRCh38/Homo_sapiens.GRCh38.97.gtf
gffcompare=/gpfs/group/mxs2589/default/shared/tools/gffcompare/gffcompare-0.11.2.Linux_x86_64/gffcompare
metadir=/gpfs/group/mxs2589/default/shared/projects/aletsch

samples=`cat $list | wc -l`
threads=$2

bin=$dir/programs
mkdir -p $bin

cd $metadir
mid=`git log | grep commit | head -n 1 | cut -f 2 -d " " | cut -c 1-6`
cd -

cur=$dir/results/mixed-$1
mkdir -p $cur

meta=$cur/aletsch-$mid
cp $metadir/build/aletsch $meta

cd $cur

mkdir -p gtf
mkdir -p bam
mkdir -p pro
cp $list bam.list
cp $chrm chr.list

{ /usr/bin/time -v $meta -i bam.list -L chr.list -o meta.gtf -p pro -t $threads > $cur/meta.log ; } 2> $cur/meta.time
#{ /usr/bin/time -v $meta -i bam.list -o $cur/meta.gtf -t $threads -d gtf > $cur/meta.log ; } 2> $cur/meta.time
#gdb -batch -ex "run" -ex "bt" --args $meta -i bam.list -o $cur/meta.gtf -t $threads -d gtf 2>&1 > $cur/gdb.log

exit

let maxid=$samples-1

refnum=200827
#refnum=199669

ln -sf $ref .
ln -sf $gffcompare .
./gffcompare -M -N -r `basename $ref` meta.gtf
gtfcuff roc gffcmp.meta.gtf.tmap $refnum cov > roc

./gffcompare -r `basename $ref` meta.gtf -o gffall

cd gtf
rm -rf gff-scripts

for k in `seq 0 $maxid`
do
	echo "./gffcompare -M -N -r `basename $ref` -o $k $k.gtf" >> gff-scripts
	echo "./gffcompare -r `basename $ref` -o $k.all $k.gtf" >> gff-scripts
done

ln -sf $ref .
ln -sf $gffcompare .

cat gff-scripts | xargs -L 1 -I CMD -P $threads bash -c CMD 1> /dev/null 2> /dev/null &
cd -

cd bam
rm -rf bam-scripts

for k in `seq 0 $maxid`
do
	echo "$dir/results/run-scallop.sh $cur/bam $k" >> bam-scripts
done

ln -sf $ref .
ln -sf $gffcompare .

cat bam-scripts | xargs -L 1 -I CMD -P $threads bash -c CMD 1> /dev/null 2> /dev/null &
