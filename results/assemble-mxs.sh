#!/bin/bash

if [ "$#" != "1" ]; then
	echo "usage $0 run-id"
	exit
fi

dir=/home/mxs2589/shao/project/aletsch-test
gffcompare=/home/mxs2589/shared/tools/gffcompare/gffcompare-0.11.2.Linux_x86_64/gffcompare
metadir=/home/mxs2589/shao/project/aletsch

list=$dir/data/sra-100-star-ref.list
chrs=$dir/data/sra-chr.list

ref=/home/mxs2589/shared/data/ensembl/release-97/GRCh38/Homo_sapiens.GRCh38.97.gtf
numref=199669

n=`cat $list | wc -l`
let maxid=$n-1

threads=10
numjobs=8

cd $metadir
mid=`git log | grep commit | head -n 1 | cut -f 2 -d " " | cut -c 1-6`
cd -

cur=$dir/results/$1
mkdir -p $cur

meta=$cur/aletsch-$mid
cp $metadir/build/aletsch $meta

# step 1: generate profiles

cd $cur
mkdir -p pro
cp $list bam.list
{ /usr/bin/time -v $meta -i bam.list -t $threads -p pro --profile > $cur/meta.log ; } 2> $cur/meta.time
cd -

# step 2: assemble individual chrms

rm -rf $cur/chrs.jobs
for k in `cat $chrs`
do
	id=`echo $k | cut -c 1-6`
	echo "$dir/results/run-chrm.sh $1 $threads $list $k $cur/pro $cur/$id $meta $ref $refnum" >> $cur/chrs.jobs
done
cat $cur/chrs.jobs | xargs -L 1 -P $numjobs -I CMD bash -c CMD

# step 3: merge and evaluate

cd $cur
mkdir -p gtf
rm -rf meta.gtf
rm -rf gtf/*
for k in `cat $chrs`
do
	id=`echo $k | cut -c 1-6`
	cat $cur/$id/meta.gtf >> $cur/meta.gtf
	for j in `seq 0 $maxid`
	do
		cat $cur/$id/gtf/$j.gtf >> $cur/gtf/$j.gtf
	done
done

ln -sf $ref .
ln -sf $gffcompare .
./gffcompare -M -N -r `basename $ref` meta.gtf
gtfcuff roc gffcmp.meta.gtf.tmap $numref cov > roc
./gffcompare -r `basename $ref` meta.gtf -o gffall

cd $cur/gtf
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

#cd bam
#rm -rf bam-scripts
#
#for k in `seq 0 $maxid`
#do
#	echo "$dir/results/run-scallop.sh $cur/bam $k" >> bam-scripts
#done
#
#ln -sf $ref .
#ln -sf $gffcompare .
#
#cat bam-scripts | xargs -L 1 -I CMD -P $threads bash -c CMD 1> /dev/null 2> /dev/null &
#cd -
