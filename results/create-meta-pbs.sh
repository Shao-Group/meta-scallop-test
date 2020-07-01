#!/bin/bash

id="G10"
cores="20"
threads="40"
pbsfile=`pwd`/meta-"$id".pbs
#list=/gpfs/group/mxs2589/default/shared/projects/meta-scallop-test/data/gtex-100.list
#list=/gpfs/group/mxs2589/default/qqz5133/gtex/meta-scallop/bamlist/2377.txt
list=/gpfs/group/mxs2589/default/qqz5133/gtex/meta-scallop/bamlist/100.txt
chrm=/gpfs/group/mxs2589/default/qqz5133/gtex/meta-scallop/bamlist/chr.list

echo "#!/bin/bash" > $pbsfile
echo "#PBS -l nodes=1:ppn=$cores" >> $pbsfile
echo "#PBS -l mem=250gb" >> $pbsfile
echo "#PBS -l walltime=240:00:00" >> $pbsfile
echo "#PBS -A mxs2589_b_g_sc_default" >> $pbsfile

echo "`pwd`/run-mixed.sh $id $threads $list $chrm" >> $pbsfile
