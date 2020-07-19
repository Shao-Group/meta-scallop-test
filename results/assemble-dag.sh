#!/bin/bash

#id="sra-hisat-ref-A02"
id="gtex2377-A21"
list=/gpfs/group/mxs2589/default/qqz5133/gtex/meta-scallop/bamlist/2377.txt
chrm=/gpfs/group/mxs2589/default/qqz5133/gtex/meta-scallop/bamlist/chr.list

cores="20"
threads="40"

dir=`pwd`
cur=$dir/$id
pbsdir=$cur/pbs
mkdir -p $pbsdir

#list=/storage/home/mxs2589/shared/projects/aletsch-test/data/sra-100-hisat-ref.list
#chrm=/storage/home/mxs2589/shared/projects/aletsch-test/data/chrm.list

ref=/storage/home/mxs2589/shared/data/gencode/GRCh38/gencode.v33.annotation.gtf
#ref=/gpfs/group/mxs2589/default/shared/data/ensembl/release-97/GRCh38/Homo_sapiens.GRCh38.97.gtf

#metadir=/home/mxs2589/shao/project/aletsch
metadir=/storage/home/mxs2589/shared/projects/aletsch
cd $metadir
mid=`git log | grep commit | head -n 1 | cut -f 2 -d " " | cut -c 1-6`
meta=$cur/aletsch-$mid
cp $metadir/build/aletsch $meta
cd -

cd $pbsdir

dagfile=$pbsdir/submit.dag

# profiling
pbsfile=$pbsdir/profile.pbs
echo "#!/bin/bash" > $pbsfile
echo "#PBS -l nodes=1:ppn=$cores" >> $pbsfile
echo "#PBS -l mem=180gb" >> $pbsfile
echo "#PBS -l walltime=100:00:00" >> $pbsfile
echo "#PBS -A mxs2589_b_g_sc_default" >> $pbsfile
echo "$dir/aletsch-profile.sh $id $threads $list $cur profiles $meta" >> $pbsfile

echo "JOB profile $pbsfile" > $dagfile

# individual chrm
dag1="PARENT profile CHILD"
dag2="PARENT" 
for k in `cat $chrm`
do
	kk=`echo $k | cut -c 1-6`
	pbsfile=$pbsdir/$kk
	echo "#!/bin/bash" > $pbsfile
	echo "#PBS -l nodes=1:ppn=$cores" >> $pbsfile
	echo "#PBS -l mem=180gb" >> $pbsfile
	echo "#PBS -l walltime=100:00:00" >> $pbsfile
	echo "#PBS -A mxs2589_b_g_sc_default" >> $pbsfile
	echo "$dir/aletsch-chrm.sh $id $threads $list $k $cur/profiles $cur/$kk $meta $ref" >> $pbsfile

	echo "JOB $kk $pbsfile" >> $dagfile
	dag1="$dag1 $kk"
	dag2="$dag2 $kk"
done

# merge 
mergefile=$pbsdir/merge.pbs
echo "#!/bin/bash" > $mergefile
#echo "#PBS -W depend=$dep" >> $mergefile
echo "#PBS -l nodes=1:ppn=$cores" >> $mergefile
echo "#PBS -l mem=180gb" >> $mergefile
echo "#PBS -l walltime=100:00:00" >> $mergefile
echo "#PBS -A mxs2589_b_g_sc_default" >> $mergefile
echo "$dir/aletsch-combine.sh $id $threads $list $chrm $cur $ref" >> $mergefile
echo "JOB combine $mergefile" >> $dagfile
dag2="$dag2 CHILD combine"

echo $dag1 >> $dagfile
echo $dag2 >> $dagfile

module use /gpfs/group/dml129/default/sw/modules
module load pbstools
dagsub $dagfile

cd -
