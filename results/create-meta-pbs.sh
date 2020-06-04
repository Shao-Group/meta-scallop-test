#!/bin/bash

dir=/gpfs/group/mxs2589/default/shared/projects/meta-scallop-test/results

id="A03"
threads="40"
pbsfile=`pwd`/meta-"$id".pbs
echo "#!/bin/bash" > $pbsfile
echo "#PBS -l nodes=1:ppn=$threads" >> $pbsfile
echo "#PBS -l mem=200gb" >> $pbsfile
echo "#PBS -l walltime=10:00:00" >> $pbsfile
echo "#PBS -A mxs2589_b_g_sc_default" >> $pbsfile

echo "`pwd`/run-mixed.sh $id $threads" >> $pbsfile
