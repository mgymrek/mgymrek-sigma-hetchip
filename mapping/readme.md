# Mapping using WASP

Define all parameters in mapping_params.sh before running. Scripts set up to run on the Broad Institute's LSF.

* Align reads using Bowtie2: ./run_bowtie_hetchip.sh
* Process using WASP: ./run_wasp.sh

# Processing for peak calling
* Remove duplicates: ./rmdup.sh 