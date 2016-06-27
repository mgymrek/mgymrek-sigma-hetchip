#!/bin/bash

source peak_params.sh

for mark in $MARKS
do
    bed1=${BEDDIR}/d1_wcl_${mark}_peaks.bed
    bed2=${BEDDIR}/d3_wcl_${mark}_peaks.bed
    bed3=${BEDDIR}/d6_wcl_${mark}_peaks.bed
    cat ${bed1} | sort -k1,1 -k2,2n > ${bed1}.sorted.bed
    cat ${bed2} | sort -k1,1 -k2,2n > ${bed2}.sorted.bed
    cat ${bed3} | sort -k1,1 -k2,2n > ${bed3}.sorted.bed
    multiIntersectBed -i ${bed1}.sorted.bed -i ${bed2}.sorted.bed -i ${bed3}.sorted.bed | \
        awk '($4==3)' > ${BEDDIR}/${mark}_mergedpeaks.bed
done
