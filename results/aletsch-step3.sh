#!/bin/bash

if [ "$#" != "8" ]; then
	echo "usage $0 scripts-dir threads numjobs bam-list chrm-list cur-dir exe ref"
	exit
fi

rdir=$1
threads=$2
numjobs=$3
list=$4
chrs=$5
cur=$6
meta=$7
ref=$8

# step 1: generate profiles
$rdir/aletsch-profile.sh shao $threads $list $cur pro $meta

# step 2: assemble individual chrms
rm -rf $cur/chrs.jobs
for k in `cat $chrs`
do
	id=`echo $k | cut -c 1-6`
	echo "$rdir/aletsch-chrm.sh shao $threads $list $k $cur/pro $cur/$id $meta $ref" >> $cur/chrs.jobs
done
cat $cur/chrs.jobs | xargs -L 1 -P $numjobs -I CMD bash -c CMD

# step 3: merge and evaluate
$rdir/aletsch-combine.sh shao $threads $list $chrs $cur $ref
