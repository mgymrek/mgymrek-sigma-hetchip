#!/bin/bash

source peak_params.sh
set -e

for prefix in ${PREFIXES}
do
    bamfile=${BAMDIR}/${prefix}.bowtie.rmdup.sorted.bam
    tagdir=${OUTDIR}/${prefix}
    bsub -q week -eo ${OUTDIR}/log/${prefix}.tag.err \
        -oo ${OUTDIR}/log/${prefix}.tag.out \
        -J maketags \
        makeTagDirectory ${tagdir} ${bamfile}
done

