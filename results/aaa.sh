#!/bin/bash

if [ "$#" != "1" ]; then
	echo "usage $0 run-id"
	exit
fi

#dir=/home/mxs2589/shao/project/aletsch-test
#list=$dir/data/sra-100-star-ref.list

dir=/gpfs/group/mxs2589/default/shared/projects/aletsch-test
list=/gpfs/group/mxs2589/default/qqz5133/gtex/meta-scallop/bamlist/2377.txt

cur=$dir/results/$1
pbsdir=$cur/pbs
mkdir -p $pbsdir

for kk in `seq 1 2377`
do
	let sid=$kk-1
	bam=`cat $list | head -n $kk | tail -n 1 | cut -f 1 -d " "`
	pbsfile=$pbsdir/$sid.pbs

	n=`cat $cur/$sid.time | grep terminated | wc -l`

	if [ "$n" == "0" ]; then
		continue;
	fi

	cat $cur/$sid.time | grep "Max" | grep resident
done
