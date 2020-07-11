#!/bin/bash

if [ "$#" != "1" ]; then
	echo "usage $0 run-id"
	exit
fi

dir=/home/mxs2589/shao/project/aletsch-test
list=$dir/data/sra-100-star-ref.list
#list=$dir/data/egeuv6.list
#list=$dir/data/encode10.star.list
#list=$dir/data/egeuv6-100.list
#list=$dir/data/simulation.list
#list=$dir/data/mixed.list3

scripts=scripts.st
cur=$dir/results/$1
rm -rf $scripts
for kk in `seq 1 100`
do
	let sid=$kk-1
	bam=`cat $list | head -n $kk | tail -n 1 | cut -f 1 -d " "`
	echo "$dir/results/run-scallop.sh $cur $bam $sid" >> $scripts
done

nohup cat $scripts | xargs -L 1 -I CMD -P 40 bash -c CMD 1> /dev/null 2> /dev/null &
