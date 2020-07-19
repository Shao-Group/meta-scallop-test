#!/bin/bash

gtfcuff=~/shared/bin/gtfcuff

while getopts "d:D:n:" arg
do
	case $arg in 
	d) 
		results1=$OPTARG
		;;
	D) 
		results2=$OPTARG
		;;
	n) 
		num=$OPTARG
		;;
	esac
done

for x in `seq 0 $num`
do
	id=$x
	gff1=$results1/$id.all
	map1=$results1/$id.all.$id.gtf.tmap

	inf1=`cat $gff1 | grep Query | grep mRNAs | head -n 1 | awk '{print $5}'`
	ref1=`cat $gff1 | grep Reference | grep mRNA | head -n 1 | awk '{print $5}'`
	cor1=`cat $gff1 | grep Matching | grep transcripts | head -n 1 | awk '{print $3}'`

	sen1=`echo "scale = 2; 100 * $cor1 / $ref1" | bc`
	pre1=`echo "scale = 2; 100 * $cor1 / $inf1" | bc`


#let id=$id+50
	gff2=$results2/$id.all
	map2=$results2/$id.all.$id.gtf.tmap

	inf2=`cat $gff2 | grep Query | grep mRNAs | head -n 1 | awk '{print $5}'`
	ref2=`cat $gff2 | grep Reference | grep mRNA | head -n 1 | awk '{print $5}'`
	cor2=`cat $gff2 | grep Matching | grep transcripts | head -n 1 | awk '{print $3}'`

	sen2=`echo "scale = 2; 100 * $cor2 / $ref2" | bc`
	pre2=`echo "scale = 2; 100 * $cor2 / $inf2" | bc`

#echo "AAAAAAAA $id $inf1 $ref1 $cor1 $sen1 $pre1 $inf2 $ref2 $cor2 $sen2 $pre2 AAAAAAAAA"

	m1=""
	if [ "$cor1" -gt "$cor2" ]; then
		line=`$gtfcuff match-correct $map1 $ref1 $cor2`
		mx1=`echo $line | cut -f 13 -d " "`
		mx2=`echo $line | cut -f 16 -d " "`
		m1="$mx1 $mx2 $pre2"
	else
		line=`$gtfcuff match-correct $map2 $ref2 $cor1`
		mx1=`echo $line | cut -f 13 -d " "`
		mx2=`echo $line | cut -f 16 -d " "`
		m1="$mx1 $pre1 $mx2"
	fi

	m2=""
	if (( $(echo "$pre1 < $pre2" | bc -l) )); then
		line=`$gtfcuff match-precision $map1 $ref1 $pre2`
		mx1=`echo $line | cut -f 13 -d " "`
		mx2=`echo $line | cut -f 16 -d " "`
		m2="$mx2 $mx1 $sen2"
	else
		line=`$gtfcuff match-precision $map2 $ref2 $pre1`
		mx1=`echo $line | cut -f 13 -d " "`
		mx2=`echo $line | cut -f 16 -d " "`
		m2="$mx2 $sen1 $mx1"
	fi

	echo "$id $inf1 $ref1 $cor1 $pre1 $inf2 $ref2 $cor2 $pre2 $m1 $m2"
done
