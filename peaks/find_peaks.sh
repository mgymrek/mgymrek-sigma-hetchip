#!/bin/bash

set -e
source peak_params.sh

for prefix in ${PREFIXES}
do
    tagdir=${OUTDIR}/${prefix}
    donor=$(echo $prefix | cut -f 1 -d'_')
    inputdir=${OUTDIR}/input_${donor}
    bsub -q hour -eo log/${prefix}.peaks.err -oo log/${prefix}.peaks.out \
        -J ${prefix}.peaks \
        findPeaks ${tagdir} -style histone -o auto -i ${inputdir}
    bsub -q hour -eo log/${prefix}.convert.err -oo log/${prefix}.convert.out -w"done(${prefix}.peaks)" \
        sh -c "pos2bed.pl ${tagdir}/regions.txt > ${PEAKSDIR}/${prefix}_peaks.bed"
done

