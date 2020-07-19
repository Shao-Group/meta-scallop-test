#!/bin/bash

#id="sra-hisat-ref-A02"
id="gtex20-A11"
cores="20"
threads="40"

dir=`pwd`
cur=$dir/$id
pbsdir=$cur/pbs
mkdir -p $pbsdir

list=/gpfs/group/mxs2589/default/qqz5133/gtex/meta-scallop/bamlist/20.txt
chrm=/gpfs/group/mxs2589/default/qqz5133/gtex/meta-scallop/bamlist/chr.list

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

#profiles=/storage/home/mxs2589/shared/projects/aletsch-test/results/gtex500-A01/pro
#cp -r $profiles $cur/profiles

# profiling
pbsfile=$pbsdir/profile.pbs
echo "#!/bin/bash" > $pbsfile
echo "#PBS -l nodes=1:ppn=$cores" >> $pbsfile
echo "#PBS -l mem=120gb" >> $pbsfile
echo "#PBS -l walltime=100:00:00" >> $pbsfile
echo "#PBS -A mxs2589_b_g_sc_default" >> $pbsfile
echo "$dir/aletsch-profile.sh $id $threads $list $cur profiles $meta" >> $pbsfile

#qsub $pbsfile
#exit

# individual chrm
dep="afterok"
for k in `cat $chrm`
do
	kk=`echo $k | cut -c 1-6`
	pbsfile=$pbsdir/$kk
	echo "#!/bin/bash" > $pbsfile
#echo "#PBS -W depend=afterok:$pid" >> $pbsfile
	echo "#PBS -l nodes=1:ppn=$cores" >> $pbsfile
	echo "#PBS -l mem=120gb" >> $pbsfile
	echo "#PBS -l walltime=100:00:00" >> $pbsfile
	echo "#PBS -A mxs2589_b_g_sc_default" >> $pbsfile
	echo "$dir/aletsch-chrm.sh $id $threads $list $k $cur/profiles $cur/$kk $meta $ref" >> $pbsfile

	kid=`qsub $pbsfile | tail -n 1 | cut -f 1 -d "."`
	dep="$dep:$kid"
done

# merge 
mergefile=$pbsdir/merge.pbs
echo "#!/bin/bash" > $mergefile
#echo "#PBS -W depend=$dep" >> $mergefile
echo "#PBS -l nodes=1:ppn=$cores" >> $mergefile
echo "#PBS -l mem=120gb" >> $mergefile
echo "#PBS -l walltime=100:00:00" >> $mergefile
echo "#PBS -A mxs2589_b_g_sc_default" >> $mergefile
echo "$dir/aletsch-combine.sh $id $threads $list $chrm $cur $ref" >> $mergefile

#qsub $mergefile

cd -
