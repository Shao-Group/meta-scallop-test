#!/bin/bash

while getopts "x:d:" arg
do
	case $arg in 
	x) 
		n=$OPTARG
		;;
	d) 
		results=$OPTARG
		;;
	esac
done

extend="all"
extend="stats"
echo "#accession #total #correct sensitivity(%) precision(%)"

let n=$n-1
for k in `seq 0 $n`
do
	x0=`cat $results/$k.$extend | grep Query | grep mRNAs | head -n 1 | awk '{print $5}'`
	x1=`cat $results/$k.$extend | grep Matching | grep transcripts | head -n 1 | awk '{print $3}'`
	x2=`cat $results/$k.$extend | grep Transcript | grep level | head -n 1 | awk '{print $3}'`
	x3=`cat $results/$k.$extend | grep Transcript | grep level | head -n 1 | awk '{print $5}'`

	if [ "$x0" == "" ]; then x0="0"; fi
	if [ "$x1" == "" ]; then x1="0"; fi
	if [ "$x2" == "" ]; then x2="0"; fi
	if [ "$x3" == "" ]; then x3="0"; fi

	echo "$k $aa $x0 $x1 $x2 $x3"
done
