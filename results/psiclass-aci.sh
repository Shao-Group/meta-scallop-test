#!/bin/bash

#id="sra-hisat-ref-A02"
id="gtex2377-psi01"
cores="40"
threads="80"

dir=`pwd`
cur=$dir/$id

list=/gpfs/group/mxs2589/default/qqz5133/gtex/meta-scallop/bamlist/2377.txt
#list=/storage/home/mxs2589/shared/projects/aletsch-test/data/sra-100-hisat-ref.list

ref=/storage/home/mxs2589/shared/data/gencode/GRCh38/gencode.v33.annotation.gtf

#ref=/gpfs/group/mxs2589/default/shared/data/ensembl/release-97/GRCh38/Homo_sapiens.GRCh38.97.gtf
#refnum=199669 # ensembl v97

mkdir -p $cur
pbsfile=$cur/psiclass.pbs

echo "#!/bin/bash" > $pbsfile
echo "#PBS -l nodes=1:ppn=$cores" >> $pbsfile
echo "#PBS -l mem=200gb" >> $pbsfile
echo "#PBS -l walltime=200:00:00" >> $pbsfile
echo "#PBS -A mxs2589_b_g_hc_default" >> $pbsfile
echo "$dir/psiclass.sh $threads $list $cur $ref" >> $pbsfile

cd $cur
qsub $pbsfile
cd -
