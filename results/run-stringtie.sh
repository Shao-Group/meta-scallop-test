#!/bin/bash

if [ "$#" != "3" ]; then
	echo "usage $0 cur bam sid"
	exit
fi

exe=/home/mxs2589/shared/tools/stringtie/stringtie
ref=/home/mxs2589/shared/data/ensembl/release-97/GRCh38/Homo_sapiens.GRCh38.97.gtf
gffcompare=/home/mxs2589/shared/tools/gffcompare/gffcompare-0.11.2.Linux_x86_64/gffcompare
cur=$1
bam=$2
sid=$3

mkdir -p $cur
cd $cur

{ /usr/bin/time -v $exe $bam -o $sid.gtf > $sid.log; } 2> $sid.time

ln -sf $gffcompare .
ln -sf $ref .

$gffcompare -M -N -r `basename $ref` $sid.gtf -o $sid
$gffcompare -r `basename $ref` $sid.gtf -o $sid.all

cd -
