#!/bin/bash

if [ "$#" != "2" ]; then
	echo "usage $0 dir sid"
	exit
fi

ref=/home/mxs2589/shared/data/ensembl/release-97/GRCh38/Homo_sapiens.GRCh38.97.gtf
gffcompare=/home/mxs2589/shared/tools/gffcompare/gffcompare-0.11.2.Linux_x86_64/gffcompare
exe=/home/mxs2589/shao/project/meta-scallop-test/programs/scallop-0.10.4
cur=$1
sid=$2

cd $cur

bam=$cur/$sid.sorted.bam

samtools sort $cur/$sid.bam > $bam

{ /usr/bin/time -v $exe -i $bam -o $sid.gtf --max_num_cigar 100 > $sid.log; } 2> time.log

#ln -sf $ref .
#ln -sf $gffcompare .
./gffcompare -M -N -r `basename $ref` $sid.gtf -o $sid

cd -
