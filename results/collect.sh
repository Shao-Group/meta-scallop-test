#!/bin/bash

while getopts "x:" arg
do
	case $arg in 
	x) 
		suffix=$OPTARG
		;;
	esac
done

list=../data/encode10.star.list
results=encode10-$suffix

echo "#accession #total #correct sensitivity(%) precision(%)"

let k=0
for x in `cat $list`
do
	id=`echo $x | cut -f 1 -d ":"`
	ss=`echo $x | cut -f 2 -d ":"`
	gm=`echo $x | cut -f 3 -d ":"`

	x0=`cat $results/gtf/$k.stats | grep Query | grep mRNAs | head -n 1 | awk '{print $5}'`
	x1=`cat $results/gtf/$k.stats | grep Matching | grep intron | grep chain | head -n 1 | awk '{print $4}'`
	x2=`cat $results/gtf/$k.stats | grep Intron | grep chain | head -n 1 | awk '{print $4}'`
	x3=`cat $results/gtf/$k.stats | grep Intron | grep chain | head -n 1 | awk '{print $6}'`

	if [ "$x0" == "" ]; then x0="0"; fi
	if [ "$x1" == "" ]; then x1="0"; fi
	if [ "$x2" == "" ]; then x2="0"; fi
	if [ "$x3" == "" ]; then x3="0"; fi

	echo "$id $aa $x0 $x1 $x2 $x3"
	let k=$k+1
done
