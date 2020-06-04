#!/bin/bash

dir=/gpfs/group/mxs2589/default/shared/projects/meta-scallop-test/results
pbsdir=$dir/align-pacbio-sub-pbs
mkdir -p $pbsdir

fastq=/gpfs/group/mxs2589/default/shared/data/pacbio/2k-pacbio/fastq-sub
results=/gpfs/group/mxs2589/default/shared/data/pacbio/2k-pacbio/align-sub
threads="10"

for k in `ls $fastq | grep fastq`
do
	id=${k/.fastq/}
	pbsfile=$pbsdir/$id.pbs
	cur=$results/$id

	echo "#!/bin/bash" > $pbsfile
	echo "#PBS -l nodes=1:ppn=$threads" >> $pbsfile
	echo "#PBS -l mem=120gb" >> $pbsfile
	echo "#PBS -l walltime=2:00:00" >> $pbsfile
	echo "#PBS -A mxs2589_b_g_sc_default" >> $pbsfile
	
	echo "`pwd`/align-pacbio-sub.sh $id $fastq/$k $cur $threads" >> $pbsfile
done
