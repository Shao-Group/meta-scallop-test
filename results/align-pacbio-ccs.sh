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

{ /usr/bin/time $minimap2 -t $threads -ax splice:hq $ref $fastq 1> $cur/$id.sam 2> $cur/$id.log ; } 2> $cur/$id.time

#samtools view --threads 20 -S -b $results/$id.sam > $results/$id.bam
#samtools sort --threads 20 $results/$id.bam -o $results/$id.sorted.bam
