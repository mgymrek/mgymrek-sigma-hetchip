#!/bin/bash

source mapping_params.sh

for prefix in $PREFIXES
do
    bsub -q week -R"rusage[mem=5000]" \
        -eo ${OUTDIR}/log/${prefix}.bowtie.err -oo ${OUTDIR}/log/${prefix}.bowtie.out \
        -J ${prefix}.bowtie \
        bowtie2 ${REFFA} \
        -1 ${FASTQDIR}/${prefix}_R1.fastq.gz \
        -2 ${FASTQDIR}/${prefix}_R2.fastq.gz \
        -S ${OUTDIR}/${prefix}.bowtie.sam
    bsub -q hour -eo ${OUTDIR}/log/${prefix}.tobam.err -oo ${OUTDIR}/log/${prefix}.tobam.out \
        -w "done(${prefix}.bowtie)" \
        sh -c "samtools view -b ${OUTDIR}/${prefix}.bowtie.sam | samtools sort -T ${prefix} -o ${OUTDIR}/${prefix}.bowtie.sorted.bam -; samtools index ${OUTDIR}/${prefix}.bowtie.sorted.bam"
done
