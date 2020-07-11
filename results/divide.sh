#!/bin/bash

if [ "$#" != "1" ]; then
	echo "usage $0 run-id"
	exit
fi

dir=/home/mxs2589/shao/project/aletsch-test
gffcompare=/home/mxs2589/shared/tools/gffcompare/gffcompare-0.11.2.Linux_x86_64/gffcompare
metadir=/home/mxs2589/shao/project/aletsch

list=$dir/data/sra-100-hisat-ref.list
#list=$dir/data/egeuv6.list
#list=$dir/data/encode10.star.list
#list=$dir/data/egeuv6-100.list
#list=$dir/data/simulation.list
#list=$dir/data/mixed.list3

ref=/home/mxs2589/shared/data/ensembl/release-97/GRCh38/Homo_sapiens.GRCh38.97.gtf
#ref=/home/mxs2589/shared/data/gencode/GRCh37/gencode.v33lift37.annotation.gtf
#ref=/home/mxs2589/shared/data/gencode/GRCh38/gencode.v33.annotation.gtf
#ref=/home/mxs2589/shao/project/aletsch-test/data/ensembl/GRCh38.gtf

n=`cat $list | wc -l`
#cluster=$n
#threads=$n
#numref=199669

threads=10
cluster=10
#numref=200827
numref=199669

bin=$dir/programs
mkdir -p $bin

cd $metadir
mid=`git log | grep commit | head -n 1 | cut -f 2 -d " " | cut -c 1-6`
cd -

meta=$bin/aletsch-$mid
cp $metadir/build/aletsch $meta

for kk in `seq 1 10`
do
	cur=$dir/results/$1/$kk
	mkdir -p $cur
	cd $cur

	let aa=$kk*10
	cat $list | head -n $aa | tail -n 10 > bam.list

	mkdir -p gtf
	mkdir -p bam

	{ /usr/bin/time -v $meta -i bam.list -o $cur/meta.gtf -t $threads -d gtf > $cur/meta.log ; } 2> $cur/meta.time
	
	let num=$n-1
	
	ln -sf $ref .
	ln -sf $gffcompare .
	./gffcompare -M -N -r `basename $ref` meta.gtf
	gtfcuff roc gffcmp.meta.gtf.tmap $numref cov > roc
	
	./gffcompare -r `basename $ref` meta.gtf -o gffall
	
	cd gtf
	rm -rf gff-scripts
	
	for k in `seq 0 $num`
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
	
	for k in `seq 0 $num`
	do
		echo "$dir/results/run-scallop.sh $cur/bam $k" >> bam-scripts
	done
	
	ln -sf $ref .
	ln -sf $gffcompare .
	
	cat bam-scripts | xargs -L 1 -I CMD -P $threads bash -c CMD 1> /dev/null 2> /dev/null &
	cd -
done
