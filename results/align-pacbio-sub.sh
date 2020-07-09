#!/bin/bash

if [ "$#" != "4" ]; then
	echo "usage $0 id fastq result-dir threads"
	exit
fi

id=$1
fastq=$2
cur=$3
threads=$4

minimap2=/gpfs/group/mxs2589/default/shared/tools/minimap2-2.17_x64-linux/minimap2
ref=/gpfs/group/mxs2589/default/shared/data/ensembl/human/GRCh38/Homo_sapiens.GRCh38.dna.primary_assembly.fa

mkdir -p $cur

{ /usr/bin/time -v $minimap2 -t $threads -ax splice $ref $fastq 1> $cur/$id.sam 2> $cur/$id.log ; } 2> $cur/$id.time

module load gcc/5.3.1
module load samtools/1.5

samtools view --threads $threads -S -b $cur/$id.sam > $cur/$id.bam
samtools sort --threads $threads $cur/$id.bam -o $cur/$id.sorted.bam
