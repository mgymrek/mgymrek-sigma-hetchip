#!/bin/bash

HOMEDIR="" 
REFFA=${HOMEDIR}/bowtie/hg19 # Bowtie reference files
FASTQDIR="" # Fill this in with path to fastq folder
PREFIXES=$(ls ${FASTQDIR}/*R1* | awk -F"/" '{print $NF}' | cut -f 1 -d'.' | sed 's/_R1//')
OUTDIR=${HOMEDIR}/het_chip/mapping
SNPDIR=${HOMEDIR}/het_chip/mapping/SNP_files/
REGION=chr17:6841625-7053558


