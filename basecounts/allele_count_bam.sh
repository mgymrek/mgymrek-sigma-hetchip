#!/bin/bash

source count_params.sh
BAMFILE=$1

samtools mpileup -Q 0 -f ${REFFA} ${BAMFILE} | \
    awk '{print $1 "\t" $2 "\t" $2+1 "\t" "x"$5}' | \
    intersectBed -a stdin -b slc16a11_snps.bed -wa -wb | \
    sed 's/x//' | cut -f 5-7 --complement | \
    ./get_allele_skew.py -
