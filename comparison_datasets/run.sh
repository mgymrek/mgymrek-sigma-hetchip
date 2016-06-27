#!/bin/bash

HOMEDIR=""
REFFA=${HOMEDIR}/genomes/bowtie/hg19
OUTDIR=${HOMEDIR}/het_chip/comparison_datasets
ACCS="SRR1649363 SRR1649355 SRR1649364 SRR1642053 SRR1642054"
REGION=chr17:6841625-7053558

for acc in ${ACCS}
do
    # Align with Bowtie
    bsub -q hour -W 4:00 -eo ${OUTDIR}/log/${acc}.align.err -oo ${OUTDIR}/log/${acc}.align.out \
        -R"rusage[mem=5000]" \
        -J ${acc}.align \
        bowtie2 ${REFFA} \
        -U ${OUTDIR}/${acc}.fastq \
        -S ${OUTDIR}/${acc}.bowtie.sam
    # Convert to BAM
    bsub -q hour -eo ${OUTDIR}/log/${acc}.tobam.err -oo ${OUTDIR}/log/${acc}.tobam.out \
        -w "ended(${acc}.align)" \
        -J ${acc}.tobam \
        sh -c "samtools view -b ${OUTDIR}/${acc}.bowtie.sam | samtools sort -T ${acc} -o ${OUTDIR}/${acc}.bowtie.sorted.bam -; samtools index ${OUTDIR}/${acc}.bowtie.sorted.bam"
    # Rmdup
    bsub -q hour -eo ${OUTDIR}/log/${acc}.rmdup.err -oo ${OUTDIR}/log/${acc}.rmdup.out \
        -w "ended(${acc}.tobam)" \
        -J ${acc}.rmdup \
        sh -c "samtools rmdup ${OUTDIR}/${acc}.bowtie.sorted.bam ${OUTDIR}/${acc}.bowtie.rmdup.sorted.bam && samtools index ${OUTDIR}/${acc}.bowtie.rmdup.sorted.bam"
    # Pull out region
    bsub -q hour -eo ${OUTDIR}/log/${acc}.region.err -oo ${OUTDIR}/log/${acc}.region.out \
        -w "ended(${acc}.rmdup)" \
        -J ${acc}.region \
        sh -c "samtools view -b ${acc}.bowtie.rmdup.sorted.bam ${REGION} > ${acc}.region.bam && samtools index ${acc}.region.bam"
done
