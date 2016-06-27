#!/bin/bash

source count_params.sh

# Get allele counts and binomial p-values - wasp bams
for bam in $(ls ${BAMDIR}/*region.keep.merged.sorted.rmdup.bam)
do
    echo ${bam}
    ./allele_count_bam.sh ${bam} | sort -k 2 -n > $(basename $bam .region.keep.merged.sorted.rmdup.bam)_counts.txt
done

# Get table after intersecting with peaks
MARKS="H3K27ac H3K4me1 H3K4me3"
for mark in $MARKS
do
    ./metap_counts.py d1_wcl_${mark}_counts.txt d3_wcl_${mark}_counts.txt d6_wcl_${mark}_counts.txt > \
        sigma_chiphet_snptests_${mark}.tab
    cat sigma_chiphet_snptests_${mark}.tab | grep -v chrom | intersectBed -a stdin -b ../peaks/beds/${mark}_mergedpeaks.bed
done > tmp

# Add input
./metap_counts.py input_d1_counts.txt input_d3_counts.txt input_d6_counts.txt > sigma_chiphet_snptests_input.tab
cat sigma_chiphet_snptests_input.tab | grep -v chrom >> tmp
head -n 1 sigma_chiphet_snptests_H3K27ac.tab > sigma_chiphet_alleleskew_table.tab
cat tmp >> sigma_chiphet_alleleskew_table.tab
