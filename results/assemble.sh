#!/bin/bash

id="gtex2377-A01"
cores="20"
threads="40"
dir=`pwd`
pbsdir=$dir/$id/pbs

#list=/gpfs/group/mxs2589/default/shared/projects/meta-scallop-test/data/gtex-100.list
list=/gpfs/group/mxs2589/default/qqz5133/gtex/meta-scallop/bamlist/2377.txt
chrm=/gpfs/group/mxs2589/default/qqz5133/gtex/meta-scallop/bamlist/chr.list
#list=/storage/home/mxs2589/shared/projects/aletsch-test/data/pacbio-100.list
#chrm=/storage/home/mxs2589/shared/projects/aletsch-test/data/chrm.list

#ref=/gpfs/group/mxs2589/default/shared/data/gencode/GRCh37/gencode.v33lift37.annotation.gtf
#ref=/gpfs/group/mxs2589/default/shared/data/ensembl/release-97/GRCh38/Homo_sapiens.GRCh38.97.gtf
#ref=/storage/home/mxs2589/shared/data/ensembl/human.0/GRCh38/Homo_sapiens.GRCh38.84.gtf
ref=/storage/home/mxs2589/shared/data/gencode/GRCh38/gencode.v33.annotation.gtf

refnum=200827
refnum=199669
refnum=170378

mkdir -p $pbsdir
cd $pbsdir

# profiling
pbsfile=$pbsdir/profile.pbs
echo "#!/bin/bash" > $pbsfile
echo "#PBS -l nodes=1:ppn=$cores" >> $pbsfile
echo "#PBS -l mem=180gb" >> $pbsfile
echo "#PBS -l walltime=500:00:00" >> $pbsfile
echo "#PBS -A mxs2589_b_g_sc_default" >> $pbsfile
echo "sleep 120" >> $pbsfile
echo "$dir/run-profile.sh $id $threads $list" >> $pbsfile

pid=`qsub $pbsfile | tail -n 1 | cut -f 1 -d "."`

# individual chrm
dep="afterok"
for k in `cat $chrm`
do
	pbsfile=$pbsdir/$k
	echo "#!/bin/bash" > $pbsfile
	echo "#PBS -W depend=afterok:$pid" >> $pbsfile
	echo "#PBS -l nodes=1:ppn=$cores" >> $pbsfile
	echo "#PBS -l mem=180gb" >> $pbsfile
	echo "#PBS -l walltime=500:00:00" >> $pbsfile
	echo "#PBS -A mxs2589_b_g_sc_default" >> $pbsfile
	echo "$dir/run-chrm.sh $id $threads $list $k" >> $pbsfile

	kid=`qsub $pbsfile | tail -n 1 | cut -f 1 -d "."`
	dep="$dep:$kid"
done

# merge 
mergefile=$pbsdir/merge.pbs
echo "#!/bin/bash" > $mergefile
echo "#PBS -W depend=$dep" >> $mergefile
echo "#PBS -l nodes=1:ppn=$cores" >> $mergefile
echo "#PBS -l mem=180gb" >> $mergefile
echo "#PBS -l walltime=500:00:00" >> $mergefile
echo "#PBS -A mxs2589_b_g_sc_default" >> $mergefile
echo "$dir/run-merge.sh $id $threads $list $chrm $ref $refnum" >> $mergefile
qsub $mergefile

cd -
