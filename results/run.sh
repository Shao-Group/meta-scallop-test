#!/bin/bash

cd gtex20-ST2-taco02
gtfcuff roc gffcmp.taco.gtf.tmap 200784 cov > roc.mul
gtfcuff roc gffall.taco.gtf.tmap 225920 cov > roc.all
cd -

cd gtex100-ST2-taco02
gtfcuff roc gffcmp.taco.gtf.tmap 200784 cov > roc.mul
gtfcuff roc gffall.taco.gtf.tmap 225920 cov > roc.all
cd -

cd gtex500-ST2-taco02
gtfcuff roc gffcmp.taco.gtf.tmap 200784 cov > roc.mul
gtfcuff roc gffall.taco.gtf.tmap 225920 cov > roc.all
cd -

cd gtex2377-ST2-taco02
gtfcuff roc gffcmp.taco.gtf.tmap 200784 cov > roc.mul
gtfcuff roc gffall.taco.gtf.tmap 225920 cov > roc.all
cd -

exit

cd gtex20-A10
gtfcuff roc gffcmp.meta.gtf.tmap 200784 cov > roc.mul
gtfcuff roc gffall.meta.gtf.tmap 225920 cov > roc.all
cd -

cd gtex100-A10
gtfcuff roc gffcmp.meta.gtf.tmap 200784 cov > roc.mul
gtfcuff roc gffall.meta.gtf.tmap 225920 cov > roc.all
cd -

cd gtex500-A10
gtfcuff roc gffcmp.meta.gtf.tmap 200784 cov > roc.mul
gtfcuff roc gffall.meta.gtf.tmap 225920 cov > roc.all
cd -

cd gtex2377-A10
gtfcuff roc gffcmp.meta.gtf.tmap 200784 cov > roc.mul
gtfcuff roc gffall.meta.gtf.tmap 225920 cov > roc.all
cd -

