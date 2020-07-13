#!/bin/bash

#id="sra-hisat-ref-A02"
id="gtex2377-A10"
cores="20"
threads="40"

dir=`pwd`
cur=$dir/$id
pbsdir=$cur/pbs

list=/gpfs/group/mxs2589/default/qqz5133/gtex/meta-scallop/bamlist/2377.txt
chrm=/gpfs/group/mxs2589/default/qqz5133/gtex/meta-scallop/bamlist/chr.list

#list=/storage/home/mxs2589/shared/projects/aletsch-test/data/sra-100-hisat-ref.list
#chrm=/storage/home/mxs2589/shared/projects/aletsch-test/data/chrm.list

ref=/storage/home/mxs2589/shared/data/gencode/GRCh38/gencode.v33.annotation.gtf
refnum=200827 # gencode v33

#ref=/gpfs/group/mxs2589/default/shared/data/ensembl/release-97/GRCh38/Homo_sapiens.GRCh38.97.gtf
#refnum=199669 # ensembl v97

mkdir -p $pbsdir
cd $pbsdir

#profiles=/storage/home/mxs2589/shared/projects/aletsch-test/results/gtex500-A01/pro
#cp -r $profiles $cur/profiles

### profiling
##pbsfile=$pbsdir/profile.pbs
##echo "#!/bin/bash" > $pbsfile
##echo "#PBS -l nodes=1:ppn=$cores" >> $pbsfile
##echo "#PBS -l mem=120gb" >> $pbsfile
##echo "#PBS -l walltime=500:00:00" >> $pbsfile
##echo "#PBS -A mxs2589_b_g_sc_default" >> $pbsfile
##echo "sleep 30" >> $pbsfile
##echo "$dir/run-profile.sh $id $threads $list $cur" >> $pbsfile
##
##pid=`qsub $pbsfile | tail -n 1 | cut -f 1 -d "."`


# individual chrm
dep="afterok"
for k in `cat $chrm`
do
	kk=`echo $k | cut -c 1-6`
	pbsfile=$pbsdir/$kk
	echo "#!/bin/bash" > $pbsfile
#echo "#PBS -W depend=afterok:$pid" >> $pbsfile
	echo "#PBS -l nodes=1:ppn=$cores" >> $pbsfile
	echo "#PBS -l mem=180gb" >> $pbsfile
	echo "#PBS -l walltime=100:00:00" >> $pbsfile
	echo "#PBS -A mxs2589_b_g_sc_default" >> $pbsfile
	echo "$dir/run-chrm.sh $id $threads $list $k $cur/profiles $cur/$kk" >> $pbsfile

	kid=`qsub $pbsfile | tail -n 1 | cut -f 1 -d "."`
	dep="$dep:$kid"
done

# merge 
mergefile=$pbsdir/merge.pbs
echo "#!/bin/bash" > $mergefile
#echo "#PBS -W depend=$dep" >> $mergefile
echo "#PBS -l nodes=1:ppn=$cores" >> $mergefile
echo "#PBS -l mem=180gb" >> $mergefile
echo "#PBS -l walltime=100:00:00" >> $mergefile
echo "#PBS -A mxs2589_b_g_sc_default" >> $mergefile
echo "$dir/run-merge.sh $id $threads $list $chrm $cur $ref $refnum" >> $mergefile

#qsub $mergefile

cd -
