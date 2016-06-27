Define all parameters in mapping_params.sh before running. Scripts set up to run on the Broad Institute's LSF.

# Mapping using WASP

* Align reads using Bowtie2: ./run_bowtie_hetchip.sh
* Process using WASP: ./run_wasp.sh

# Processing for peak calling
* Remove duplicates: ./rmdup.sh 

# Versions used
* [Bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/manual.shtml) 2.0.6
* [WASP](https://github.com/bmvdgeijn/WASP/commit/467651c6a33c8878613023cd42fa59f248a0df3c) commit 467651c
* [Samtools](https://sourceforge.net/projects/samtools/files/samtools/1.3/) 1.3