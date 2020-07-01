#!/bin/bash

#module load gcc/5.3.1

#| mxs2589_b_g_hc_default  |     43680 |     43680 | 100% |     1 |  20 |
#| mxs2589_b_g_sc_default  |     87360 |     73463 |  84% |     2 |  20 |

dir=/gpfs/group/mxs2589/default/shared/projects/meta-scallop-test/results

qsub -l nodes=1:ppn=20 -l mem=240gb -l walltime=10:00:00 -A mxs2589_b_g_sc_default $dir/aci-mixed.sh A01 20
#qsub -l nodes=1:ppn=20 -l mem=1000gb -l walltime=10:00:00 -A mxs2589_b_g_hc_default $dir/aci-mixed.sh A01 20

exit

qsub -l nodes=1:ppn=20 -l mem=240gb -l walltime=10:00:00 -A mxs2589_b_g_sc_default $dir/aci-egeuv6.sh F02-B 20
qsub -l nodes=1:ppn=20 -l mem=240gb -l walltime=10:00:00 -A mxs2589_b_g_sc_default $dir/aci-egeuv6.sh F02-C 50
qsub -l nodes=1:ppn=20 -l mem=240gb -l walltime=10:00:00 -A mxs2589_b_g_sc_default $dir/aci-egeuv6.sh F02-D 100
