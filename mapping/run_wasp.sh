#!/bin/bash

source mapping_params.sh
set -e


for prefix in $PREFIXES
do
    echo "*********** ${prefix} ************"
    echo "[Step 1] Pull out region from alignment..."
    samtools view -b -q 10 ${OUTDIR}/${prefix}.bowtie.sorted.bam ${REGION} > ${OUTDIR}/${prefix}.region.round1.bam
    samtools index ${OUTDIR}/${prefix}.region.round1.bam

    echo "[Step 2] Finding intersecting SNPs..."
    python /humgen/atgu1/fs03/wip/gymrek/workspace/WASP/mapping/find_intersecting_snps.py \
        -p \
        ${prefix}.region.round1.bam \
        ${SNPDIR}

    echo "[Step 3] Remap..."
    bowtie2 ${REFFA} \
        -1 ${OUTDIR}/${prefix}.region.round1.remap.fq1.gz \
        -2 ${OUTDIR}/${prefix}.region.round1.remap.fq2.gz \
        | samtools view -b - > ${prefix}.region.round2.bam

    echo "[Step 4] Filter mapped reads..."
    python /humgen/atgu1/fs03/wip/gymrek/workspace/WASP/mapping/filter_remapped_reads.py \
        -p \
        ${prefix}.region.round1.to.remap.bam \
        ${prefix}.region.round2.bam \
        ${prefix}.region.round2.keep.bam \
        ${prefix}.region.round1.to.remap.num.gz
    samtools merge -f ${prefix}.region.keep.merged.bam ${prefix}.region.round1.keep.bam ${prefix}.region.round2.keep.bam
    samtools sort -o ${prefix}.region.keep.merged.sorted.bam ${prefix}.region.keep.merged.bam
    samtools index ${prefix}.region.keep.merged.sorted.bam

    echo "[Step 5] Rmdup..."
    python /humgen/atgu1/fs03/wip/gymrek/workspace/WASP/mapping/rmdup_pe.py \
        ${prefix}.region.keep.merged.sorted.bam \
        ${prefix}.region.keep.merged.rmdup.bam
    samtools sort -o ${prefix}.region.keep.merged.sorted.rmdup.bam ${prefix}.region.keep.merged.rmdup.bam
    samtools index ${prefix}.region.keep.merged.sorted.rmdup.bam

    echo "[Cleanup] ..."
    rm ${prefix}.region.keep.merged.rmdup.bam
    rm ${prefix}.region.keep.merged.sorted.bam
    rm ${prefix}.region.keep.merged.sorted.bam.bai
    rm ${prefix}.region.keep.merged.bam
    rm ${prefix}.region.round1.keep.bam
    rm ${prefix}.region.round2.keep.bam
    rm ${prefix}.region.round2.bam
    rm ${prefix}.region.round1.remap.fq1.gz
    rm ${prefix}.region.round1.remap.fq2.gz
    rm ${prefix}.region.round1.to.remap.num.gz
    rm ${prefix}.region.round1.sort.bam
    rm ${prefix}.region.round1.to.remap.bam
done
