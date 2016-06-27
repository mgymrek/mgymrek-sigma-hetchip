Define all parameters in count_params.sh before running. Scripts set up to run on the Broad Institute's LSF.

./run.sh runs the necessary scripts to test for allele specific chip signal at each SNP. It runs:

* ./allele_count_bam.sh: Count reads supporting each allele at each position
* ./get_allele_skew.py: Called by ./allele_count_bam.sh. Performs binomial test on ref vs. alt counts for each position
* ./metap_counts.py: Combine p-values across samples using Fisher's method