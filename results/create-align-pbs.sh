#!/bin/bash

dir=/gpfs/group/mxs2589/default/shared/projects/meta-scallop-test/results
pbsdir=$dir/align-pacbio-sub-pbs
mkdir -p $pbsdir

fastq=/gpfs/group/mxs2589/default/shared/data/pacbio/pacbio-100/fastq-sub-28
results=/gpfs/group/mxs2589/default/shared/data/pacbio/pacbio-100/align-sub-28

threads="5"

for k in `ls $fastq | grep fastq`
do
	id=${k/.fastq/}
	pbsfile=$pbsdir/$id.pbs
	cur=$results/$id

	echo "#!/bin/bash" > $pbsfile
	echo "#PBS -l nodes=1:ppn=$threads" >> $pbsfile
	echo "#PBS -l mem=128gb" >> $pbsfile
	echo "#PBS -l walltime=24:00:00" >> $pbsfile
	echo "#PBS -A mxs2589_b_g_hc_default" >> $pbsfile
	
	echo "`pwd`/align-pacbio-sub.sh $id $fastq/$k $cur $threads" >> $pbsfile
done
