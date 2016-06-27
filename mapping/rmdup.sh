#!/bin/bash

source mapping_params.sh

for prefix in $PREFIXES
do
    bsub -q week -R"rusage[mem=5000]" \
        -eo ${OUTDIR}/log/${prefix}.rmdup.err -oo ${OUTDIR}/log/${prefix}.rmdup.out \
        -J ${prefix}.rmdup \
        sh -c "samtools rmdup ${OUTDIR}/${prefix}.bowtie.sorted.bam ${OUTDIR}/${prefix}.bowtie.rmdup.sorted.bam && samtools index ${OUTDIR}/${prefix}.bowtie.rmdup.sorted.bam"
done
