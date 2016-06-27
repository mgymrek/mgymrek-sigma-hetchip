#!/bin/bash

# http://www.ncbi.nlm.nih.gov/sra/?term=SRA066400
# SRR1649364 k4me3
# SRR1649355 k27ac
# SRR1649363 k4me1
# http://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.1004648
# SRR1642053 k27ac
# SRR1642054 k4me1

ACCS="SRR1642053 SRR1642054 SRR1649363 SRR1649355 SRR1649364"
for acc in ${ACCS}
do
    bsub -q hour -W 4:00 -eo log/${acc}.err -oo log/${acc}.out \
        fastq-dump --split-spot ${acc}
done
