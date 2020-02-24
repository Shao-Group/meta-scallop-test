#!/bin/bash

# copy smartseq2 
cur=`pwd`/smartseq2.roc
mkdir -p $cur

cp ../results/smartseq2-S02/assemble-X30/roc $cur/graphmerge-30.roc
cp ../results/smartseq2-S02/assemble-X76/roc $cur/graphmerge-76.roc
cp ../results/smartseq2-S02/single-S01/gtfmerge/roc $cur/gtfmerge-76.roc

# copy files for egeuv6 dataset
cur=`pwd`/egeuv6.roc
mkdir -p $cur

cp ../results/egeuv6.psiclass/X2-5/roc $cur/psiclass-5.roc
cp ../results/egeuv6.psiclass/X2-10/roc $cur/psiclass-10.roc
cp ../results/egeuv6.psiclass/X2-50/roc $cur/psiclass-50.roc
cp ../results/egeuv6.psiclass/X2-100/roc $cur/psiclass-100.roc

cp ../results/egeuv6-S01/assemble-X5/roc $cur/graphmerge-5.roc
cp ../results/egeuv6-S01/assemble-X50/roc $cur/graphmerge-50.roc
cp ../results/egeuv6-S01/assemble-X10/roc $cur/graphmerge-10.roc
cp ../results/egeuv6-S01/assemble-X100/roc $cur/graphmerge-100.roc
cp ../results/egeuv6-S01/assemble-M55/roc $cur/graphmerge-all.roc

cp ../results/egeuv6-S01/single-S01/gtfmerge/roc-5 $cur/gtfmerge-5.roc
cp ../results/egeuv6-S01/single-S01/gtfmerge/roc-10 $cur/gtfmerge-10.roc
cp ../results/egeuv6-S01/single-S01/gtfmerge/roc-50 $cur/gtfmerge-50.roc
cp ../results/egeuv6-S01/single-S01/gtfmerge/roc-100 $cur/gtfmerge-100.roc
cp ../results/egeuv6-S01/single-S01/gtfmerge/roc $cur/gtfmerge-all.roc

cp ../results/egeuv6-S01/assemble-X100.2.10/roc $cur/graphmerge-100.2.10.roc
cp ../results/egeuv6-S01/assemble-X100.3.5/roc $cur/graphmerge-100.3.5.roc
cp ../results/egeuv6-S01/assemble-X100.3.10/roc $cur/graphmerge-100.3.10.roc
cp ../results/egeuv6-S01/assemble-X100.4.5/roc $cur/graphmerge-100.4.5.roc
cp ../results/egeuv6-S01/assemble-X100.4.10/roc $cur/graphmerge-100.4.10.roc
cp ../results/egeuv6-S01/assemble-X100.5.5/roc $cur/graphmerge-100.5.5.roc

cp ../results/egeuv6-S01/assemble-X100.2.10/roc $cur/graphmerge-100.2.10.roc
cp ../results/egeuv6-S01/assemble-X100.2.20/roc $cur/graphmerge-100.2.20.roc
cp ../results/egeuv6-S01/assemble-X100.2.30/roc $cur/graphmerge-100.2.30.roc
cp ../results/egeuv6-S01/assemble-X100.2.40/roc $cur/graphmerge-100.2.40.roc
cp ../results/egeuv6-S01/assemble-X100.2.50/roc $cur/graphmerge-100.2.50.roc
cp ../results/egeuv6-S01/assemble-X100.5.10/roc $cur/graphmerge-100.5.10.roc
cp ../results/egeuv6-S01/assemble-X100.5.20/roc $cur/graphmerge-100.5.20.roc
cp ../results/egeuv6-S01/assemble-X100.5.30/roc $cur/graphmerge-100.5.30.roc
cp ../results/egeuv6-S01/assemble-X100.5.40/roc $cur/graphmerge-100.5.40.roc
cp ../results/egeuv6-S01/assemble-X100.5.50/roc $cur/graphmerge-100.5.50.roc
cp ../results/egeuv6-S01/assemble-X100.10.10/roc $cur/graphmerge-100.10.10.roc
cp ../results/egeuv6-S01/assemble-X100.10.20/roc $cur/graphmerge-100.10.20.roc
cp ../results/egeuv6-S01/assemble-X100.10.30/roc $cur/graphmerge-100.10.30.roc
cp ../results/egeuv6-S01/assemble-X100.10.40/roc $cur/graphmerge-100.10.40.roc
cp ../results/egeuv6-S01/assemble-X100.10.50/roc $cur/graphmerge-100.10.50.roc
