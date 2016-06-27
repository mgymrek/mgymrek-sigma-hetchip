#!/bin/bash

HOMEDIR=""
BAMDIR=${HOMEDIR}/het_chip/mapping/
OUTDIR=${HOMEDIR}/het_chip/peaks/
PREFIXES=$(ls ${BAMDIR}/*.bowtie.sorted.bam | awk -F"/" '{print $NF}' | cut -f 1 -d'.' | grep -v input)
PEAKSDIR=${OUTDIR}/beds/
MARKS="H3K4me3 H3K4me1 H3K27ac"
BEDDIR=$PEAKSDIR
